//
//  ViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import UIKit

class ViewController: UIViewController {
  
  
  
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
  }

  private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
    let session = URLSession(configuration: .default)
    session.dataTask(with: URLRequest(url: url)) {data, response, error in
      guard let data = data, error == nil else {
        print("데이터 로드 실패")
        completion(nil)
        return
      }
      
      let successRange = 200..<300
      if let response = response as? HTTPURLResponse,
         successRange.contains(response.statusCode) {
        do {
          let decodedData = try JSONDecoder().decode(T.self, from: data)
          completion(decodedData)
        } catch {
          print("JSON 디코딩 실패: \(error)")
          completion(nil)
        }
      } else {
        print("응답 오류")
        completion(nil)
      }
    }.resume()
  }
  

}

