
import CoreData
import UIKit

final class CoreDataManager {
    // 싱글톤 패턴을 사용해서 어디서든 CoreDataManager.shared로 접근할 수 있게 함
    static let shared = CoreDataManager()
    private init() {}
    
    // CoreData의 저장소(= 데이터베이스)를 앱에 로드함, 이 안에는 SQLite 백엔드가 자동으로 설정됨
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyModel") // ← .xcdatamodeld 파일명
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // 앱 전역에서 사용할 컨텍스트를 간편하게 접근할 수 있도록 별도 프로퍼티로 노출
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // 컨텍스트 저장
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("falied to save context: \(error)")
            }
        }
    }
    
    // 중복여부 확인
    func containFavoriteCode(code: String) -> Bool {
        let fetch: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest() // fetch 요청
        // SELECT * FROM FavoriteCurrency WHERE code == 'USD' 와 같은 쿼리 역할
        fetch.predicate = NSPredicate(format: "code == %@", code)
        let count = (try? context.count(for: fetch)) ?? 0 // 결과 카운트
        return count > 0 // 있다면 true, 없으면 false
    }
    
    // 즐겨찾기 추가
    func addFavorite(code: String) {
        guard !containFavoriteCode(code: code) else { return } // 중복저장 방지
        let entity = FavoriteCurrency(context: context) // 컨텍스트에 연결
        entity.code = code // 생성한 FavoriteCurrency 객체의 code 속성에 값을 설정
        saveContext() // 실제 DB에 저장 요청을 보냄
    }
    
    // 즐겨찾기 삭제
    func removeFavorite(code: String) {
        // contain에서 사용한 fetch로 찾음
        let fetch: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        fetch.predicate = NSPredicate(format: "code == %@", code)
        
        if let results = try? context.fetch(fetch) { // fetch하면 배열로 받음
            for object in results { // 결과를 순회하면서 삭제
                context.delete(object)
            }
            saveContext() // DB에 저장 요청
        }
    }
    
    // 전체 코드 조회
    func fetchAllFavoriteCodes() -> [String] {
        let fetch: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        let results = (try? context.fetch(fetch)) ?? [] // SELECT ALL
        return results.compactMap { $0.code } // nil이 아닌 값 추출해서 배열로 반환
    }
    
    /* 환율정보 저장관련 */
    
    // Currency 저장
    func addCurrencyData(_ currency: Currency) {
        let dateKey = formatDate(currency.timeLastUpdateUtc)
        guard isNewCurrency(dateKey: dateKey) else { return }
        let snapshot = CurrencySnapshot(context: context)
        snapshot.dateKey = dateKey
        snapshot.timestamp = currency.timeLastUpdateUtc
        snapshot.baseCode = currency.baseCode
        snapshot.ratesJSON = encodeRates(currency.rates)
        saveContext()
    }
    
    // dateKey용 날짜변환
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    // rate 인코드
    private func encodeRates(_ rates: [String: Double]) -> String {
        do {
            let data = try JSONEncoder().encode(rates)
            return String(data: data, encoding: .utf8)!
        } catch {
            print("encodeRates Error: \(error)")
            return ""
        }
    }
    
    // 새 환율 데이터인지 체크하는 함수
    func isNewCurrency(dateKey: String) -> Bool {
        let fetch: NSFetchRequest<CurrencySnapshot> = CurrencySnapshot.fetchRequest()
        fetch.predicate = NSPredicate(format: "dateKey == %@", dateKey)
        let result = try? context.fetch(fetch)
        cleanUpOldCurrencySnapshots() // 오래된 데이터 삭제 함수 호출
        return result?.isEmpty ?? true
    }
    
    // 가장 최근의 데이터를 추출
    func beforeCurrencyData(before date: Date) -> CurrencySnapshot? {
        let fetch: NSFetchRequest<CurrencySnapshot> = CurrencySnapshot.fetchRequest()
        fetch.predicate = NSPredicate(format: "timestamp < %@", date as NSDate)
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetch.fetchLimit = 1
        return try? context.fetch(fetch).first
    }
    
    // 모든 데이터 추출함수
    func fetchAllCurrencyData() -> [CurrencySnapshot] {
        let fetch: NSFetchRequest<CurrencySnapshot> = CurrencySnapshot.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return (try? context.fetch(fetch)) ?? []
    }
    
    // 초기 실행시 더미 투입함수
    func insertDummyIfNotExist() {
        let allData = fetchAllCurrencyData()
        guard allData.isEmpty else { return }
        let dummyData = TestData.testCurrencyDummy
        addCurrencyData(dummyData)
    }
    
    // 5건이 넘으면 삭제(임시)
    func cleanUpOldCurrencySnapshots(keeping maxCount: Int = 5) {
        let fetch: NSFetchRequest<CurrencySnapshot> = CurrencySnapshot.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)] // 오래된 순
        // if let 구문 ,로 이어가면 AND의 의미
        if let results = try? context.fetch(fetch), results.count > maxCount {
            // result 바인딩 + 카운트가 허용숫자를 넘었을 때 실행
            let excess = results.count - maxCount
            for i in 0 ..< excess {
                context.delete(results[i])
            }
            print("Deleted \(excess) old CurrencySnapshot(s).")
            saveContext()
        }
    }
    
    // 최종 화면 저장용
    
    func saveLastScrren(screenType: String, currencyCode: String?){
        let context = context
        
        // 기존 저장이 있으면 fetch
        let fetchRequest: NSFetchRequest<LastScreen> = LastScreen.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            // 있으면 객체의 속성을 수정 ?? 없으면 새로 생성
            let lastScreen = result.first ?? LastScreen(context: context)
            lastScreen.screenType = screenType
            lastScreen.currencyCode = currencyCode
            try context.save() // 저장
        } catch {
            print("Error saving last screen: \(error)")
        }
    }
    
    func loadLastScreen() -> (screenType: String?, currencyCode: String?)? {
        let context = context
        let fetchRequest: NSFetchRequest<LastScreen> = LastScreen.fetchRequest()
        
        do{
            let result = try context.fetch(fetchRequest)
            guard let lastScreen = result.first else { return nil }
            return (lastScreen.screenType, lastScreen.currencyCode)
            
        } catch {
            print("load last screen error: \(error)")
            return nil
        }
    }
}



