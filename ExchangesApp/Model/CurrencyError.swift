//
//  CurrencyError.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/8/25.
//

enum CurrencyError: Error {
  
  case fileNotFound
  case decodingFailed(Error)
  case networkFailed(Error)
  case invalidURL
  case unknown
  
  var alertTitle: String {
    return "오류 발생"
  }
  
  var alertMessage: String {
    switch self {
      case .fileNotFound:
      return "국가코드-국가명 데이터 파일을 찾을 수 없습니다."
    case .decodingFailed(let error):
      return "데이터 파싱에 실패했습니다: \(error.localizedDescription)"
    case .networkFailed(let error):
      return "네트워크 오류: \(error.localizedDescription)"
    case .invalidURL:
      return "유효하지 않은 URL입니다."
    case .unknown:
      return "알 수 없는 오류가 발생했습니다."
    }
  }
}
