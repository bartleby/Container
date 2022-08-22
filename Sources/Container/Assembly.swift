// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

open class Assembly: AssemblyType {
    
    // MARK: - Properties
    public var resolver: AssemblyResolver
    
    // MARK: - Init/Deinit
    required public init(resolver: AssemblyResolver) {
        self.resolver = resolver
    }
}
