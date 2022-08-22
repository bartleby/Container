// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

@propertyWrapper
final public class Container<T> {
    
    // MARK: - Properties
    private let label: ContainerLabel
    private let scope: DependencyScope
    public var wrappedValue: T { value }
    
    // MARK: - Lazy Properties
    private lazy var value: T = {
        var container: DependencyContainer = .shared
        let dependency: T = container.resolve(T.self, scope: scope, label: label)
        return dependency
    }()
    
    // MARK: - Init/Deinit
    public init(scope: DependencyScope = .weak, label: ContainerLabel = .none) {
        self.label = label
        self.scope = scope
    }
}
