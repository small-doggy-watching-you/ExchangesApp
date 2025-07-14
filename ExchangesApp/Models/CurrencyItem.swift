
// 화면 출력용 데이터 모델
class CurrencyItem {
    init(code: String, rate: Double, countryName: String, isFavorited: Bool, trendSymbol: SymbolMakingService.TrendSymbol) {
        self.code = code
        self.rate = rate
        self.countryName = countryName
        self.isFavorited = isFavorited
        self.trendSymbol = trendSymbol
    }

    let code: String // 통화 코드
    let rate: Double // 환율
    let countryName: String // 국가명
    var isFavorited: Bool = false // 즐겨찾기 등록여부
    let trendSymbol: SymbolMakingService.TrendSymbol // 뷰에서 사용할 심볼정보
}
