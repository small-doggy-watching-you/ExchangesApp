
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    
    
    private let dataService = DataService()
    private var currency: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataService.fetchData(){ [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.currency = result
                self.updateUI()
            }
        }
        
        configureUI()
    }
    
    // 최초 UI 세팅
    private func configureUI() {
        print("CurrencyListViewController configureUI")
        view.backgroundColor = .systemBackground
        
    }
    
    // UI 업데이트 실행
    private func updateUI() {
        print(currency ?? "")
    }
    
    
}

