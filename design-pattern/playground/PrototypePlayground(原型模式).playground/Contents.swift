
//:
//: ## 原型模式
//:
//: 原型模式是一种创建型设计模式， 使你能够复制已有对象， 而又无需使代码依赖它们所属的类。
//:
//: ![原型模式](prototype.png)
//:
//: ## 原型模式结构
//:
//: ### 基本实现
//: ![基本实现](structure.png)
//:
//: 1. 原型（Prototype）接口将对克隆方法进行声明。在绝大多数情况下，其中只会有一个名为 `clone` 克隆的方法。
//: 2. 具体原型（Concrete Prototype）类将实现克隆方法。除了将原始对象的数据复制到克隆体中之外，该方法有时还需处理克隆过程中的极端情况，例如克隆关联对象和梳理递归依赖等等。
//: 3. 客户端 （Client） 可以复制实现了原型接口的任何对象。
//:
//: ### 原型注册表实现
//: ![原型注册表实现](structure-prototype-cache.png)
//:
//: 原型注册表 （Prototype Registry）提供了一种访问常用原型的简单方法，其中存储了一系列可供随时复制的预生成对象。
//: 最简单的注册表原型是一个 名称 → 原型的哈希表。但如果需要使用名称以外的条件进行搜索，你可以创建更加完善的注册表版本。
//:
//: ## 原型模式适合应用场景
//:
//: 1. 如果你需要复制一些对象，同时又希望代码独立于这些对象所属的具体类，可以使用原型模式。
//:    这一点考量通常出现在代码需要处理第三方代码通过接口传递过来的对象时。即使不考虑代码耦合的情况，
//:    你的代码也不能依赖这些对象所属的具体类，因为你不知道它们的具体信息。原型模式为客户端代码提供一个通用接口，
//:    客户端代码可通过这一接口与所有实现了克隆的对象进行交互，它也使得客户端代码与其所克隆的对象具体类独立开来。
//:
//: 2. 如果子类的区别仅在于其对象的初始化方式，那么你可以使用该模式来减少子类的数量。别人创建这些子类的目的可能是为了创建特定类型的对象。
//:    在原型模式中，你可以使用一系列预生成的、各种类型的对象作为原型。客户端不必根据需求对子类进行实例化，只需找到合适的原型并对其进行克隆即可。
//:
//: ## 实现方式
//:
//: 1. 创建原型接口，并在其中声明克隆方法。如果你已有类层次结构，则只需在其所有类中添加该方法即可。
//: 2. 原型类必须另行定义一个以该类对象为参数的构造函数。构造函数必须复制参数对象中的所有成员变量值到新建实体中。
//:    如果你需要修改子类，则必须调用父类构造函数，让父类复制其私有成员变量值。
//:    如果编程语言不支持方法重载，那么你可能需要定义一个特殊方法来复制对象数据。
//:    在构造函数中进行此类处理比较方便，因为它在调用 new 运算符后会马上返回结果对象。
//: 3. 克隆方法通常只有一行代码：使用 new 运算符调用原型版本的构造函数。注意，
//:    每个类都必须显式重写克隆方法并使用自身类名调用 new 运算符。否则，克隆方法可能会生成父类的对象。
//: 4. 还可以创建一个中心化原型注册表，用于存储常用原型。可以新建一个工厂类来实现注册表，
//:    或者在原型基类中添加一个获取原型的静态方法。该方法必须能够根据客户端代码设定的条件进行搜索。
//:    搜索条件可以是简单的字符串，或者是一组复杂的搜索参数。找到合适的原型后，注册表应对原型进行克隆，
//:    并将复制生成的对象返回给客户端。最后还要将对子类构造函数的直接调用替换为对原型注册表工厂方法的调用。
//:
//: ## 原型模式优缺点
//:
//: ### 优点：
//: 1. 你可以克隆对象， 而无需与它们所属的具体类相耦合。
//: 2. 你可以克隆预生成原型， 避免反复运行初始化代码。
//: 3. 你可以更方便地生成复杂对象。
//: 4. 你可以用继承以外的方式来处理复杂对象的不同配置。
//:
//: ### 缺点：
//: 1. 克隆包含循环引用的复杂对象可能会非常麻烦。
//:

import XCTest

/// Swift has built-in cloning support. To add cloning support to your class,
/// you need to implement the NSCopying protocol in that class and provide the
/// implementation for the `copy` method.
class BaseClass: NSCopying, Equatable {

    private var intValue = 1
    private var stringValue = "Value"
    
    required init(intValue: Int = 1, stringValue: String = "Value") {
        self.intValue = intValue
        self.stringValue = stringValue
    }
    
    /// MARK: - Equatable
    static func == (lhs: BaseClass, rhs: BaseClass) -> Bool {
        return lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue
    }

    /// MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        let prototype = type(of: self).init()
        
        prototype.intValue = intValue
        prototype.stringValue = stringValue
        
        print("Values defined in BaseClass have been cloned!")
        
        return prototype
    }
}

/// Subclasses can override the base `copy` method to copy their own data into
/// the resulting object. But you should always call the base method first.
class SubClass: BaseClass {
    
    private var boolValue = true
    
    func copy() -> Any {
        return copy(with: nil)
    }
    
    override func copy(with zone: NSZone?) -> Any {
        guard let prototype = super.copy(with: zone) as? SubClass else {
            return SubClass() // oops
        }
        
        prototype.boolValue = boolValue
        
        print("Values defined in SubClass have been cloned!")

        return prototype
    }
}

/// The client code.
class Client {
    // ...
    static func someClientCode() {
        let original = SubClass(intValue: 2, stringValue: "Value2")

        guard let copy = original.copy() as? SubClass else {
            XCTAssert(false)
            return
        }

        /// See implementation of `Equatable` protocol for more details.
        XCTAssert(copy == original)

        print("The original object is equal to the copied object!")
    }
    // ...
}

/// Let's see how it all works together.
class PrototypeConceptual: XCTestCase {

    func testPrototype_NSCopying() {
        Client.someClientCode()
    }
}

let prototype = PrototypeConceptual()

prototype.testPrototype_NSCopying()

// 输出结果：
// Values defined in BaseClass have been cloned!
// Values defined in SubClass have been cloned!
// The original object is equal to the copied object!
