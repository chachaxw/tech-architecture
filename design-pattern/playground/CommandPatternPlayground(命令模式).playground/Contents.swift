import UIKit

var greeting = "Hello, Command Pattern playground"

//: # 命令模式(Command Pattern)
//:
//: 命令模式是一种行为设计模式，它可将请求转换为一个包含与请求相关的所有信息的独立对象。该转换让你能根据不同的请求将方法参数化、延迟请求执行或将其放入队列中，且能实现可撤销操作。
//:
//: ![命令模式(Command Pattern)](command.png)
//:
//: ## 命令模式结构
//:
//: ![命令模式结构(Command Pattern Structure)](structure.png)
//:
//: 1. 发送者（Sender）——亦称“触发者（Invok­er）”——类负责对请求进行初始化，其中必须包含一个成员变量来存储对于命令对象的引用。
//:    发送者触发命令，而不向接收者直接发送请求。注意，发送者并不负责创建命令对象：它通常会通过构造函数从客户端处获得预先生成的命令。
//: 2. 命令（Com­mand）接口通常仅声明一个执行命令的方法。
//: 3. 具体命令（Con­crete Com­mands）会实现各种类型的请求。具体命令自身并不完成工作，而是会将调用委派给一个业务逻辑对象。但为了简化代码，这些类可以进行合并。
//:    接收对象执行方法所需的参数可以声明为具体命令的成员变量。你可以将命令对象设为不可变，仅允许通过构造函数对这些成员变量进行初始化。
//: 4. 接收者（Receiv­er）类包含部分业务逻辑。几乎任何对象都可以作为接收者。绝大部分命令只处理如何将请求传递到接收者的细节，接收者自己会完成实际的工作。
//: 5. 客户端（Client）会创建并配置具体命令对象。客户端必须将包括接收者实体在内的所有请求参数传递给命令的构造函数。此后，生成的命令就可以与一个或多个发送者相关联了。
//:
//: ## 命令模式适合应用场景
//:
//: 1. 如果你需要通过操作来参数化对象，可使用命令模式。
//:    命令模式可将特定的方法调用转化为独立对象。这一改变也带来了许多有趣的应用：你可以将命令作为方法的参数进行传递、将命令保存在其他对象中，或者在运行时切换已连接的命令等。
//:    举个例子：你正在开发一个 GUI 组件（例如上下文菜单），你希望用户能够配置菜单项，并在点击菜单项时触发操作。
//: 2. 如果你想要将操作放入队列中、 操作的执行或者远程执行操作， 可使用命令模式。
//:    同其他对象一样，命令也可以实现序列化（序列化的意思是转化为字符串），从而能方便地写入文件或数据库中。
//:    一段时间后，该字符串可被恢复成为最初的命令对象。因此，你可以延迟或计划命令的执行。但其功能远不止如此！
//:    使用同样的方式，你还可以将命令放入队列、记录命令或者通过网络发送命令。
//: 3. 如果你想要实现操作回滚功能，可使用命令模式。
//:    尽管有很多方法可以实现撤销和恢复功能，但命令模式可能是其中最常用的一种。
//:    为了能够回滚操作，你需要实现已执行操作的历史记录功能。命令历史记录是一种包含所有已执行命令对象及其相关程序状态备份的栈结构。
//:    这种方法有两个缺点。首先，程序状态的保存功能并不容易实现，因为部分状态可能是私有的。你可以使用备忘录模式来在一定程度上解决这个问题。
//: 4. 其次，备份状态可能会占用大量内存。因此，有时你需要借助另一种实现方式：命令无需恢复原始状态，而是执行反向操作。反向操作也有代价：它可能会很难甚至是无法实现。
//:
//: ## 实现方式
//:
//: 1. 声明仅有一个执行方法的命令接口。
//: 2. 抽取请求并使之成为实现命令接口的具体命令类。每个类都必须有一组成员变量来保存请求参数和对于实际接收者对象的引用。所有这些变量的数值都必须通过命令构造函数进行初始化。
//: 3. 找到担任发送者职责的类。在这些类中添加保存命令的成员变量。发送者只能通过命令接口与其命令进行交互。发送者自身通常并不创建命令对象，而是通过客户端代码获取。
//: 4. 修改发送者使其执行命令，而非直接将请求发送给接收者。
//: 5. 客户端必须按照以下顺序来初始化对象：
//:    * 创建接收者。
//:    * 创建命令，如有需要可将其关联至接收者。
//:    * 创建发送者并将其与特定命令关联。
//:
//: ## 命令模式优缺点
//:
//: ### 优点
//:
//: 1. 单一职责原则。你可以解耦触发和执行操作的类。
//: 2. 开闭原则。你可以在不修改已有客户端代码的情况下在程序中创建新的命令。
//: 3. 你可以实现撤销和恢复功能。
//: 4. 你可以实现操作的延迟执行。
//: 5. 你可以将一组简单命令组合成一个复杂命令。
//:
//: ## 缺点
//:
//: 1. 代码可能会变得更加复杂，因为你在发送者和接收者之间增加了一个全新的层次。
//:
//:

