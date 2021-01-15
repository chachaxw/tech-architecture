import UIKit

//: ## 发布订阅模式
//: 在软件架构中，发布-订阅是一种消息范式，消息的发送者（称为发布者）不会将消息发送给特定的接收者（称为订阅者）。
//: 而是将发布的消息定义为不同的类型，无需了解哪些订阅者（如果有的话）可能存在。同样的，订阅者可以表达对一个或
//: 多个类别的兴趣，只接收感兴趣的消息，无需了解哪些发布者（如果有的话）可能存在。
//:
//: 在发布订阅模式中有三个主要角色：Publisher（发布者）、 Channels（通道）和 Subscriber（订阅者）。关系结构如下图:
//:
//: ![PublishSubscribe_1](PublishSubscribe_1.png)
//:
//: 发布订阅模式属于观察者模式的升级版，比观察者模式多了一个事件通道(Event Channel)，主要用来作为发布者发布消息的一个管理通道，
//: 发布者发布的所有消息都由这个通道来分发。订阅者订阅了某种主题的消息，一旦发布者有相关主题的消息，就会通过事件通道来触发更新事件，
//: 将消息发送到相应的订阅者手中。
//:
//: ### 发布订阅模式使用场景
//:
//: * 对象间存在一对多关系，一个对象的状态发生改变会影响其他对象
//: * 作为事件总线，来实现不同模块间的通信
//: * [Swift EventBus](https://github.com/cesarferreira/SwiftEventBus)
//:
//: ### 发布订阅模式结构
// ╭─────────────╮                 ╭───────────────╮   Fire Event   ╭──────────────╮
// │             │  Publish Event  │               │───────────────>│              │
// │  Publisher  │────────────────>│ Event Channel │                │  Subscriber  │
// │             │                 │               │<───────────────│              │
// ╰─────────────╯                 ╰───────────────╯    Subscribe   ╰──────────────╯

//: ### 发布订阅模式相关文章
//: 1. [观察者模式(Swift)](https://refactoringguru.cn/design-patterns/observer)
//: 2. [观察者模式(Java)](https://www.runoob.com/design-pattern/observer-pattern.html)
//: 3. [观察者模式和发布订阅模式有什么不同?](https://www.zhihu.com/question/23486749/answer/314072549)
//: 4. [图解常见的九种设计模式](https://mp.weixin.qq.com/s/EQ1_bEW7ti0xd3AcJHmLyw)
//: 5. [Implementing Events in Swift](https://blog.scottlogic.com/2015/02/05/swift-events.html)

var str = "Hello, Publish Subscribe playground"

//: 下面我们来看看如何实现发布订阅模式。

typealias EventHandler = (_ args: Any...) -> ()

protocol Invocable: class {
    func invoke(data: Any)
}

class EventEmitter {
    private var callbacks = [String: [EventHandler]]()
    
    /// 订阅指定的主题
    func subscribe(topic: String, handlers: [EventHandler]...) {
        var topics: [EventHandler] = callbacks[topic] ?? []

        handlers.forEach({ topics.append(contentsOf: $0) })

        callbacks[topic] = topics
    }

    /// 取消订阅指定的主题
    func unsubscribe(topic: String, handler: EventHandler?) -> Bool {
        if handler == nil {
            return (callbacks.removeValue(forKey: topic) != nil)
        }
        
        let topics: [EventHandler] = callbacks[topic] ?? []

        /// 该段代码无法生效，原因是，Swift 运算符（===和!==）只在AnyObject里面有定义，未在闭包里面实现该协议，所以无法从数组中获取相应的函数
        /// 解决方案请参考(https://stackoverflow.com/questions/24111984/how-do-you-test-functions-and-closures-for-equality)
//        let index: Int? = topics.firstIndex(where: { $0 === handler! as EventHandler })

        if (topics.isEmpty) {
            callbacks.removeValue(forKey: topic)
        }

        return true;
    }
    
    /// 为指定的主题发布消息
    func publish(topic: String, _ args: Any...) -> [Any]? {
        let topics: [EventHandler] = callbacks[topic] ?? []
        
        return topics.map({ handler in
            print("处理函数 \(String(describing: handler))")
            return handler(args)
        })
    }
}
