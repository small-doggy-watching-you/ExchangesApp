
import Foundation

protocol CurrencyListDelegate: AnyObject {
    
    // 서치바의 텍스트 변화 감지
    func didSearchbarTextChange(_ searchText: String)
    
}
