//
//  AllocateSymbol.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//

struct SymbolMakingService {
    
    enum TrendSymbol: String {
        case upward = "arrowtriangle.up.square.fill"
        case downward = "arrowtriangle.down.square.fill"
        case blank = "square"
    }
    
    static func allocateTrendSymbol(oldRate: Double?, newRate: Double) -> TrendSymbol{
        guard let oldRate else { return .blank }
        let changed = newRate - oldRate
        
        if abs(changed) > 0.01 {
            return changed > 0 ? .upward : .downward
        } else {
            return .blank
        }
    }
}
