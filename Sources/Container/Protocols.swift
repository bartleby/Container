// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public protocol DependencyApplier {
    func apply<T>(_ builder: @escaping @autoclosure () -> T, label: DependencyLabel)
    func apply<T>(_ builder: @escaping @autoclosure () -> T)
}

public protocol DependencyResolver: WeakBox, StrongBox {
    func resolve<T>(_ type: T.Type, scope: DependencyScope, label: DependencyLabel) -> T
    func resolve<T>(_ type: T.Type, scope: DependencyScope) -> T
}

public protocol FactoryStorageProtocol: AnyObject {
    func apply<T>(_ factory: Factory<T>, label: DependencyLabel)
    func resolve<T>(_ type: T.Type, label: DependencyLabel) -> Factory<T>
}

public protocol StrongBox: AnyObject {
    var strongBoxHolder: [String : AnyObject] { set get }
}

public protocol WeakBox: AnyObject {
    var weakBoxHolder: [String : WeakContainer<AnyObject>] { set get }
}
