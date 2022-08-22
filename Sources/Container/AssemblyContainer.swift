// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

@propertyWrapper
final public class AssemblyContainer<T> where T: AssemblyType {
    
    // MARK: - Properties
    private let label: ContainerLabel
    public var wrappedValue: T { value }
    
    // MARK: - Lazy Properties
    private lazy var value: T = {
        var container: DependencyContainer = .shared
        let dependency: T = container.resolve(T.self, label: label)
        
        return dependency
    }()
    
    // MARK: - Init/Deinit
    public init(_ label: ContainerLabel = .none) {
        self.label = label
    }
}
