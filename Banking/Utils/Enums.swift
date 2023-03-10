//
//  Enums.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
enum Paths : RawRepresentable, CaseIterable, Codable {
    
    typealias RawValue = String
    
    case introduction
    case unknown(RawValue)
    
    static let allCases: AllCases = [
        .introduction,
    ]
    
    init(rawValue: RawValue) {
        self = Self.allCases.first{ $0.rawValue == rawValue }
        ?? .unknown(rawValue)
    }
    
    var rawValue: RawValue {
        switch self {
        case .introduction                      : return "introduction"
        case let .unknown(value)                : return value
        }
    }
}
