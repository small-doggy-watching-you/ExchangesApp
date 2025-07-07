
import Foundation

import Alamofire

class DataService {
    private let baseURL = "https://open.er-api.com/v6/latest/USD"

    func fetchData(completion: @escaping (Result<Currency, Error>) -> Void) {
        let decoder = JSONDecoder()

        // 파싱 떄 Date 타입 포매팅 설정 추가
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)

        AF.request(baseURL)
            .responseDecodable(of: Currency.self, decoder: decoder) { response in
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                    print(error)
                }
            }
    }
}
