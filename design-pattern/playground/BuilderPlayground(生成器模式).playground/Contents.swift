//:
//: ## 生成器模式
//:
//: ![生成器模式](builder.png)
//:
//: 生成器模式是一种创建型设计模式，使你能够分步骤创建复杂对象。该模式允许你使用相同的创建代码生成不同类型和形式的对象。
//:
//: ## 生成器模式结构
//:
//: ![生成器模式结构](structure.png)
//:
//: 1. 生成器 （Builder） 接口声明在所有类型生成器中通用的产品构造步骤。
//: 2. 具体生成器 （Concrete Builders） 提供构造过程的不同实现。具体生成器也可以构造不遵循通用接口的产品。
//: 3. 产品 （Products） 是最终生成的对象。由不同生成器构造的产品无需属于同一类层次结构或接口。
//: 4. 主管 （Director） 类定义调用构造步骤的顺序，这样你就可以创建和复用特定的产品配置。
//: 5. 客户端 （Client） 必须将某个生成器对象与主管类关联。一般情况下，你只需通过主管类构造函数的参数进行一次性关联即可。
//:    此后主管类就能使用生成器对象完成后续所有的构造任务。但在客户端将生成器对象传递给主管类制造方法时还有另一种方式。
//:    在这种情况下，你在使用主管类生产产品时每次都可以使用不同的生成器。
//:
//: ## 生成器模式适合应用场景
//:
//: 1. 使用生成器模式可避免 “重叠构造函数（telescoping constructor）” 的出现。
//:    假设你的构造函数中有十个可选参数，那么调用该函数会非常不方便；因此，你需要重载这个构造函数，
//:    新建几个只有较少参数的简化版。但这些构造函数仍需调用主构造函数，传递一些默认数值来替代省略掉的参数。
//:
//: ```
//: class Pizza {
//:     Pizza(int size) { ... }
//:     Pizza(int size, boolean cheese) { ... }
//:     Pizza(int size, boolean cheese, boolean pepperoni) { ... }
//:     // ...
//: ```
//:
//: 生成器模式让你可以分步骤生成对象，而且允许你仅使用必须的步骤。应用该模式后，你再也不需要将几十个参数塞进构造函数里了。
//:
//: 2. 当你希望使用代码创建不同形式的产品（例如石头或木头房屋）时，可使用生成器模式。
//:    如果你需要创建的各种形式的产品， 它们的制造过程相似且仅有细节上的差异，此时可使用生成器模式。
//:
//: 基本生成器接口中定义了所有可能的制造步骤，具体生成器将实现这些步骤来制造特定形式的产品。同时，主管类将负责管理制造步骤的顺序。
//:
//: 3. 使用生成器构造组合树或其他复杂对象。
//:    生成器模式让你能分步骤构造产品。你可以延迟执行某些步骤而不会影响最终产品。你甚至可以递归调用这些步骤，这在创建对象树时非常方便。
//:
//: 生成器在执行制造步骤时，不能对外发布未完成的产品。这可以避免客户端代码获取到不完整结果对象的情况。
//:
//: ## 实现方法
//:
//: 1. 清晰地定义通用步骤，确保它们可以制造所有形式的产品。否则你将无法进一步实施该模式。
//: 2. 在基本生成器接口中声明这些步骤。
//: 3. 为每个形式的产品创建具体生成器类，并实现其构造步骤。
//:    不要忘记实现获取构造结果对象的方法。你不能在生成器接口中声明该方法，因为不同生成器构造的产品可能没有公共接口，
//:    因此你就不知道该方法返回的对象类型。 但是，如果所有产品都位于单一类层次中，你就可以安全地在基本接口中添加获取生成对象的方法。
//: 4. 考虑创建主管类。它可以使用同一生成器对象来封装多种构造产品的方式。
//: 5. 客户端代码会同时创建生成器和主管对象。构造开始前，客户端必须将生成器对象传递给主管对象。
//:    通常情况下，客户端只需调用主管类构造函数一次即可。主管类使用生成器对象完成后续所有制造任务。
//:    还有另一种方式，那就是客户端可以将生成器对象直接传递给主管类的制造方法。
//: 6. 只有在所有产品都遵循相同接口的情况下，构造结果可以直接通过主管类获取。否则，客户端应当通过生成器获取构造结果。
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
 
