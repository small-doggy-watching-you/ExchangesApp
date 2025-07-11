
import UIKit
import CoreData


final class CoreDataManager {
    //싱글톤 패턴을 사용해서 어디서든 CoreDataManager.shared로 접근할 수 있게 함
    static let shared = CoreDataManager()
    private init() {}
    
    // CoreData의 저장소(= 데이터베이스)를 앱에 로드함, 이 안에는 SQLite 백엔드가 자동으로 설정됨
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteModel") // ← .xcdatamodeld 파일명
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
    func contains(code: String) -> Bool {
         let fetch: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest() // fetch 요청
        // SELECT * FROM FavoriteCurrency WHERE code == 'USD' 와 같은 쿼리 역할
         fetch.predicate = NSPredicate(format: "code == %@", code)
         let count = (try? context.count(for: fetch)) ?? 0 // 결과 카운트
         return count > 0 // 있다면 true, 없으면 false
     }
    
    
    // 즐겨찾기 추가
    func add(code: String) {
        guard !contains(code: code) else { return } // 중복저장 방지
        let entity = FavoriteCurrency(context: context) // 컨텍스트에 연결
        entity.code = code // 생성한 FavoriteCurrency 객체의 code 속성에 값을 설정
        saveContext() // 실제 DB에 저장 요청을 보냄
    }
    
    // 즐겨찾기 삭제
    func remove(code: String) {
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
    func fetchAllCodes() -> [String] {
        let fetch: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        let results = (try? context.fetch(fetch)) ?? [] // SELECT ALL
        return results.compactMap { $0.code } // nil이 아닌 값 추출해서 배열로 반환
    }
    

}
