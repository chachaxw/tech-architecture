import UIKit

var greeting = "Hello, Bridge Pattern playground"

//:
//: ## 桥接模式
//:
//: 桥接模式是一种结构型设计模式， 可将一个大类或一系列紧密相关的类拆分为抽象和实现两个独立的层次结构， 从而能在开发时分别使用。
//:
//: ## 桥接模式结构
//:
//: ![桥接模式结构](structure.png)
//:
//: 1. 抽象部分（Abstraction）提供高层控制逻辑，依赖于完成底层实际工作的实现对象。
//: 2. 实现部分（Implementation）为所有具体实现声明通用接口。抽象部分仅能通过在这里声明的方法与实现对象交互。
//:    抽象部分可以列出和实现部分一样的方法，但是抽象部分通常声明一些复杂行为，这些行为依赖于多种由实现部分声明的原语操作。
//: 3. 具体实现（Concrete Implementations）中包括特定于平台的代码。
//: 4. 精确抽象（Refined Abstraction） 提供控制逻辑的变体。与其父类一样，它们通过通用实现接口与不同的实现进行交互。
//: 5. 通常情况下，客户端（Client）仅关心如何与抽象部分合作。但是，客户端需要将抽象对象与一个实现对象连接起来。
//:
//: ## 桥接模式优缺点
//:
//: ### 优点
//: 1. 你可以创建与平台无关的类和程序。
//: 2. 客户端代码仅与高层抽象部分进行互动， 不会接触到平台的详细信息。
//: 3. 开闭原则。 你可以新增抽象部分和实现部分， 且它们之间不会相互影响。
//: 4. 单一职责原则。 抽象部分专注于处理高层逻辑， 实现部分处理平台细节。
//:
//: ### 缺点
//: 1. 对高内聚的类使用该模式可能会让代码更加复杂。
//:

import XCTest

/// The Implementation defines the interface for all implementation classes. It
/// doesn't have to match the Abstraction's interface. In fact, the two
/// interfaces can be entirely different. Typically the Implementation interface
/// provides only primitive operations, while the Abstraction defines higher-
/// level operations based on those primitives.
protocol Implementation {

    func operationImplementation() -> String
}

/// The Abstraction defines the interface for the "control" part of the two
/// class hierarchies. It maintains a reference to an object of the
/// Implementation hierarchy and delegates all of the real work to this object.
class Abstraction {
    
    fileprivate var implementation: Implementation
    
    init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    func operation() -> String {
        let operation = implementation.operationImplementation()
        return "Abstraction: Base operation with:\n" + operation
    }
}

/// You can extend the Abstraction without changing the Implementation classes.
class ExtendedAbstraction: Abstraction {

    override func operation() -> String {
        let operation = implementation.operationImplementation()
        return "ExtendedAbstraction: Extended operation with:\n" + operation
    }
}

/// Each Concrete Implementation corresponds to a specific platform and
/// implements the Implementation interface using that platform's API.
class ConcreteImplementationA: Implementation {
    
    func operationImplementation() -> String {
        return "ConcreteImplementationA: Here's the result on the platform A.\n"
    }
}

class ConcreteImplementationB: Implementation {
    
    func operationImplementation() -> String {
        return "ConcreteImplementationB: Here's the result on the platform B.\n"
    }
}

/// Except for the initialization phase, where an Abstraction object gets linked
/// with a specific Implementation object, the client code should only depend on
/// the Abstraction class. This way the client code can support any abstraction-
/// implementation combination.
class Client {
    // ...
    static func someClientCode(abstraction: Abstraction) {
        print(abstraction.operation())
    }
    // ...
}

/// Let's see how it all works together.
class BridgeConceptual: XCTestCase {

    func testBridgeConceptual() {
        // The client code should be able to work with any pre-configured
        // abstraction-implementation combination.
        let implementation = ConcreteImplementationA()
        Client.someClientCode(abstraction: Abstraction(implementation))

        let concreteImplementation = ConcreteImplementationB()
        Client.someClientCode(abstraction: ExtendedAbstraction(concreteImplementation))
    }
}

let bridge = BridgeConceptual()

bridge.testBridgeConceptual()

// 输出结果
// Abstraction: Base operation with:
// ConcreteImplementationA: Here's the result on the platform A.
//
// ExtendedAbstraction: Extended operation with:
// ConcreteImplementationB: Here's the result on the platform B.
