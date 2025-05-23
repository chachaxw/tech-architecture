import UIKit

var greeting = "Hello, Decorator Pattern playground"

//:
//: ## 装饰模式
//:
//: 装饰模式是一种结构型设计模式， 允许你通过将对象放入包含行为的特殊封装对象中来为原对象绑定新的行为。
//:
//: ![装饰模式](decorator.png)
//:
//: ## 装饰模式结构
//:
//: ![装饰模式结构](structure.png)
//:
//: 1. 部件（Component）声明封装器和被封装对象的公用接口。
//: 2. 具体部件（Concrete Component）类是被封装对象所属的类。它定义了基础行为，但装饰类可以改变这些行为。
//: 3. 基础装饰（Base Decorator）类拥有一个指向被封装对象的引用成员变量。该变量的类型应当被声明为通用部件接口，
//:    这样它就可以引用具体的部件和装饰。装饰基类会将所有操作委派给被封装的对象。
//: 4. 具体装饰类（Concrete Decorators）定义了可动态添加到部件的额外行为。具体装饰类会重写装饰基类的方法，并在调用父类方法之前或之后进行额外的行为。
//: 5. 客户端（Client）可以使用多层装饰来封装部件，只要它能使用通用接口与所有对象互动即可。
//:
//: ## 装饰模式适合应用场景
//:
//: 1. 如果你希望在无需修改代码的情况下即可使用对象，且希望在运行时为对象新增额外的行为，可以使用装饰模式。
//:    装饰能将业务逻辑组织为层次结构，你可为各层创建一个装饰，在运行时将各种不同逻辑组合成对象。
//:    由于这些对象都遵循通用接口，客户端代码能以相同的方式使用这些对象。
//: 2. 如果用继承来扩展对象行为的方案难以实现或者根本不可行，你可以使用该模式。
//:    许多编程语言使用 final 最终 关键字来限制对某个类的进一步扩展。复用最终类已有行为的唯一方法是使用装饰模式：用封装器对其进行封装。
//:
//: ## 实现方式
//:
//: 1. 确保业务逻辑可用一个基本组件及多个额外可选层次表示。
//: 2. 找出基本组件和可选层次的通用方法。创建一个组件接口并在其中声明这些方法。
//: 3. 创建一个具体组件类， 并定义其基础行为。
//: 4. 创建装饰基类，使用一个成员变量存储指向被封装对象的引用。该成员变量必须被声明为组件接口类型，
//:    从而能在运行时连接具体组件和装饰。装饰基类必须将所有工作委派给被封装的对象。
//: 5. 确保所有类实现组件接口。
//: 6. 将装饰基类扩展为具体装饰。具体装饰必须在调用父类方法（总是委派给被封装对象）之前或之后执行自身的行为。
//: 7. 客户端代码负责创建装饰并将其组合成客户端所需的形式。
//:
//: ## 装饰模式优缺点
//:
//: ### 优点
//: 1. 你无需创建新子类即可扩展对象的行为。
//: 2. 你可以在运行时添加或删除对象的功能。
//: 3. 你可以用多个装饰封装对象来组合几种行为。
//: 4. 单一职责原则。你可以将实现了许多不同行为的一个大类拆分为多个较小的类。
//:
//: ### 缺点
//: 1. 在封装器栈中删除特定封装器比较困难。
//: 2. 实现行为不受装饰栈顺序影响的装饰比较困难。
//: 3. 各层的初始化配置代码看上去可能会很糟糕。
//:

import XCTest

/// The base Component interface defines operations that can be altered by
/// decorators.
protocol Component {
    
    func operation() -> String
}

/// Concrete Components provide default implementations of the operations. There
/// might be several variations of these classes.
class ConcreteComponent: Component {

    func operation() -> String {
        return "ConcreteComponent"
    }
}

/// The base Decorator class follows the same interface as the other components.
/// The primary purpose of this class is to define the wrapping interface for
/// all concrete decorators. The default implementation of the wrapping code
/// might include a field for storing a wrapped component and the means to
/// initialize it.
class Decorator: Component {

    private var component: Component

    init(_ component: Component) {
        self.component = component
    }

    /// The Decorator delegates all work to the wrapped component.
    func operation() -> String {
        return component.operation()
    }
}

/// Concrete Decorators call the wrapped object and alter its result in some way.
class ConcreteDecoratorA: Decorator {

    /// Decorators may call parent implementation of the operation, instead of
    /// calling the wrapped object directly. This approach simplifies extension
    /// of decorator classes.
    override func operation() -> String {
        return "ConcreteDecoratorA(" + super.operation() + ")"
    }
}

/// Decorators can execute their behavior either before or after the call to a wrapped object.
class ConcreteDecoratorB: Decorator {

    override func operation() -> String {
        return "ConcreteDecoratorB(" + super.operation() + ")"
    }
}

/// The client code works with all objects using the Component interface. This
/// way it can stay independent of the concrete classes of components it works with.
class Client {
    // ...
    static func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }
    // ...
}

/// Let's see how it all works together.
class DecoratorConceptual: XCTestCase {

    func testDecoratorConceptual() {
        // This way the client code can support both simple components...
        print("Client: I've got a simple component")
        let simple = ConcreteComponent()
        Client.someClientCode(component: simple)

        // ...as well as decorated ones.
        //
        // Note how decorators can wrap not only simple components but the other
        // decorators as well.
        let decorator1 = ConcreteDecoratorA(simple)
        let decorator2 = ConcreteDecoratorB(decorator1)
        print("\nClient: Now I've got a decorated component")
        Client.someClientCode(component: decorator2)
    }
}

let decorator = DecoratorConceptual()

decorator.testDecoratorConceptual()

// Output Result
// Client: I've got a simple component
// Result: ConcreteComponent
//
// Client: Now I've got a decorated component
// Result: ConcreteDecoratorB(ConcreteDecoratorA(ConcreteComponent))
