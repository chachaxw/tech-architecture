import UIKit

var greeting = "Hello, Facade Pattern playground"

//:
//: ## 外观模式
//:
//: 外观模式是一种结构型设计模式， 能为程序库、 框架或其他复杂类提供一个简单的接口。
//:
//: ## 外观模式结构
//:
//: ![外观模式结构](structure.png)
//:
//: 1. 外观（Facade）提供了一种访问特定子系统功能的便捷方式，其了解如何重定向客户端请求，知晓如何操作一切活动部件。
//: 2. 创建附加外观（Additional Facade）类可以避免多种不相关的功能污染单一外观，使其变成又一个复杂结构。客户端和其他外观都可使用附加外观。
//: 3. 复杂子系统（Complex Subsystem）由数十个不同对象构成。如果要用这些对象完成有意义的工作，你必须深入了解子系统的实现细节，
//:    比如按照正确顺序初始化对象和为其提供正确格式的数据。子系统类不会意识到外观的存在，它们在系统内运作并且相互之间可直接进行交互。
//: 4. 客户端（Client）使用外观代替对子系统对象的直接调用。
//:
//: ## 外观模式优缺点
//:
//: 优点：你可以让自己的代码独立于复杂子系统。
//: 缺点：外观可能成为与程序中所有类都耦合的上帝对象。
//:

import XCTest

/// The Facade class provides a simple interface to the complex logic of one or
/// several subsystems. The Facade delegates the client requests to the
/// appropriate objects within the subsystem. The Facade is also responsible for
/// managing their lifecycle. All of this shields the client from the undesired
/// complexity of the subsystem.
class Facade {

    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2

    /// Depending on your application's needs, you can provide the Facade with
    /// existing subsystem objects or force the Facade to create them on its
    /// own.
    init(subsystem1: Subsystem1 = Subsystem1(),
         subsystem2: Subsystem2 = Subsystem2()) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }

    /// The Facade's methods are convenient shortcuts to the sophisticated
    /// functionality of the subsystems. However, clients get only to a fraction
    /// of a subsystem's capabilities.
    func operation() -> String {

        var result = "Facade initializes subsystems:"
        result += " " + subsystem1.operation1()
        result += " " + subsystem2.operation1()
        result += "\n" + "Facade orders subsystems to perform the action:\n"
        result += " " + subsystem1.operationN()
        result += " " + subsystem2.operationZ()
        return result
    }
}

/// The Subsystem can accept requests either from the facade or client directly.
/// In any case, to the Subsystem, the Facade is yet another client, and it's
/// not a part of the Subsystem.
class Subsystem1 {

    func operation1() -> String {
        return "Sybsystem1: Ready!\n"
    }

    // ...

    func operationN() -> String {
        return "Sybsystem1: Go!\n"
    }
}

/// Some facades can work with multiple subsystems at the same time.
class Subsystem2 {

    func operation1() -> String {
        return "Sybsystem2: Get ready!\n"
    }

    // ...

    func operationZ() -> String {
        return "Sybsystem2: Fire!\n"
    }
}

/// The client code works with complex subsystems through a simple interface
/// provided by the Facade. When a facade manages the lifecycle of the
/// subsystem, the client might not even know about the existence of the
/// subsystem. This approach lets you keep the complexity under control.
class Client {
    // ...
    static func clientCode(facade: Facade) {
        print(facade.operation())
    }
    // ...
}

/// Let's see how it all works together.
class FacadeConceptual: XCTestCase {

    func testFacadeConceptual() {

        /// The client code may have some of the subsystem's objects already
        /// created. In this case, it might be worthwhile to initialize the
        /// Facade with these objects instead of letting the Facade create new
        /// instances.

        let subsystem1 = Subsystem1()
        let subsystem2 = Subsystem2()
        let facade = Facade(subsystem1: subsystem1, subsystem2: subsystem2)
        Client.clientCode(facade: facade)
    }
}

let facade = FacadeConceptual()

facade.testFacadeConceptual()

// 输出结果:
// Facade initializes subsystems: Sybsystem1: Ready!
// Sybsystem2: Get ready!
//
// Facade orders subsystems to perform the action:
// Sybsystem1: Go!
// Sybsystem2: Fire!
