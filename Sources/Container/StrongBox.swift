// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

extension StrongBox {
    func strongBox<T>(label: ContainerLabel, configure: () -> T) -> T {
        let key = StoreKey(T.self, label: label).key
        if let object = self.strongBoxHolder[key] {
            return object as! T
        }
        let object = configure()
        strongBoxHolder[key] = object as AnyObject
        return object
    }
}
