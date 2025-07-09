
import UIKit

import Alamofire

// 에러 창 정의
enum AlertFactory {
    static func errorAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        return alert
    }
}

// 에러 메시지 판별
enum ErrorMessageProvider {
    static func message(for error: Error) -> String {
        if let afError = error.asAFError {
            if let urlError = afError.underlyingError as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    return "인터넷 연결이 없습니다."
                case .timedOut:
                    return "요청 시간이 초과되었습니다."
                default:
                    return "네트워크 오류가 발생했습니다."
                }
            } else {
                return "서버 응답 처리 중 오류가 발생했습니다."
            }
        } else {
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
