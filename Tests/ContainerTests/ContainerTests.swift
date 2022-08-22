import XCTest
@testable import Container

extension ContainerLabel {
    static let test: ContainerLabel = ContainerLabel(value: "test")
}

final class ContainerTests: XCTestCase {
    
    class TestClass {
        let id: String = UUID().uuidString
    }
    
    override class func setUp() {
        let container = DependencyContainer.shared
        
        container.apply(TestClass())
        container.apply(TestClass(), label: .test)
    }
    
    func testWeakContainer() throws {        
        let container = DependencyContainer.shared
        
        var class1: TestClass? = container.resolve(TestClass.self, scope: .weak)
        var class2: TestClass? = container.resolve(TestClass.self, scope: .weak)
        
        XCTAssertTrue(class1?.id == class2?.id)

        class1 = nil
        
        class1 = container.resolve(TestClass.self, scope: .weak)
        
        XCTAssertTrue(class1?.id == class2?.id)
        
        let oldId = class1?.id
        
        class1 = nil
        class2 = nil
        
        class1 = container.resolve(TestClass.self, scope: .weak)
        class2 = container.resolve(TestClass.self, scope: .weak)
        
        XCTAssertFalse(class1?.id == oldId)
        XCTAssertFalse(class2?.id == oldId)

    }
    
    func testUnownedContainer() throws {
        let container = DependencyContainer.shared
        
        let class1 = container.resolve(TestClass.self, scope: .unowned)
        let class2 = container.resolve(TestClass.self, scope: .unowned)
        
        XCTAssertFalse(class1.id == class2.id)
    }
    
    func testStrongContainer() throws {
        let container = DependencyContainer.shared
        
        var class1: TestClass? = container.resolve(TestClass.self, scope: .strong)
        var class2: TestClass? = container.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == class2?.id)

        class1 = nil
        
        class1 = container.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == class2?.id)
        
        let oldId = class1?.id
        
        class1 = nil
        class2 = nil
        
        class1 = container.resolve(TestClass.self, scope: .strong)
        class2 = container.resolve(TestClass.self, scope: .strong)
        
        XCTAssertTrue(class1?.id == oldId)
        XCTAssertTrue(class2?.id == oldId)
    }
    
    func testLabel() throws {
        let container = DependencyContainer.shared
        
        let class1 = container.resolve(TestClass.self, scope: .weak)
        let class2 = container.resolve(TestClass.self, scope: .weak, label: .test)
        
        XCTAssertFalse(class1.id == class2.id)
    }
}
