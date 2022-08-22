//
//  File.swift
//  
//
//  Created by Bartleby on 23.08.2022.
//

import Foundation

public struct ContainerLabel {
    
    // MARK: - Properties
    let value: String
    
    // MARK: - Init/Deinit
    public init(value: String) {
        self.value = value
    }
}

// MARK: - Equatable
extension ContainerLabel: Equatable {}

public extension ContainerLabel {
    static let none = ContainerLabel(value: "none")
}
