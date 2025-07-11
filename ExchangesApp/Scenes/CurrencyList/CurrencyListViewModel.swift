
import Foundation

class CurrencyListViewModel: ViewModelProtocol {
    enum Action {
        case fetchdata // 데이터 파싱
        case updateSearchedData(String) // 서치 바에 검색어 입력시
        case favoriteToggle(Int)
    }

    struct State {
        var sortedItems: [CurrencyItem] // 검색한 아이템
        var numberOfItems: Int { sortedItems.count } // 테이블 뷰에서 사용할 셀 개수
    }

    // state
    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }

    // 프로퍼티 선언
    var allItems: [CurrencyItem] = [] // 전체 아이템
    private var currency: Currency? // JSON 파싱 통째로 보존

    // 클로저
    var onStateChanged: ((State) -> Void)? // 데이터 변화 감지
    var onError: ((Error) -> Void)? // 에러 발생 전달

    // 객체 선언
    private let dataService = DataService()

    // init
    init() {
        state = State(
            sortedItems: [],
        )
    }

    // action
    func action(_ action: Action) {
        switch action {
        case .fetchdata:
            fetchData()
        case let .updateSearchedData(keyword):
            updateSearchedData(keyword)
        case let .favoriteToggle(index):
            favoriteToggle(index)
        }
    }

    // 데이터 파싱 후 데이터 보존
    private func fetchData() {
        dataService.fetchData { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(currency):
                self.currency = currency
                self.allItems = currency.rates.map { code, rate in
                    CurrencyItem(
                        code: code,
                        rate: rate,
                        countryName: CurrencyCodeMap.codeToNationName[code] ?? ""
                    )
                }.sorted { $0.code < $1.code }
                state.sortedItems = customSort(self.allItems ) // 최초에 검색된 아이템에 전체 아이템 주입
            case let .failure(error):
                onError?(error)
            }
        }
    }

    // 서치바에 입력된 키워드로 검색
    private func updateSearchedData(_ keyword: String) {
        let searchedData = allItems.map { $0 }
            .filter { $0.code.lowercased().hasPrefix(keyword.lowercased()) || $0.countryName.lowercased().hasPrefix(keyword.lowercased()) }
        state.sortedItems = searchedData
    }
    
    // 즐겨찾기 버튼 토글
    private func favoriteToggle(_ index: Int){
        state.sortedItems[index].isFavorited.toggle()
        return state.sortedItems = customSort(state.sortedItems)
    }
    
    // 커스텀 정렬함수
    private func customSort(_ items: [CurrencyItem]) -> [CurrencyItem]{
        items.sorted{
            if $0.isFavorited != $1.isFavorited{ // 둘의 즐겨찾기 여부가 다르면
                // $0이 true고 $1이 false면 true를 반환 -> $0이 $1보다 먼저와야 하므로 즐겨찾기 순 정렬
                return $0.isFavorited && !$1.isFavorited
            } else {
                // 즐겨찾기 여부가 같으면 code 알파벳순
                return $0.code < $1.code
            }
        }
    }
    
}
