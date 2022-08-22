![Container](/Images/header.png)

Container
========

Container is a lightweight [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) framework for Swift.


## Installation

Container is available through [Swift Package Manager](https://swift.org/package-manager/).

### Swift Package Manager

``` https://github.com/bartleby/SheetDetentsModifier.git ```


## Basic Usage

First, register a service to a `Container`, there are two ways to register your dependencies, directly to the `Container` and through the expansion of DependencyContainer


```swift
let container = DependencyContainer.shared
container.apply(Service())
```

In a real project, it is recommended to use the second approach.
You can create a separate file with this extension

```swift
extension DependencyContainer {
    func configureAssembly(container: AssemblyApplier) {
        // Setup Modules
        container.apply(AuthorizationAssembly.self)
        container.apply(RegistrationAssembly.self)
        container.apply(OnboardingAssembly.self)
        container.apply(MainAssembly.self)
        container.apply(SettingsAssembly.self)
    }
    
    func configureDependency(container: DependencyApplier) {
        // Setup Services
        container.apply(AppConfigService() as AppConfigServiceProtocol)
        container.apply(EnvironmentService() as EnvironmentServiceProtocol)
        
        // Appearance
        container.apply(Color.red, label: .redColor)
        
        // Date Formatter
        container.apply(DateFormatterPool() as DateFormatterPoolProtocol)
    }
}
```

Then get an instance of a service from the container. 

```swift
let service = container.resolve(Service.self, scope: .unowned)
service.run()
```

In a real project, it is recommended to use PropertyWrapers

```swift
class ViewModel {
    @Container(scope: .strong) var config: AppConfigServiceProtocol
    
    //...
    
    func setup() {
        let token = config.obtain(for: .token)
        //...
    }
    
}
```

### Scope

You can specify the `scope` for your dependencies, `.weak` `.strong` and `.unowned`
`.weak` scope is used by default

```swift 
@Container var service: ServiceProtocol // .weak scope is used
``` 

How it's work

- weak

Keeps the object in memory while at least one object refers to it


- strong

An analogue of Singletone, after creating the object, it always remains in memory even if no one refers to it


- unowned

The object is not stored in memory and each time create a new object


### Labels

For the same types, you can specify Label
For exemple:

```swift

container.apply(Color.red, label: .redColor)
container.apply(Color.green, label: .greenColor)
container.apply(Color.orange, label: .orangeColor)

```

In order to create your own `Label`, you need to extension the structure of `Containerlabel`

```swift
extension ContainerLabel {
    static let redColor = ContainerLabel(value: "redColor")
    static let greenColor = ContainerLabel(value: "greenColor")
    static let orangeColor = ContainerLabel(value: "orangeColor")
}
```

## Assembly

`Container` also support `Assembly` for assembly your Modules

First, register a `Assembly` to a `Container`

```swift
extension DependencyContainer {
    func configureAssembly(container: AssemblyApplier) {
        container.apply(MainAssembly.self)
        //...
    }
    
    func configureDependency(container: DependencyApplier) {
        container.apply(AppConfigService() as AppConfigServiceProtocol)
        //...
    }
}
```

Then implement the MainAssembly class 


```swift
typealias MainModule = Module<MainModuleInput, MainModuleOutput>

class MainAssembly: Assembly {
    
    @Container(scope: .strong) var config: AppConfigServiceProtocol
    
    func build(coordinator: MainCoordinator) -> MainModule {
        
        // View
        let view = MainViewController()
        
        // Router
        let router = MainRouter(coordinator: coordinator)
        
        // ViewModel
        let viewModel = MainViewModel(router: router, config: config)
        
        // Configure
        viewModel.view = view
        view.output = viewModel
        
        return Module(view: view, input: viewModel, output: viewModel)
    }
}
```

### How to usage

```swift
class MainCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    @AssemblyContainer var mainAssembly: MainAssembly
    
    override func start() {
        let module = mainAssembly.build(coordinator: self)
        router.setRootModule(module)
    }
}

```

## Example Apps

Coming soon


## License

MIT license. See the [LICENSE file](LICENSE) for details.
