//
//  StepsEnum.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import Foundation

enum StepsEnum: String, CaseIterable {
    case voltar
    case passar
    case noValue
    
    var rawValue: String {
        switch self {
        case .voltar: return "voltar"
        case .passar: return "passar"
        case .noValue: return "noValue"
        }
    }
}
