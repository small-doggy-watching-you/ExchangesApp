
import Foundation

class CurrencyListViewModel {
    // 프로퍼티 선언부
    private let dataService = DataService()
    private var currency: Currency?
    private var sortedRates: [(key: String, value: Double)] = []
    var numberOfItems: Int { sortedRates.count } // 테이블 뷰에서 사용할 셀 개수

    // 데이터 파싱 함수
    func fetchData(completeion: @escaping (Result<Void, Error>) -> Void) {
        dataService.fetchData { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(currency):
                    self.currency = currency
                    self.sortedRates = currency.rates.sorted { $0.key < $1.key }
                    completeion(.success(()))
                case let .failure(error):
                    completeion(.failure(error))
                }
            }
        }
    }

    // 주어진 인덱스에 해당하는 환율 데이터를 반환
    func item(at index: Int) -> (key: String, value: Double)? {
        guard index < sortedRates.count else { return nil }
        return sortedRates[index]
    }
}
