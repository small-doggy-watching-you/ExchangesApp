
import Foundation

final class CalculatorViewModel: ViewModelProtocol {
    enum Atcion {
        case currencyExchange(String)
    }

    struct State {
        let currencyItem: CurrencyItem
        var currencyText: String {
            return "\(currencyItem.code)"
        }

        var countryNameText: String {
            return "\(currencyItem.countryName)"
        }

        var resultText: String
    }

    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }

    var onStateChanged: ((State) -> Void)?
    var onError: ((Error) -> Void)?

    // init
    init(currencyItem: CurrencyItem) {
        state = State(
            currencyItem: currencyItem,
            resultText: "계산 결과가 여기에 표시됩니다."
        )
    }

    func action(_ action: Atcion) {
        do {
            switch action {
            case .currencyExchange(let string):
                try currencyExchange(inputText: string)
            }

        } catch {
            onError?(error)
        }
    }

    private func currencyExchange(inputText: String) throws {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            throw InputError.emptyInput
        }
        guard let textToDouble = Double(trimmed) else {
            throw InputError.invalidNumber
        }

        if textToDouble < 0 {
            throw InputError.invalidNumber
        }

        let exchange = calculate(amount: textToDouble)
        let inputCurrencyText = String(format: "%.2f", textToDouble)
        let outputCurrencyText = String(format: "%.2f", exchange)

        state.resultText = "$\(inputCurrencyText) → \(outputCurrencyText) \(state.currencyItem.code)"
    }

    private func calculate(amount: Double) -> Double {
        return amount * state.currencyItem.rate
    }
}

extension CalculatorViewModel {
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
}
