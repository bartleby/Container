//
//  File.swift
//  
//
//  Created by Bartleby on 23.08.2022.
//

import Foundation

final class RecursiveLock {
    
    // MARK: - Private methods
    private let lock = NSRecursiveLock()

    // MARK: - Public methods
    func sync<T>(action: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return action()
    }
}
