
import Foundation

final class CalculatorViewModel: ViewModelProtocol {
    enum Atcion {
        case currencyExchange(String)
    }

    struct State {
        // 전달받은 CurrencyItem 객체
        let currencyItem: CurrencyItem
        // 통화 코드
        var currencyText: String {
            return "\(currencyItem.code)"
        }
        // 국가명
        var countryNameText: String {
            return "\(currencyItem.countryName)"
        }
        // 변환 결과 보여줄 문자열
        var resultText: String
    }

    // state
    private(set) var state: State {
        didSet {
            onStateChanged?(state)
        }
    }
    // 클로저
    var onStateChanged: ((State) -> Void)? // 데이터 변화 감지
    var onError: ((Error) -> Void)? // 에러 감지

    // init
    init(currencyItem: CurrencyItem) {
        state = State(
            currencyItem: currencyItem,
            resultText: "계산 결과가 여기에 표시됩니다."
        )
    }
    
    // action
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

    // 변환결과 처리 함수
    private func currencyExchange(inputText: String) throws {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines) // 좌우공백제거
        if trimmed.isEmpty { // 빈 값일 경우 에러
            throw InputError.emptyInput
        }
        guard let textToDouble = Double(trimmed) else { // 숫자가 아닐 경우 에러
            throw InputError.invalidNumber
        }

        if textToDouble < 0 { // 음수일 경우 에러
            throw InputError.invalidNumber
        }

        let exchange = calculate(amount: textToDouble)
        let inputCurrencyText = String(format: "%.2f", textToDouble)
        let outputCurrencyText = String(format: "%.2f", exchange)

        state.resultText = "$\(inputCurrencyText) → \(outputCurrencyText) \(state.currencyItem.code)"
    }
    
    // 순수 환율 숫자 계산
    private func calculate(amount: Double) -> Double {
        return amount * state.currencyItem.rate
    }
}

extension CalculatorViewModel {
    // 환전 수치 입력용 사용자 정의 에러
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
