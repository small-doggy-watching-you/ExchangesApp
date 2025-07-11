//
//  AllocateSymbol.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//

struct SymbolNamingService {
    
    enum trendSymbol: String {
        case upward = "arrow.up.square.fill"
        case downward = "arrow.down.square.fill"
        case square = "squre"
    }
    
    static func allocateSymbol(oldRate: Double?, newRate: Double) -> String{
        guard let oldRate else {
            return trendSymbol.square.rawValue
        }
        let changed = newRate - oldRate
        
        if abs(changed) > 0.01 {
            if changed > 0 {
                return trendSymbol.upward.rawValue
            } else {
                return trendSymbol.downward.rawValue
            }
        } else {
            return trendSymbol.square.rawValue
        }
    }
}
