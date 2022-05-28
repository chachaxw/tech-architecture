//:
//: ## 生成器模式
//:
//: 生成器模式是一种创建型设计模式，使你能够分步骤创建复杂对象。该模式允许你使用相同的创建代码生成不同类型和形式的对象。
//:
//: ## 生成器模式结构
//:
//: ![生成器模式结构](Builder.png)
//:
//: 1. 生成器 （Builder） 接口声明在所有类型生成器中通用的产品构造步骤。
//: 2. 具体生成器 （Concrete Builders） 提供构造过程的不同实现。具体生成器也可以构造不遵循通用接口的产品。
//: 3. 产品 （Products） 是最终生成的对象。由不同生成器构造的产品无需属于同一类层次结构或接口。
//: 4. 主管 （Director） 类定义调用构造步骤的顺序，这样你就可以创建和复用特定的产品配置。
//: 5. 客户端 （Client） 必须将某个生成器对象与主管类关联。一般情况下，你只需通过主管类构造函数的参数进行一次性关联即可。
//:    此后主管类就能使用生成器对象完成后续所有的构造任务。但在客户端将生成器对象传递给主管类制造方法时还有另一种方式。
//:    在这种情况下，你在使用主管类生产产品时每次都可以使用不同的生成器。
//:
//: ## 生成器模式的优点
//:
//: ### 优点：
//: 1. 你可以分步创建对象， 暂缓创建步骤或递归运行创建步骤。
//: 2. 生成不同形式的产品时， 你可以复用相同的制造代码。
//: 3. 单一职责原则。 你可以将复杂构造代码从产品的业务逻辑中分离出来。
//:
//: ### 缺点:
//: 1. 由于该模式需要新增多个类， 因此代码整体复杂程度会有所增加。
//:

import XCTest

/// The Builder interface specifies methods for creating the different parts of
/// the Product objects.
protocol Builder {

    func producePartA()
    func producePartB()
    func producePartC()
}

/// The Concrete Builder classes follow the Builder interface and provide
/// specific implementations of the building steps. Your program may have
/// several variations of Builders, implemented differently.
class ConcreteBuilder1: Builder {

    /// A fresh builder instance should contain a blank product object, which is
    /// used in further assembly.
    private var product = Product1()

    func reset() {
        product = Product1()
    }

    /// All production steps work with the same product instance.
    func producePartA() {
        product.add(part: "PartA1")
    }

    func producePartB() {
        product.add(part: "PartB1")
    }

    func producePartC() {
        product.add(part: "PartC1")
    }

    /// Concrete Builders are supposed to provide their own methods for
    /// retrieving results. That's because various types of builders may create
    /// entirely different products that don't follow the same interface.
    /// Therefore, such methods cannot be declared in the base Builder interface
    /// (at least in a statically typed programming language).
    ///
    /// Usually, after returning the end result to the client, a builder
    /// instance is expected to be ready to start producing another product.
    /// That's why it's a usual practice to call the reset method at the end of
    /// the `getProduct` method body. However, this behavior is not mandatory,
    /// and you can make your builders wait for an explicit reset call from the
    /// client code before disposing of the previous result.
    func retrieveProduct() -> Product1 {
        let result = self.product
        reset()
        return result
    }
}

/// The Director is only responsible for executing the building steps in a
/// particular sequence. It is helpful when producing products according to a
/// specific order or configuration. Strictly speaking, the Director class is
/// optional, since the client can control builders directly.
class Director {

    private var builder: Builder?

    /// The Director works with any builder instance that the client code passes
    /// to it. This way, the client code may alter the final type of the newly
    /// assembled product.
    func update(builder: Builder) {
        self.builder = builder
    }

    /// The Director can construct several product variations using the same
    /// building steps.
    func buildMinimalViableProduct() {
        builder?.producePartA()
    }

    func buildFullFeaturedProduct() {
        builder?.producePartA()
        builder?.producePartB()
        builder?.producePartC()
    }
}

/// It makes sense to use the Builder pattern only when your products are quite
/// complex and require extensive configuration.
///
/// Unlike in other creational patterns, different concrete builders can produce
/// unrelated products. In other words, results of various builders may not
/// always follow the same interface.
class Product1 {

    private var parts = [String]()

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return "Product parts: " + parts.joined(separator: ", ") + "\n"
    }
}

/// The client code creates a builder object, passes it to the director and then
/// initiates the construction process. The end result is retrieved from the
/// builder object.
class Client {
    // ...
    static func someClientCode(director: Director) {
        let builder = ConcreteBuilder1()
        director.update(builder: builder)
        
        print("Standard basic product:")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        // Remember, the Builder pattern can be used without a Director class.
        print("Custom product:")
        builder.producePartA()
        builder.producePartC()
        print(builder.retrieveProduct().listParts())
    }
    // ...
}

/// Let's see how it all comes together.
class BuilderConceptual: XCTestCase {

    func testBuilderConceptual() {
        let director = Director()
        Client.someClientCode(director: director)
    }
}

let builderConceptual = BuilderConceptual()

builderConceptual.testBuilderConceptual()

// 输出结果
// Standard basic product:
// Product parts: PartA1
//
// Standard full featured product:
// Product parts: PartA1, PartB1, PartC1
//
// Custom product:
// Product parts: PartA1, PartC1
 
