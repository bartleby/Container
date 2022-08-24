// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

extension WeakBox {
    func weakBox<T>(label: DependencyLabel, configure: () -> T) -> T {
        let key = StoreKey(T.self, label: label).key
        if let object = self.weakBoxHolder[key]?.value as? T {
            return object
        }
        let object = configure()
        weakBoxHolder[key] = WeakContainer(value: object as AnyObject)
        return object
    }
}
