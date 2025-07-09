
import Foundation

class CalculatorViewModel {
    var currencyItem: CurrencyItem

    // init
    init(currencyItem: CurrencyItem) {
        self.currencyItem = currencyItem
    }

    // 화폐코드 라벨용 텍스트
    var currencyText: String {
        return "\(currencyItem.code)"
    }

    // 국가명 라벨용 텍스트
    var counntryNameText: String {
        return "\(currencyItem.countryName)"
    }
    
    var outputText: String = ""
    
    func claculate(amount: String) -> Void {
        let input = Double(amount) ?? 0.0
        outputText = String(format: "%.2f", input * currencyItem.rate)
        print(outputText)
    }
}
