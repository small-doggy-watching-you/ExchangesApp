
import Foundation

protocol CurrencyListDelegate: AnyObject {
    // 서치바의 텍스트 변화 감지 함수
    func didSearchbarTextChange(_ searchText: String)
    
    // 각 통화코드 클릭 감지 함수
    func didSelectCurrency(_ currencyItem: CurrencyItem)
}
