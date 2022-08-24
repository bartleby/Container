// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

internal struct StoreKey {
    
    // MARK: - Properties
    fileprivate let objectType: Any.Type
    fileprivate let label: DependencyLabel
    var key: String { String(hashValue) }
    
    // MARK: - Init/Deinit
    internal init(_ objectType: Any.Type, label: DependencyLabel = .none) {
        self.objectType = objectType
        self.label = label
    }
}

// MARK: Hashable
extension StoreKey: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: objectType).hashValue ^ label.value.hashValue)
    }
}

// MARK: Equatable
extension StoreKey: Equatable {
    static func == (lhs: StoreKey, rhs: StoreKey) -> Bool {
        return lhs.objectType == rhs.objectType && lhs.label == rhs.label
    }
}
