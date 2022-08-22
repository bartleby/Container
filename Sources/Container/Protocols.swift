// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public protocol AssemblyType: AnyObject {
    var resolver: AssemblyResolver { get }
    init(resolver: AssemblyResolver)
}

public protocol AssemblyApplier {
    func apply<T>(_ type: T.Type, label: ContainerLabel) where T: AssemblyType
    func apply<T>(_ type: T.Type) where T: AssemblyType
}

public protocol AssemblyResolver {
    func resolve<T>(_ type: T.Type, label: ContainerLabel) -> T where T: AssemblyType
    func resolve<T>(_ type: T.Type) -> T where T: AssemblyType
}

public protocol DependencyApplier {
    func apply<T>(_ builder: @escaping @autoclosure () -> T, label: ContainerLabel)
    func apply<T>(_ builder: @escaping @autoclosure () -> T)
}

public protocol DependencyResolver: WeakBox, StrongBox {
    func resolve<T>(_ type: T.Type, scope: DependencyScope, label: ContainerLabel) -> T
    func resolve<T>(_ type: T.Type, scope: DependencyScope) -> T
}

public protocol AssemblyStorageProtocol: AnyObject {
    func apply<T>(_ assembly: T.Type, label: ContainerLabel) where T: AssemblyType
    func resolve<T>(_ type: T.Type, label: ContainerLabel) -> T.Type where T: AssemblyType
}

public protocol FactoryStorageProtocol: AnyObject {
    func apply<T>(_ factory: Factory<T>, label: ContainerLabel)
    func resolve<T>(_ type: T.Type, label: ContainerLabel) -> Factory<T>
}

public protocol StrongBox: AnyObject {
    var strongBoxHolder: [String : AnyObject] { set get }
}

public protocol WeakBox: AnyObject {
    var weakBoxHolder: [String : WeakContainer<AnyObject>] { set get }
}
