
// 화면 출력용 데이터 모델
class CurrencyItem {
    init(code: String, rate: Double, countryName: String, isFavorited: Bool, trendSymbol: SymbolMakingService.TrendSymbol) {
        self.code = code
        self.rate = rate
        self.countryName = countryName
        self.isFavorited = isFavorited
        self.trendSymbol = trendSymbol
    }

    let code: String
    let rate: Double
    let countryName: String
    var isFavorited: Bool = false
    let trendSymbol: SymbolMakingService.TrendSymbol
    
}
