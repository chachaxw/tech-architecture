
var greeting = "Hello, playground"

//: ### 抽象工厂模式的定义
//:
//: 抽象工厂模式是一种创建型设计模式，它能创建一系列相关的对象，而无需指定其具体类。
//: 抽象工厂定义了用于创建不同产品的接口，但将实际的创建工作留给了具体工厂类。每个工厂类型都对应一个特定的产品变体。
//:
//: ![抽象工厂模式(AbstractFactory)](AbstractFactory.png)
//:
//: ### 抽象工厂模式的结构
//:
//: ![抽象工厂模式的结构](structure.png)
//:
//: 1. 抽象产品 （Abstract Product） 为构成系列产品的一组不同但相关的产品声明接口。
//: 2. 具体产品 （Concrete Product） 是抽象产品的多种不同类型实现。 所有变体 （维多利亚/现代） 都必须实现相应的抽象产品 （椅子/沙发）。
//: 3. 抽象工厂 （Abstract Factory） 接口声明了一组创建各种抽象产品的方法。
//: 4. 具体工厂 （Concrete Factory） 实现抽象工厂的构建方法。 每个具体工厂都对应特定产品变体， 且仅创建此种产品变体。
//: 5. 尽管具体工厂会对具体产品进行初始化， 其构建方法签名必须返回相应的抽象产品。 这样，使用工厂类的客户端代码就不会与工厂创建的特定产品变体耦合。
//: 客户端 （Client） 只需通过抽象接口调用工厂和产品对象， 就能与任何具体工厂/产品变体交互。
//:

//: ### 抽象工厂模式实例：

protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    
    func createProductB() -> AbstractProductB
}

/// 具体工厂1
class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }
    
    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }
    
}

/// 具体工厂2
class ConcreteFactory2: AbstractFactory {

    func createProductA() -> AbstractProductA {
        return ConcreteProductA2()
    }

    func createProductB() -> AbstractProductB {
        return ConcreteProductB2()
    }
}

protocol AbstractProductA {
    func usefulFunctionA() -> String
}

/// 具体的产品由相应的具体的工厂生产
class ConcreteProductA1: AbstractProductA {

    func usefulFunctionA() -> String {
        return "The result of the product A1."
    }
}

class ConcreteProductA2: AbstractProductA {

    func usefulFunctionA() -> String {
        return "The result of the product A2."
    }
}

/// 另一个产品的基本协议。所有产品都可以与每个产品交互，其他，但只有相同的产品具体的变体之间才能进行适当的交互。
protocol AbstractProductB {

    /// 产品B能够做自己的事情......
    func usefulFunctionB() -> String

    /// ......但它也可以与ProductA合作
    ///
    /// 抽象工厂确保它创建的所有产品都是相同的变体，因此互相兼容。
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

class ConcreteProductB1: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B1."
    }

    /// 此变体产品 B1 只能与变体产品 A1正常工作。否则，它可以接受任何实例 AbstractProductA 作为参数。
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B1 collaborating with the (\(result))"
    }
}

class ConcreteProductB2: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B2."
    }

    /// 此变体产品 B2 只能与变体产品 A2 正常工作。否则，它可以接受任何实例 AbstractProductA 作为参数。
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B2 collaborating with the (\(result))"
    }
}

/// 客户端代码仅通过摘要与工厂和产品配合使用，类型：AbstractFactory 和 AbstractProduct。这可以让你通过任何工厂或客户端代码的产品子类，而不破坏它。
class Client {

    static func someClientCode(factory: AbstractFactory) {
        let productA = factory.createProductA()
        let productB = factory.createProductB()

        print(productB.usefulFunctionB())
        print(productB.anotherUsefulFunctionB(collaborator: productA))
    }
}

print("Client: Testing client code with the first factory type:")
Client.someClientCode(factory: ConcreteFactory1())

print("Client: Testing the same client code with the second factory type:")
Client.someClientCode(factory: ConcreteFactory2())

/// 输出结果：
/// Client: Testing client code with the first factory type:
/// The result of the product B1.
/// The result of the B1 collaborating with the (The result of the product A1.)
/// Client: Testing the same client code with the second factory type:
/// The result of the product B2.
/// The result of the B2 collaborating with the (The result of the product A2.)
