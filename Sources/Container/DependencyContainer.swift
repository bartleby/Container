// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

final public class DependencyContainer {
    
    // MARK: - Properties
    public var weakBoxHolder = [String : WeakContainer<AnyObject>]()
    public var strongBoxHolder = [String : AnyObject]()
    public let assemblyStorage: AssemblyStorageProtocol = AssemblyStorage()
    public let factoryStorage: FactoryStorageProtocol = FactoryStorage()
    private var lock: RecursiveLock = RecursiveLock()
    
    // MARK: - Singleton
    static public let shared: DependencyContainer = DependencyContainer()
    
    // MARK: - Init/Deinit
    private init() {}
}

extension DependencyContainer: AssemblyApplier {
    public func apply<T>(_ type: T.Type, label: ContainerLabel) where T: AssemblyType {
        lock.sync {
            self.assemblyStorage.apply(type, label: label)
        }
    }
    
    public func apply<T>(_ type: T.Type) where T: AssemblyType {
        self.apply(type, label: .none)
    }
}

extension DependencyContainer: AssemblyResolver {
    public func resolve<T>(_ type: T.Type, label: ContainerLabel) -> T where T: AssemblyType {
        lock.sync {
            let module = self.assemblyStorage.resolve(type, label: label)
            return module.init(resolver: self)
        }
    }
    
    public func resolve<T>(_ type: T.Type) -> T where T: AssemblyType {
        return self.resolve(type, label: .none)
    }
}

extension DependencyContainer: DependencyApplier {
    public func apply<T>(_ builder: @escaping @autoclosure () -> T, label: ContainerLabel) {
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
    public func resolve<T>(_ type: T.Type, scope: DependencyScope = .weak, label: ContainerLabel) -> T {
        lock.sync {
            let factory = self.factoryStorage.resolve(type, label: label)
            return scope.resolve(resolver: self, factory: factory, label: label)
        }
    }
    
    public func resolve<T>(_ type: T.Type, scope: DependencyScope = .weak) -> T {
        resolve(type, scope: scope, label: .none)
    }
}
