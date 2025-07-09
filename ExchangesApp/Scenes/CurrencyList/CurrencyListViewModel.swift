
import Foundation

class CurrencyListViewModel {
    // 프로퍼티 선언
    var allItems: [CurrencyItem] = [] // 전체 아이템
    var sortedItems: [CurrencyItem] = [] // 검색한 아이템
    private var currency: Currency? // JSON 파싱 통째로 보존
    var numberOfItems: Int { sortedItems.count } // 테이블 뷰에서 사용할 셀 개수

    // 클로저
    var onDataUpdated: (() -> Void)?

    // 객체 선언
    private let dataService = DataService()

    // 데이터 파싱 함수
    // completeion(.success(()))를 업데이트/에러 클로저 호출로 변경
    func fetchData(completeion: @escaping (Result<Void, Error>) -> Void) {
        dataService.fetchData { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(currency):
                self.currency = currency
                self.allItems = currency.rates.map { code, rate in
                    CurrencyItem(code: code, rate: rate, countryName: CurrencyCodeMap.codeToNationName[code] ?? "")
                }.sorted { $0.code < $1.code }
                self.sortedItems = self.allItems // 최초에 검색된 아이템에 전체 아이템 주입
                completeion(.success(()))
            case let .failure(error):
                completeion(.failure(error))
            }
        }
    }

    // 주어진 인덱스에 해당하는 환율 데이터를 반환
    func currencyItem(at index: Int) -> CurrencyItem? {
        guard index < sortedItems.count else { return nil }
        return sortedItems[index]
    }

    // 서치바에 입력된 키워드로 검색
    func updateSearchedData(_ keyword: String) {
        let searchedData = allItems.map { $0 }
            .filter { $0.code.lowercased().hasPrefix(keyword.lowercased()) || $0.countryName.lowercased().hasPrefix(keyword.lowercased()) }
        sortedItems = searchedData
        onDataUpdated?()
    }
}
