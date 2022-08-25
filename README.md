<p align="center">
  <img width="512" height="512" src="/Images/header.png">
</p>

Container
========

Container is a lightweight [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) framework for Swift.


## Installation

is available in the [Swift Package Manager](https://swift.org/package-manager/).

### Swift Package Manager

```
https://github.com/bartleby/Container.git
```


## Basic Usage

Firstly, you must defined your containers


```swift
extension Container {
    static let services = Container(ContainerConfigurator.services)
    static let assemblies = Container(ContainerConfigurator.assemblies)
    static let appearance = Container(ContainerConfigurator.appearance)
}

struct ContainerConfigurator {
    static var services: DependencyResolver {
        let container = DependencyContainer()
        
        container.apply(Service() as ServiceProtocol)
        container.apply(ServiceTwo(), label: .two)
        
        return container
    }
    
    static var assemblies: DependencyResolver {
        let container = DependencyContainer()
        
        container.apply(MainAssembly())
        container.apply(AuthorizationAssembly())
        container.apply(RegistrationAssembly())
        container.apply(OnboardingAssembly())
        container.apply(SettingsAssembly())
        
        return container
    }
    
    static var appearance: DependencyResolver {
        let container = DependencyContainer()
        
        container.apply(Color.red, label: .redColor)
        
        return container
    }
}

```

Then get an instance of a service from the container. 

```swift
let resolver = Container.services.resolver
let service = resolver.resolve(Service.self, scope: .unowned)
service.run()
```

You can also use Propertywrapers

```swift
class ViewModel {

    @Dependency(.services, scope: .strong) var config: AppConfigServiceProtocol
    
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
@Dependency(.services) var service: ServiceProtocol // .weak scope is used by default
``` 

How it's work

- `weak` Keeps the object in memory while at least one object refers to it


- `strong` An analogue of Singletone, after creating the object, it always remains in memory even if no one refers to it


- `unowned` The object is not stored in memory and each time create a new object


### Labels

For the same types, you can specify Label
For exemple:

```swift

container.apply(Color.red, label: .redColor)
container.apply(Color.green, label: .greenColor)
container.apply(Color.orange, label: .orangeColor)

```

In order to create your own `Label`, you need to extension the structure of `DependencyLabel`

```swift
extension DependencyLabel {
    static let redColor = ContainerLabel(value: "redColor")
    static let greenColor = ContainerLabel(value: "greenColor")
    static let orangeColor = ContainerLabel(value: "orangeColor")
}
```

Then you can specify a label when using

```swift
@Dependency(.appearance, scope: .strong, label: .redColor) var redColor: Color
```



## Assembly module

You'r also can use `Assembly` for assembly your Modules with `Container`

First, register a `Assembly` to a `Container`

```swift

extension Container {
    static let assembly = Container(ContainerConfigurator.assemblies)
    //...
}

struct ContainerConfigurator {
    
    static var assemblies: DependencyResolver {
        let container = DependencyContainer()
        
        container.apply(MainAssembly())
        container.apply(AuthorizationAssembly())
        container.apply(RegistrationAssembly())
        container.apply(OnboardingAssembly())
        container.apply(SettingsAssembly())
        
        return container
    }
    
    //...
}
```

Then implement the MainAssembly class 


```swift
protocol Assembly {
    associatedtype C: CoordinatorType
    associatedtype M
    
    func build(coordinator: C) -> M
}

typealias MainModule = Module<MainModuleInput, MainModuleOutput>

struct MainAssembly: Assembly {
    @Dependency(.services, scope: .strong) var config: AppConfigServiceProtocol
    
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
    @Dependency(.assemblies) var mainAssembly: MainAssembly
    
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
