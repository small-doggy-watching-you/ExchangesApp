
import Foundation

class CalculatorViewModel {
    // 프로퍼티
    var currencyItem: CurrencyItem
    
    // 클로저
    var onDataUpdated: (() -> Void)?
    
    enum InputError: LocalizedError {
        case invalidNumber
        case emptyInput
        
        var errorDescription: String? {
            switch self {
            case .invalidNumber:
                return "올바른 숫자를 입력해주세요."
            case .emptyInput:
                return "금액을 입력해주세요."
            }
        }
    }

    
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
    
    var resultText: String = "계산 결과가 여기에 표시됩니다."
    
  
    func currencyExchange(inputText: String) throws {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
              throw InputError.emptyInput
          }
        guard let textToDouble = Double(trimmed) else {
            throw InputError.invalidNumber
        }
        
        let exchange = calculate(amount: textToDouble)
        let inputCurrencyText = String(format: "%.2f", textToDouble)
        let outputCurrencyText = String(format: "%.2f", exchange)
        
        resultText = "$\(inputCurrencyText) → \(outputCurrencyText) \(currencyItem.code)"
        
        onDataUpdated?()
    }
    
    func calculate(amount: Double) -> Double {
        return amount * currencyItem.rate
    }
}
