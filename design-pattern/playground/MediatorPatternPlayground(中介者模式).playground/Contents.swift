import UIKit

var greeting = "Hello, Mediator Pattern playground"

//:
//: # 中介者模式(Mediator Pattern)
//:
//: 中介者模式是一种行为设计模式，能让你减少对象之间混乱无序的依赖关系。该模式会限制对象之间的直接交互，迫使它们通过一个中介者对象进行合作。
//:
//: ![中介者模式(Mediator Pattern)](mediator.png)
//:
//: ## 中介者模式结构
//:
//: ![中介者模式结构](structure.png)
//:
//: 1. 组件（Com­po­nent）是各种包含业务逻辑的类。每个组件都有一个指向中介者的引用，该引用被声明为中介者接口类型。
//:    组件不知道中介者实际所属的类，因此你可通过将其连接到不同的中介者以使其能在其他程序中复用。
//: 2. 中介者（Medi­a­tor）接口声明了与组件交流的方法，但通常仅包括一个通知方法。组件可将任意上下文（包括自己的对象）作为该方法的参数，只有这样接收组件和发送者类之间才不会耦合。
//: 3. 具体中介者（Con­crete Medi­a­tor）封装了多种组件间的关系。具体中介者通常会保存所有组件的引用并对其进行管理，甚至有时会对其生命周期进行管理。
//: 4. 组件并不知道其他组件的情况。如果组件内发生了重要事件，它只能通知中介者。中介者收到通知后能轻易地确定发送者，
//:    这或许已足以判断接下来需要触发的组件了。对于组件来说，中介者看上去完全就是一个黑箱。发送者不知道最终会由谁来处理自己的请求，接收者也不知道最初是谁发出了请求。
//:
//: ## 中介者模式适合应用场景
//:
//: 1. 当一些对象和其他对象紧密耦合以致难以对其进行修改时，可使用中介者模式。
//:    该模式让你将对象间的所有关系抽取成为一个单独的类，以使对于特定组件的修改工作独立于其他组件。
//: 2. 当组件因过于依赖其他组件而无法在不同应用中复用时， 可使用中介者模式。
//:    应用中介者模式后，每个组件不再知晓其他组件的情况。尽管这些组件无法直接交流，但它们仍可通过中介者对象进行间接交流。
//:    如果你希望在不同应用中复用一个组件，则需要为其提供一个新的中介者类。
//: 3. 如果为了能在不同情景下复用一些基本行为，导致你需要被迫创建大量组件子类时，可使用中介者模式。
//:    由于所有组件间关系都被包含在中介者中，因此你无需修改组件就能方便地新建中介者类以定义新的组件合作方式。
//:
//: ## 实现方式
//:
//: 1. 找到一组当前紧密耦合，且提供其独立性能带来更大好处的类（例如更易于维护或更方便复用）。
//: 2. 声明中介者接口并描述中介者和各种组件之间所需的交流接口。在绝大多数情况下，一个接收组件通知的方法就足够了。
//: 3. 实现具体中介者类。该类可从自行保存其下所有组件的引用中受益。
//: 4. 你可以更进一步，让中介者负责组件对象的创建和销毁。此后，中介者可能会与工厂或外观类似。
//: 5. 组件必须保存对于中介者对象的引用。该连接通常在组件的构造函数中建立，该函数会将中介者对象作为参数传递。
//: 6. 修改组件代码，使其可调用中介者的通知方法，而非其他组件的方法。然后将调用其他组件的代码抽取到中介者类中，并在中介者接收到该组件通知时执行这些代码。
//:
//: ## 中介者模式优缺点
//:
//: ### 优点
//:
//: 1. 单一职责原则。你可以将多个组件间的交流抽取到同一位置，使其更易于理解和维护。
//: 2. 开闭原则。你无需修改实际组件就能增加新的中介者。
//: 3. 你可以减轻应用中多个组件间的耦合情况。
//: 4. 你可以更方便地复用各个组件。
//:
//: ### 缺点
//:
//: 1. 一段时间后，中介者可能会演化成为上帝对象。
//:
//:

import XCTest

/// The Mediator interface declares a method used by components to notify the
/// mediator about various events. The Mediator may react to these events and pass the execution to other components.
protocol Mediator: AnyObject {
    
    func notify(sender: BaseComponent, event: String)
}

/// The Base Component provides the basic functionality of storing a mediator's instance inside component objects.
class BaseComponent {

    fileprivate weak var mediator: Mediator?

    init(mediator: Mediator? = nil) {
        self.mediator = mediator
    }

    func update(mediator: Mediator) {
        self.mediator = mediator
    }
}

/// Concrete Components implement various functionality. They don't depend on
/// other components. They also don't depend on any concrete mediator classes.
class Component1: BaseComponent {

    func doA() {
        print("Component 1 does A.")
        mediator?.notify(sender: self, event: "A")
    }

    func doB() {
        print("Component 1 does B.\n")
        mediator?.notify(sender: self, event: "B")
    }
}

class Component2: BaseComponent {

    func doC() {
        print("Component 2 does C.")
        mediator?.notify(sender: self, event: "C")
    }

    func doD() {
        print("Component 2 does D.")
        mediator?.notify(sender: self, event: "D")
    }
}

/// Concrete Mediators implement cooperative behavior by coordinating several components.
class ConcreteMediator: Mediator {
    
    private var component1: Component1
    private var component2: Component2
    
    init(_ component1: Component1, _ component2: Component2) {
        self.component1 = component1
        self.component2 = component2
        
        component1.update(mediator: self)
        component2.update(mediator: self)
    }
    
    func notify(sender: BaseComponent, event: String) {
        if event == "A" {
            print("Mediator reacts on A and triggers following operations:")
            self.component2.doC()
        } else if (event == "D") {
            print("Mediator reacts on D and triggers following operations:")
            self.component1.doB()
            self.component2.doC()
        }
    }
}

/// Let's see how it all works together.
class MediatorConceptual: XCTestCase {

    func testMediatorConceptual() {

        let component1 = Component1()
        let component2 = Component2()

        let mediator = ConcreteMediator(component1, component2)
        print("Client triggers operation A.")
        component1.doA()

        print("\nClient triggers operation D.")
        component2.doD()

        print(mediator)
    }
}

let mediator = MediatorConceptual()

mediator.testMediatorConceptual()

// Output
// Client triggers operation A.
// Component 1 does A.
// Mediator reacts on A and triggers following operations:
// Component 2 does C.
//
// Client triggers operation D.
// Component 2 does D.
// Mediator reacts on D and triggers following operations:
// Component 1 does B.
//
// Component 2 does C.
