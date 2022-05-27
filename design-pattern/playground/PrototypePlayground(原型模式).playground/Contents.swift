
//:
//: ### 原型模式
//:
//: 原型模式是一种创建型设计模式， 使你能够复制已有对象， 而又无需使代码依赖它们所属的类。
//:
//: ### 原型模式结构
//:
//: 基本实现
//: ![基本实现](structure.png)
//:
//: 1. 原型（Prototype）接口将对克隆方法进行声明。在绝大多数情况下，其中只会有一个名为 `clone` 克隆的方法。
//: 2. 具体原型（Concrete Prototype）类将实现克隆方法。除了将原始对象的数据复制到克隆体中之外，该方法有时还需处理克隆过程中的极端情况，例如克隆关联对象和梳理递归依赖等等。
//: 3. 客户端 （Client） 可以复制实现了原型接口的任何对象。
//:
//: 原型注册表实现
//: ![原型注册表实现](structure-prototype-cache.png)
//:
//: 原型注册表 （Prototype Registry）提供了一种访问常用原型的简单方法，其中存储了一系列可供随时复制的预生成对象。
//: 最简单的注册表原型是一个 名称 → 原型的哈希表。但如果需要使用名称以外的条件进行搜索，你可以创建更加完善的注册表版本。
//:
//: ### 原型模式优缺点
//:
//: 优点：
//: 1. 你可以克隆对象， 而无需与它们所属的具体类相耦合。
//: 2. 你可以克隆预生成原型， 避免反复运行初始化代码。
//: 3. 你可以更方便地生成复杂对象。
//: 4. 你可以用继承以外的方式来处理复杂对象的不同配置。
//:
//: 缺点：
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
