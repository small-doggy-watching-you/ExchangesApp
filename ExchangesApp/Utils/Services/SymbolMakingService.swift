//
//  SymbolMakingService.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//

enum SymbolMakingService {
    enum TrendSymbol: String {
        case upward = "arrowtriangle.up.square.fill" // 상승 심볼
        case downward = "arrowtriangle.down.square.fill" // 하락 심볼
        case blank = "square" // 빈칸용 네모
    }

    static func allocateTrendSymbol(oldRate: Double?, newRate: Double) -> TrendSymbol {
        guard let oldRate else { return .blank }
        let changed = newRate - oldRate

        if abs(changed) > 0.01 {
            return changed > 0 ? .upward : .downward
        } else {
            return .blank
        }
    }
}
