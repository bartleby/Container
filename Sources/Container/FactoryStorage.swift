// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

final internal class FactoryStorage: FactoryStorageProtocol {
    
    // MARK: - Typealias
    typealias FactoryCollection = [String : Any]
    
    // MARK: - Private Properties
    private var factoryCollection = FactoryCollection()
    
    // MARK: - Public methods
    func apply<T>(_ factory: Factory<T>, label: DependencyLabel) {
        let key = StoreKey(T.self, label: label).key
        factoryCollection[key] = factory
    }
    
    func resolve<T>(_ type: T.Type, label: DependencyLabel) -> Factory<T> {
        let key = StoreKey(type, label: label).key
        guard let factory = factoryCollection[key] else {
            fatalError("Factory '\(String(describing: type))' has't been registered, use 'apply( _:)' method")
        }
        return factory as! Factory<T>
    }
}
