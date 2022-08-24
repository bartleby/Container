// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

@propertyWrapper
final public class Dependency<T> {
    
    // MARK: - Properties
    private let label: DependencyLabel
    private let scope: DependencyScope
    private var container: Container
    public var wrappedValue: T { value }
    
    // MARK: - Lazy Properties
    private lazy var value: T = {
        container.resolver.resolve(T.self, scope: scope, label: label)
    }()
    
    // MARK: - Init/Deinit
    public init(
        _ container: Container,
        scope: DependencyScope = .weak,
        label: DependencyLabel = .none
    ) {
        self.container = container
        self.label = label
        self.scope = scope
    }
}
