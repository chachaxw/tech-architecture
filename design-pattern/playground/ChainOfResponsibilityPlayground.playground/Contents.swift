import UIKit

var greeting = "Hello, Chain of Responsibility playground"

//: # 责任链模式(Chain of Responsibility)
//:
//: 责任链模式是一种行为设计模式，允许你将请求沿着处理者链进行发送。收到请求后，每个处理者均可对请求进行处理，或将其传递给链上的下个处理者。
//:
//: ![责任链模式(Chain of Responsibility)](chain-of-responsibility.png)
//:
//: ## 责任链模式结构
//:
//: ![责任链模式结构](structure.png)
//:
//: 1. 处理者（Han­dler）声明了所有具体处理者的通用接口。该接口通常仅包含单个方法用于请求处理，但有时其还会包含一个设置链上下个处理者的方法。
//: 2. 基础处理者（Base Han­dler）是一个可选的类，你可以将所有处理者共用的样本代码放置在其中。通常情况下，
//:    该类中定义了一个保存对于下个处理者引用的成员变量。客户端可通过将处理者传递给上个处理者的构造函数或设定方法来创建链。
//:    该类还可以实现默认的处理行为：确定下个处理者存在后再将请求传递给它。
//: 3. 具体处理者（Con­crete Han­dlers）包含处理请求的实际代码。每个处理者接收到请求后，都必须决定是否进行处理，以及是否沿着链传递请求。
//:    处理者通常是独立且不可变的，需要通过构造函数一次性地获得所有必要地数据。
//: 4. 客户端（Client）可根据程序逻辑一次性或者动态地生成链。值得注意的是，请求可发送给链上的任意一个处理者，而非必须是第一个处理者。
//:
//: ## 责任链模式适合应用场景
//:
//: 1. 当程序需要使用不同方式处理不同种类请求，而且请求类型和顺序预先未知时，可以使用责任链模式。
//:    该模式能将多个处理者连接成一条链。接收到请求后，它会“询问”每个处理者是否能够对其进行处理。这样所有处理者都有机会来处理请求。
//: 2. 当必须按顺序执行多个处理者时，可以使用该模式。
//:    无论你以何种顺序将处理者连接成一条链，所有请求都会严格按照顺序通过链上的处理者。
//: 3. 如果所需处理者及其顺序必须在运行时进行改变，可以使用责任链模式。
//:    如果在处理者类中有对引用成员变量的设定方法，你将能动态地插入和移除处理者，或者改变其顺序。
//:
//: ## 实现方式
//:
//: 1. 声明处理者接口并描述请求处理方法的签名。
//:    确定客户端如何将请求数据传递给方法。最灵活的方式是将请求转换为对象，然后将其以参数的形式传递给处理函数。
//: 2. 为了在具体处理者中消除重复的样本代码，你可以根据处理者接口创建抽象处理者基类。
//:    该类需要有一个成员变量来存储指向链上下个处理者的引用。你可以将其设置为不可变类。
//:    但如果你打算在运行时对链进行改变，则需要定义一个设定方法来修改引用成员变量的值。
//:    为了使用方便，你还可以实现处理方法的默认行为。如果还有剩余对象，该方法会将请求传递给下个对象。
//:    具体处理者还能够通过调用父对象的方法来使用这一行为。
//: 3. 依次创建具体处理者子类并实现其处理方法。每个处理者在接收到请求后都必须做出两个决定：
//:    * 是否自行处理这个请求。
//:    * 是否将该请求沿着链进行传递。
//: 4. 客户端可以自行组装链，或者从其他对象处获得预先组装好的链。在后一种情况下，你必须实现工厂类以根据配置或环境设置来创建链。
//: 5. 客户端可以触发链中的任意处理者，而不仅仅是第一个。请求将通过链进行传递，直至某个处理者拒绝继续传递，或者请求到达链尾。
//: 6. 由于链的动态性，客户端需要准备好处理以下情况：
//:    * 链中可能只有单个链接。
//:    * 部分请求可能无法到达链尾。
//:    * 其他请求可能直到链尾都未被处理。
//:
//: ## 责任链模式优缺点
//:
//: 优点：
//: 1. 你可以控制请求处理的顺序。
//: 2. 单一职责原则。你可对发起操作和执行操作的类进行解耦。
//: 3. 开闭原则。你可以在不更改现有代码的情况下在程序中新增处理者。
//:
//: 缺点：
//: 1. 部分请求可能未被处理。
//:
//:

import XCTest

/// The handler protocol declares a method for building the chain of handlers
/// It also declares a method for executing a request.
protocol Handler: class {
    
    @discardableResult
    func setNext(handler: Handler) -> Handler
    
    func handle(request: String) -> String?
    
    var nextHandler: Handler? { get set }
}


extension Handler {
    func setNext(handler: Handler) -> Handler {
        self.nextHandler = handler
        
        /// Returning a handler from here will let us link handlers in a convenient way like this:
        /// monkey.setNext(handler: squirrel).setNext(handler: dog)
        return handler
    }
    
    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

/// All Concrete Handlers either handle a request or pass it to the next handler in the chain.
class MonkeyHandler: Handler {
    
    var nextHandler: Handler?
    
    func handle(request: String) -> String? {
        if (request == "Banana") {
            return "Monkey: I'll set the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class SquirrelHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {

        if (request == "Nut") {
            return "Squirrel: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

class DogHandler: Handler {

    var nextHandler: Handler?

    func handle(request: String) -> String? {
        if (request == "MeatBall") {
            return "Dog: I'll eat the " + request + ".\n"
        } else {
            return nextHandler?.handle(request: request)
        }
    }
}

/// The client code is usually suited to work with a single handler. In most cases, it is not even aware that the handler is part of a chain.
class Client {
    static func someClientCode(handler: Handler) {
        let food = ["Nut", "Banana", "Cup of coffee"]
        
        for item in food {
            
            print("Client: Who wants to a " + item + "?\n")
            
            guard let result = handler.handle(request: item) else {
                print(" " + item + " was left untouched.\n")
                return
            }
            
            print(" " + result)
        }
    }
}

/// Let's see how it all works together.
class ChainOfResponsibilityConceptual: XCTestCase {
 
    func test() {

        /// The other part of the client code constructs the actual chain.

        let monkey = MonkeyHandler()
        let squirrel = SquirrelHandler()
        let dog = DogHandler()
        monkey.setNext(handler: squirrel).setNext(handler: dog)

        /// The client should be able to send a request to any handler, not just
        /// the first one in the chain.

        print("Chain: Monkey > Squirrel > Dog\n\n")
        Client.someClientCode(handler: monkey)
        print()
        print("Subchain: Squirrel > Dog\n\n")
        Client.someClientCode(handler: squirrel)
    }
}

let test = ChainOfResponsibilityConceptual()

test.test()

// Output: 
//
// Chain: Monkey > Squirrel > Dog
//
//
// Client: Who wants to a Nut?
//
// Squirrel: I'll eat the Nut.
//
// Client: Who wants to a Banana?
//
// Monkey: I'll set the Banana.
//
// Client: Who wants to a Cup of coffee?
//
// Cup of coffee was left untouched.
//
//
// Subchain: Squirrel > Dog
//
//
// Client: Who wants to a Nut?
//
// Squirrel: I'll eat the Nut.
//
// Client: Who wants to a Banana?
//
// Banana was left untouched.
