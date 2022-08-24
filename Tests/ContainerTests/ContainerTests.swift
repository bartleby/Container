import XCTest
@testable import Container

class TestClass {
    let id: String = UUID().uuidString
}

extension ContainerLabel {
    static let test: ContainerLabel = ContainerLabel(value: "test")
}

extension Container {
    static let services = Container(ContainerConfigurator.services)
}

struct ContainerConfigurator {
    static var services: DependencyResolver {
        let container = DependencyContainer()
        
        // Setup Services
        container.apply(TestClass())
        container.apply(TestClass(), label: .test)
        
        return container
    }
}


final class ContainerTests: XCTestCase {
    
    func testWeakContainer() throws {        
        let container = Container.services
        
        var class1: TestClass? = container.resolver.resolve(TestClass.self, scope: .weak)
        var class2: TestClass? = container.resolver.resolve(TestClass.self, scope: .weak)
        
        XCTAssertTrue(class1?.id == class2?.id)

        class1 = nil
        
        class1 = container.resolver.resolve(TestClass.self, scope: .weak)
        
        XCTAssertTrue(class1?.id == class2?.id)
        
        let oldId = class1?.id
        
        class1 = nil
        class2 = nil
        
        class1 = container.resolver.resolve(TestClass.self, scope: .weak)
        class2 = container.resolver.resolve(TestClass.self, scope: .weak)
        
        XCTAssertFalse(class1?.id == oldId)
        XCTAssertFalse(class2?.id == oldId)

    }
    
    func testUnownedContainer() throws {
        let container = Container.services
        
        let class1 = container.resolver.resolve(TestClass.self, scope: .unowned)
        let class2 = container.resolver.resolve(TestClass.self, scope: .unowned)
        
        XCTAssertFalse(class1.id == class2.id)
    }
    
    func testStrongContainer() throws {
        let container = Container.services
        
        var class1: TestClass? = container.resolver.resolve(TestClass.self, scope: .strong)
        var class2: TestClass? = container.resolver.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == class2?.id)

        class1 = nil
        
        class1 = container.resolver.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == class2?.id)
        
        let oldId = class1?.id
        
        class1 = nil
        class2 = nil
        
        class1 = container.resolver.resolve(TestClass.self, scope: .strong)
        class2 = container.resolver.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == oldId)
        XCTAssertTrue(class2?.id == oldId)
    }
    
    func testLabel() throws {
        let container = Container.services
        
        let class1 = container.resolver.resolve(TestClass.self, scope: .weak)
        let class2 = container.resolver.resolve(TestClass.self, scope: .weak, label: .test)
        
        XCTAssertFalse(class1.id == class2.id)
    }
}
