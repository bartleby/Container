// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public enum DependencyScope {
    case weak
    case unowned
    case strong
    
    func resolve<T>(resolver: DependencyResolver, factory: Factory<T>, label: ContainerLabel) -> T {
        switch self {
        case .weak:
            return resolver.weakBox(label: label) { factory.builder() }
        case .strong:
            return resolver.strongBox(label: label) { factory.builder() }
        case .unowned:
            return factory.builder()
        }
    }
}
