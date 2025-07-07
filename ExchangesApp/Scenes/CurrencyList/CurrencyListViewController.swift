
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    
    // 테스트
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("next text", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CurrencyListViewController")
        configureUI()
    }
    
    
    private func configureUI() {
        view.backgroundColor = .systemBlue
        
        [button].forEach {
            view.addSubview( $0 )
        }
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(250)
            $0.height.equalTo(120)
        }
    }
    
    @objc
    private func buttonTapped() {
        self.navigationController?.pushViewController(CalculatorView(), animated: true)
    }
    
}

