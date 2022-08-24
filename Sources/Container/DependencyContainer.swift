// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

final public class DependencyContainer {
    
    // MARK: - Properties
    public var weakBoxHolder = [String : WeakContainer<AnyObject>]()
    public var strongBoxHolder = [String : AnyObject]()
    public let factoryStorage: FactoryStorageProtocol = FactoryStorage()
    private var lock: RecursiveLock = RecursiveLock()
    
    // MARK: - Init/Deinit
    public init() {}
}

extension DependencyContainer: DependencyApplier {
    public func apply<T>(_ builder: @escaping @autoclosure () -> T, label: DependencyLabel) {
        lock.sync {
            let factory = Factory(builder: builder)
            factoryStorage.apply(factory, label: label)
        }
    }
    
    public func apply<T>(_ builder: @autoclosure @escaping () -> T) {
        lock.sync {
            let factory = Factory(builder: builder)
            factoryStorage.apply(factory, label: .none)
        }
    }
}

extension DependencyContainer: DependencyResolver {
    public func resolve<T>(_ type: T.Type, scope: DependencyScope = .weak, label: DependencyLabel) -> T {
        lock.sync {
            let factory = self.factoryStorage.resolve(type, label: label)
            return scope.resolve(resolver: self, factory: factory, label: label)
        }
    }
    
    public func resolve<T>(_ type: T.Type, scope: DependencyScope = .weak) -> T {
        resolve(type, scope: scope, label: .none)
    }
}
