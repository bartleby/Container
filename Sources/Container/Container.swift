// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public struct Container {
    public var resolver: DependencyResolver
    
    public init(_ resolver: DependencyResolver) {
        self.resolver = resolver
    }
}
