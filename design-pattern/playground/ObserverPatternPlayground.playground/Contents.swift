import UIKit

//: ## 观察者模式
//:
//: 当对象间存在一对多关系时，则使用观察者模式(Observer Pattern)。比如，当一个对象被修改时，则会自动通知依赖它的对象。观察者模式属于行为模式
//:
//: 在观察者模式中有两个主要角色：Subject（主题）和 Observer（观察者）。关系结构如下图:
//:
//: ![ObserverPattern_1](ObserverPattern_1.png)
//:
//: ### 观察者模式优缺点
//:
//: 优点:
//: 1. 观察者和被观察者是抽象耦合的。
//: 2. 建立一套出发机制
//: 缺点:
//: 1. 如果一个被观察者对象有很多的直接和间接的观察者的话，将所有的观察者都通知到会花费很多时间
//: 2. 如果在观察者和观察目标之间有循环依赖的话，观察目标会触发它们之间进行循环调用，可能导致系统崩溃
//: 3. 观察者模式没有相应的机制让观察者知道所观察的目标对象是怎么发生变化的，而仅仅是知道观察目标发生了变化
//:
//: ### 观察者模式使用场景
//:
//: * 一个抽象模型有两个方面，其中一个方面依赖于另一个方面。将这些方面封装在独立的对象中使它们可以各自独立地改变和复用
//: * 一个对象的改变将导致其他一个或多个对象也发生改变，而不知道具体有多少对象将发生改变，可以降低对象之间的耦合度
//: * 一个对象必须通知其他对象，而并不知道这些对象是谁
//: * 需要在系统中创建一个触发链，A对象的行为将影响B对象，B对象的行为将影响C对象……，可以使用观察者模式创建一种链式触发机制
//:
//: ### 观察者模式结构
// ╭─────────────╮  Fire Event  ╭──────────────╮
// │             │─────────────>│              │
// │   Subject   │              │   Observer   │
// │             │<─────────────│              │
// ╰─────────────╯  Subscribe   ╰──────────────╯

//: ### 观察者模式相关文章
//: 1. [观察者模式(Swift)](https://refactoringguru.cn/design-patterns/observer)
//: 2. [观察者模式(Java)](https://www.runoob.com/design-pattern/observer-pattern.html)
//: 3. [观察者模式和发布订阅模式有什么不同?](https://www.zhihu.com/question/23486749/answer/314072549)

var str = "Hello, Observer Pattern playground"

//: 下面我们来看看如何实现观察者模式。我们先画出UML类图，类图如下:
//:
//: ![ObserverPattern_2](ObserverPattern_2.png)
//:
//: 观察者模式通常需要在Subject类中维护一个Observer观察者数组，只要Subject中有一些事件变化，就可以通知所有的观察者并执行相应逻辑。
//:
//: 实现代码如下:

// 创建一个Observer协议
protocol Observer: class {
    func notify(subject: Subject) -> Void
}

class ObserverA: Observer {
    private var name: String = ""

    init(name: String) {
        self.name = name
    }

    func notify(subject: Subject) {
        if subject.state < 3 {
            print("观察者\(name)已被通知\n")
        }
    }
}

class ObserverB: Observer {
    private var name: String = ""
    
    init(name: String) {
        self.name = name
    }

    func notify(subject: Subject) {
        if subject.state > 3 {
            print("观察者\(name)已被通知\n")
        }
    }
}

// 实现Subject类
class Subject {
    var state: Int = {
        return Int(arc4random_uniform(10))
    }()

    var observers: [Observer] = []
    
    /// 添加观察者到观察者列表
    func addObserver(observer: Observer) {
        observers.append(observer)
        print("Subject: 添加了一个观察者\(observer).\n")
    }

    /// 从观察者列表移除观察者
    func deleteObserver(observer: Observer) {
        if let index: Int = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
            print("Subject: 移除了一个观察者\(observer).\n")
        }
    }

    /// 通知所有的观察者更新
    func notifyAllObservers() {
        observers.forEach({ $0.notify(subject: self) })
        print("Subject: 通知所有的观察者...\n")
    }
    
    /// 通常，订阅逻辑仅是Subject真正可以做的一小部分。主体通常持有一些重要的业务逻辑，只要有重要事情要发生（或之后），就会触发通知方法。
    func someBusinessLogic() {
        print("Subject: 正在执行一些业务逻辑.\n")
        state = Int(arc4random_uniform(10))
        print("Subject: 我的状态已经改变: \(state).\n")
        notifyAllObservers()
    }
}

let subject = Subject()
let observerA = ObserverA(name: "ObserverA")
let observerB = ObserverB(name: "ObserverB")

subject.addObserver(observer: observerA)
subject.addObserver(observer: observerB)

subject.someBusinessLogic()
subject.deleteObserver(observer: observerA)
subject.someBusinessLogic()

//: 上述代码执行结果如下:
//:
//: ![代码执行结果](result.png)
