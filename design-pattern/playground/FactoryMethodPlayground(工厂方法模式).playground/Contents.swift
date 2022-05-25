
var str = "Hello, Factory Method Pattern playground"

//: ## 工厂方法模式的定义
//:
//: 定义一个用于创建对象的接口，让子类决定实例化哪一个类。工厂方法使一个类的实例化延迟到其子类。
//:
//: Define an interface for creating an object,but let subclasses decide which class to instantiate.Factory Method lets a class defer instantiation to subclasses.
//:
//: 工厂方法模式的通用类图：
//:
//: ![工厂方法模式](FactoryMethodPattern.png)
//:
//: 在工厂方法模式中，抽象产品类Product负责定义产品的共性，实现对事物最抽象的定义，Creator为抽象创建类，
//: 也就是抽象工厂，具体如何创建产品类是由具体的实现工厂 ConcreteCreator完成的。
//:
//: 工厂方法模式的变种较多，我们来看一个比较实用的通用源码：
//:
/// 产品协议声明了所有具体产品必须实现的操作(Java中可以用抽象类)
protocol Product {
    func operation() -> String
}

/// 具体产品提供了产品协议的各种实现
class ConcreteProduct1: Product {
    func operation() -> String {
        return "{Result of the ConcreteProduct1}"
    }
}

class ConcreteProduct2: Product {
    func operation() -> String {
        return "{Result of the ConcreteProduct2}"
    }
}

/// 创建者协议声明了应该返回Product类的新对象的工厂方法。创建者的子类通常提供此方法的实现
protocol Creator {
    func factoryMethod() -> Product
    
    func someOperation() -> String
}

/// 创建者协议的默认实现，可以被子类覆盖
extension Creator {

    func someOperation() -> String {
        let product = factoryMethod()

        return "Creator: The same creator's code has just worked with " + product.operation()
    }
}

/// 具体的创建者会覆盖工厂方法，以便更改结果产品的类型
class ConcreteCreator1: Creator {

    /// 注意，该方法的返回类型仍然使用的是`Product`这个抽象产品，这样，创建者可以保持独立于具体产品的状态
    public func factoryMethod() -> Product {
        return ConcreteProduct1()
    }
}

class ConcreteCreator2: Creator {
    public func factoryMethod() -> Product {
        return ConcreteProduct2()
    }
}

let creator1 = ConcreteCreator1()
let creator2 = ConcreteCreator2()

creator1.someOperation()
creator2.someOperation()

/// 执行结果
/// Creator: The same creator's code has just worked with {Result of the ConcreteProduct1}
/// Creator: The same creator's code has just worked with {Result of the ConcreteProduct2}

//: ## 工厂方法模式的优缺点
//:
//: ### 优点
//:
//: 1. 一个调用者想创建一个对象，只要知道其名称就可以了
//:
//: 2. 扩展性高，如果想增加一个产品，只要扩展一个工厂类就可以
//:
//: 3. 产品的具体实现，调用者只关心产品的接口
//:
//: ### 缺点
//: 每次增加一个产品时，都需要增加一个具体类和对象实现工厂，使得系统中类的个数成倍增加，在一定程度上增加了系统的复杂度，同时也增加了系统具体类的依赖
//:
//: ## 总结
//:
//: 工厂方法模式是典型的解耦框架，高层模块只需要知道产品的抽象类，其他的实现类不需要关心，符合[迪米特法则](https://github.com/chachaxw/tech-architecture/blob/master/design-pattern/playground/LKPPlayground(迪米特原则).playground)；
//: 也符合[依赖倒置原则](https://github.com/chachaxw/tech-architecture/tree/master/design-pattern/playground/DIPPlayground(依赖倒置原则).playground)，只依赖产品类的抽象；
//: 当然也符合[里氏替换原则](https://github.com/chachaxw/tech-architecture/tree/master/design-pattern/playground/LSPPlayground(里氏替换原则).playground)，使用产品子类替换产品父类也是没问题的。
//:
