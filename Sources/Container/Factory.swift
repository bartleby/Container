// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

public struct Factory<T> {
    
    // MARK: - Properties
    var builder: () -> T
}
