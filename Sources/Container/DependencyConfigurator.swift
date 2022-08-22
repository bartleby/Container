// Copyright (c) 2022 iDevs.io. All rights reserved.

import Foundation

extension DependencyConfigurator {
    public func configureAssembly(container: AssemblyApplier) {}
    public func configureDependency(container: DependencyApplier) {}
}

extension DependencyContainer: DependencyConfigurator {}
