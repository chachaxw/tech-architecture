
var greeting = "Hello, Abstract Factory playground"

//: ## 抽象工厂模式的定义
//:
//: 抽象工厂模式是一种创建型设计模式，它能创建一系列相关的对象，而无需指定其具体类。
//: 抽象工厂定义了用于创建不同产品的接口，但将实际的创建工作留给了具体工厂类。每个工厂类型都对应一个特定的产品变体。
//:
//: ![抽象工厂模式(AbstractFactory)](AbstractFactory.png)
//:
//: ## 抽象工厂模式的结构
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
//: ## 抽象工厂模式优缺点
//:
//: ### 优点
//: 1. 你可以确保同一工厂生成的产品相互匹配。
//: 2. 你可以避免客户端和具体产品代码的耦合。
//: 3. 单一职责原则。 你可以将产品生成代码抽取到同一位置， 使得代码易于维护。
//: 4. 开闭原则。 向应用程序中引入新产品变体时， 你无需修改客户端代码。
//:
//: ### 缺点
//: 1. 由于采用该模式需要向应用中引入众多接口和类， 代码可能会比之前更加复杂。
//:
//: ## 抽象工厂模式实例：
//:

import XCTest

/// The Abstract Factory protocol declares a set of methods that return
/// different abstract products. These products are called a family and are
/// related by a high-level theme or concept. Products of one family are usually
/// able to collaborate among themselves. A family of products may have several
/// variants, but the products of one variant are incompatible with products of
/// another.
protocol AbstractFactory {
    func createProductA() -> AbstractProductA
    
    func createProductB() -> AbstractProductB
}

/// Concrete Factories produce a family of products that belong to a single
/// variant. The factory guarantees that resulting products are compatible. Note
/// that signatures of the Concrete Factory's methods return an abstract
/// product, while inside the method a concrete product is instantiated.
class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }
    
    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }
    
}

/// Each Concrete Factory has a corresponding product variant.
class ConcreteFactory2: AbstractFactory {

    func createProductA() -> AbstractProductA {
        return ConcreteProductA2()
    }

    func createProductB() -> AbstractProductB {
        return ConcreteProductB2()
    }
}

/// Each distinct product of a product family should have a base protocol. All
/// variants of the product must implement this protocol.
protocol AbstractProductA {
    func usefulFunctionA() -> String
}

/// Concrete Products are created by corresponding Concrete Factories.
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

/// The base protocol of another product. All products can interact with each
/// other, but proper interaction is possible only between products of the same
/// concrete variant.
protocol AbstractProductB {

    /// Product B is able to do its own thing...
    func usefulFunctionB() -> String

    /// ...but it also can collaborate with the ProductA.
    ///
    /// The Abstract Factory makes sure that all products it creates are of the
    /// same variant and thus, compatible.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

/// Concrete Products are created by corresponding Concrete Factories.
class ConcreteProductB1: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B1."
    }

    /// This variant, Product B1, is only able to work correctly with the
    /// variant, Product A1. Nevertheless, it accepts any instance of
    /// AbstractProductA as an argument.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B1 collaborating with the (\(result))"
    }
}

class ConcreteProductB2: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B2."
    }

    /// This variant, Product B2, is only able to work correctly with the
    /// variant, Product A2. Nevertheless, it accepts any instance of
    /// AbstractProductA as an argument.
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B2 collaborating with the (\(result))"
    }
}

/// The client code works with factories and products only through abstract
/// types: AbstractFactory and AbstractProduct. This lets you pass any factory
/// or product subclass to the client code without breaking it.
class Client {

    static func someClientCode(factory: AbstractFactory) {
        let productA = factory.createProductA()
        let productB = factory.createProductB()

        print(productB.usefulFunctionB())
        print(productB.anotherUsefulFunctionB(collaborator: productA))
    }
}

/// Let's see how it all works together.
class AbstractFactoryConceptual: XCTestCase {

    func testAbstractFactoryConceptual() {

        /// The client code can work with any concrete factory class.

        print("Client: Testing client code with the first factory type:")
        Client.someClientCode(factory: ConcreteFactory1())

        print("Client: Testing the same client code with the second factory type:")
        Client.someClientCode(factory: ConcreteFactory2())
    }
}

let abstractFactory = AbstractFactoryConceptual()

abstractFactory.testAbstractFactoryConceptual()

/// 输出结果：
/// Client: Testing client code with the first factory type:
/// The result of the product B1.
/// The result of the B1 collaborating with the (The result of the product A1.)
/// Client: Testing the same client code with the second factory type:
/// The result of the product B2.
/// The result of the B2 collaborating with the (The result of the product A2.)
