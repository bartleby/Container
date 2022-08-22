// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public final class WeakContainer<T> where T: AnyObject {
    
    // MARK: - Properties
    weak var value: T?
    
    // MARK: - Init/Deinit
    init(value: T) {
        self.value = value
    }
}
