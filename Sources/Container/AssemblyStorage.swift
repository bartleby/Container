// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

final class AssemblyStorage: AssemblyStorageProtocol {
    
    // MARK: - Typealias
    typealias AssemblyCollection = [String : Any.Type]
    
    // MARK: - Private Properties
    private var assemblyCollection = AssemblyCollection()
    
    // MARK: - Public methods
    func apply<T>(_ assembly: T.Type, label: ContainerLabel = .none) where T: AssemblyType {
        let key = StoreKey(assembly, label: label).key
        self.assemblyCollection[key] = assembly
    }
    
    func resolve<T>(_ type: T.Type, label: ContainerLabel = .none) -> T.Type  where T: AssemblyType  {
        let key = StoreKey(type, label: label).key
        guard let assembly = assemblyCollection[key] else {
            fatalError("Assembly '\(String(describing: type))' has't been registered, use 'apply( _:)' method")
        }
        return assembly as! T.Type
    }
}
