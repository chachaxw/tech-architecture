import UIKit

var greeting = "Hello, Bridge Pattern playground"

//:
//: ## 桥接模式
//:
//: 桥接模式是一种结构型设计模式， 可将一个大类或一系列紧密相关的类拆分为抽象和实现两个独立的层次结构， 从而能在开发时分别使用。
//:
//: ![桥接模式](brdige.png)
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
//: ## 桥接模式适合应用场景
//:
//: 1. 如果你想要拆分或重组一个具有多重功能的庞杂类（例如能与多个数据库服务器进行交互的类），可以使用桥接模式。
//:    类的代码行数越多，弄清其运作方式就越困难，对其进行修改所花费的时间就越长。
//:    一个功能上的变化可能需要在整个类范围内进行修改，而且常常会产生错误，甚至还会有一些严重的副作用。
//:
//: > 桥接模式可以将庞杂类拆分为几个类层次结构。此后，你可以修改任意一个类层次结构而不会影响到其他类层次结构。
//: > 这种方法可以简化代码的维护工作，并将修改已有代码的风险降到最低。
//:
//: 2. 如果你希望在几个独立维度上扩展一个类，可使用该模式。
//:    桥接建议将每个维度抽取为独立的类层次。初始类将相关工作委派给属于对应类层次的对象，无需自己完成所有工作。
//:
//: 3. 如果你需要在运行时切换不同实现方法，可使用桥接模式。
//:    当然并不是说一定要实现这一点，桥接模式可替换抽象部分中的实现对象，具体操作就和给成员变量赋新值一样简单。
//:
//: ## 实现方式
//:
//: 1. 明确类中独立的维度。独立的概念可能是：抽象/平台，域/基础设施，前端/后端或接口/实现。
//: 2. 了解客户端的业务需求，并在抽象基类中定义它们。
//: 3. 确定在所有平台上都可执行的业务。并在通用实现接口中声明抽象部分所需的业务。
//: 4. 为你域内的所有平台创建实现类，但需确保它们遵循实现部分的接口。
//: 5. 在抽象类中添加指向实现类型的引用成员变量。抽象部分会将大部分工作委派给该成员变量所指向的实现对象。
//: 6. 如果你的高层逻辑有多个变体，则可通过扩展抽象基类为每个变体创建一个精确抽象。
//: 7. 客户端代码必须将实现对象传递给抽象部分的构造函数才能使其能够相互关联。此后，客户端只需与抽象对象进行交互，无需和实现对象打交道。
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