import XCTest

/// The Command interface declares a method for executing a command.
protocol Command {

    func execute()
}

/// Some commands can implement simple operations on their own.
class SimpleCommand: Command {

    private var payload: String

    init(_ payload: String) {
        self.payload = payload
    }

    func execute() {
        print("SimpleCommand: See, I can do simple things like printing (" + payload + ")")
    }
}

/// However, some commands can delegate more complex operations to other
/// objects, called "receivers."
class ComplexCommand: Command {

    private var receiver: Receiver

    /// Context data, required for launching the receiver's methods.
    private var a: String
    private var b: String

    /// Complex commands can accept one or several receiver objects along with
    /// any context data via the constructor.
    init(_ receiver: Receiver, _ a: String, _ b: String) {
        self.receiver = receiver
        self.a = a
        self.b = b
    }

    /// Commands can delegate to any methods of a receiver.
    func execute() {
        print("ComplexCommand: Complex stuff should be done by a receiver object.\n")
        receiver.doSomething(a)
        receiver.doSomethingElse(b)
    }
}

/// The Receiver classes contain some important business logic. They know how to
/// perform all kinds of operations, associated with carrying out a request. In
/// fact, any class may serve as a Receiver.
class Receiver {

    func doSomething(_ a: String) {
        print("Receiver: Working on (" + a + ")\n")
    }

    func doSomethingElse(_ b: String) {
        print("Receiver: Also working on (" + b + ")\n")
    }
}

/// The Invoker is associated with one or several commands. It sends a request
/// to the command.
class Invoker {

    private var onStart: Command?

    private var onFinish: Command?

    /// Initialize commands.
    func setOnStart(_ command: Command) {
        onStart = command
    }

    func setOnFinish(_ command: Command) {
        onFinish = command
    }

    /// The Invoker does not depend on concrete command or receiver classes. The
    /// Invoker passes a request to a receiver indirectly, by executing a
    /// command.
    func doSomethingImportant() {

        print("Invoker: Does anybody want something done before I begin?")

        onStart?.execute()

        print("Invoker: ...doing something really important...")
        print("Invoker: Does anybody want something done after I finish?")

        onFinish?.execute()
    }
}

/// Let's see how it all comes together.
class CommandConceptual: XCTestCase {

    func test() {
        /// The client code can parameterize an invoker with any commands.

        let invoker = Invoker()
        invoker.setOnStart(SimpleCommand("Say Hi!"))

        let receiver = Receiver()
        invoker.setOnFinish(ComplexCommand(receiver, "Send email", "Save report"))
        invoker.doSomethingImportant()
    }
}

let command = CommandConceptual()

command.test()

// Output:
//
// Invoker: Does anybody want something done before I begin?
// SimpleCommand: See, I can do simple things like printing (Say Hi!)
// Invoker: ...doing something really important...
// Invoker: Does anybody want something done after I finish?
// ComplexCommand: Complex stuff should be done by a receiver object.
//
// Receiver: Working on (Send email)
//
// Receiver: Also working on (Save report)
