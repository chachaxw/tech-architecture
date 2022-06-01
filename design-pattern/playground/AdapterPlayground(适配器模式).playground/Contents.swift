import UIKit

var greeting = "Hello, Adapter Pattern playground"

//:
//: ## 适配器模式
//:
//: 适配器模式是一种结构型设计模式， 它能使接口不兼容的对象能够相互合作。
//:
//: ## 适配器模式结构
//:
//: ![适配器模式结构](structure-adapter.png)
//:
//: 1. 客户端（Client）是包含当前程序业务逻辑的类。
//: 2. 客户端接口（Client Interface）描述了其他类与客户端代码合作时必须遵循的协议。
//: 3. 服务（Service）中有一些功能类（通常来自第三方或遗留系统）。客户端与其接口不兼容，因此无法直接调用其功能。
//: 4. 适配器 （Adapter） 是一个可以同时与客户端和服务交互的类： 它在实现客户端接口的同时封装了服务对象。 适配器接受客户端通过适配器接口发起的调用， 并将其转换为适用于被封装服务对象的调用。
//: 5. 客户端代码只需通过接口与适配器交互即可， 无需与具体的适配器类耦合。 因此， 你可以向程序中添加新类型的适配器而无需修改已有代码。 这在服务类的接口被更改或替换时很有用： 你无需修改客户端代码就可以创建新的适配器类。
//:
//: ### 类适配器
//:
//: 这一实现使用了继承机制： 适配器同时继承两个对象的接口。 请注意， 这种方式仅能在支持多重继承的编程语言中实现， 例如 C++。
//:
//: ![类适配器](structure-class-adapter.png)
//:
//: 1. 类适配器不需要封装任何对象， 因为它同时继承了客户端和服务的行为。 适配功能在重写的方法中完成。 最后生成的适配器可替代已有的客户端类进行使用。
//:
//: ## 适配器模式优缺点
//:
//: 优点
//: 1. 单一职责原则。你可以将接口或数据转换代码从程序主要业务逻辑中分离。
//: 2. 开闭原则。只要客户端代码通过客户端接口与适配器进行交互，你就能在不修改现有客户端代码的情况下在程序中添加新类型的适配器。
//:
//: 缺点
//: 1. 代码整体复杂度增加 因为你需要新增一系列接口和类。有时直接更改服务类使其与其他代码兼容会更简单。
//:

import XCTest

/// The Target defines the domain-specific interface used by the client code.
class Target {

    func request() -> String {
        return "Target: The default target's behavior."
    }
}

/// The Adaptee contains some useful behavior, but its interface is incompatible
/// with the existing client code. The Adaptee needs some adaptation before the
/// client code can use it.
class Adaptee {

    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

/// The Adapter makes the Adaptee's interface compatible with the Target's
/// interface.
class Adapter: Target {

    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        return "Adapter: (TRANSLATED) " + adaptee.specificRequest().reversed()
    }
}

/// The client code supports all classes that follow the Target interface.
class Client {
    // ...
    static func someClientCode(target: Target) {
        print(target.request())
    }
    // ...
}

/// Let's see how it all works together.
class AdapterConceptual: XCTestCase {

    func testAdapterConceptual() {
        print("Client: I can work just fine with the Target objects:")
        Client.someClientCode(target: Target())

        let adaptee = Adaptee()
        print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
        print("Adaptee: " + adaptee.specificRequest())

        print("Client: But I can work with it via the Adapter:")
        Client.someClientCode(target: Adapter(adaptee))
    }
}

let adapter = AdapterConceptual()

adapter.testAdapterConceptual()

// 结果输出：
// Client: I can work just fine with the Target objects:
// Target: The default target's behavior.
// Client: The Adaptee class has a weird interface. See, I don't understand it:
// Adaptee: .eetpadA eht fo roivaheb laicepS
// Client: But I can work with it via the Adapter:
// Adapter: (TRANSLATED) Special behavior of the Adaptee.
