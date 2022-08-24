//
//  File.swift
//  
//
//  Created by Bartleby on 23.08.2022.
//

import Foundation

public struct DependencyLabel {
    
    // MARK: - Properties
    let value: String
    
    // MARK: - Init/Deinit
    public init(value: String) {
        self.value = value
    }
}

// MARK: - Equatable
extension DependencyLabel: Equatable {}

public extension DependencyLabel {
    static let none = DependencyLabel(value: "none")
}
