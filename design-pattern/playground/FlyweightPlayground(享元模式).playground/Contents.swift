import UIKit

var greeting = "Hello, Flyweight Pattern playground"

//:
//: ## 享元模式
//:
//: 是一种结构型设计模式， 它摒弃了在每个对象中保存所有数据的方式， 通过共享多个对象所共有的相同状态， 让你能在有限的内存容量中载入更多对象。
//:
//: ## 享元模式结构
//:
//: ![享元模式结构](structure.png)
//:
//: 1. 享元模式只是一种优化。在应用该模式之前，你要确定程序中存在与大量类似对象同时占用内存相关的内存消耗问题，并且确保该问题无法使用其他更好的方式来解决。
//: 2. 享元（Flyweight）类包含原始对象中部分能在多个对象中共享的状态。同一享元对象可在许多不同情景中使用。
//:    享元中存储的状态被称为 “内在状态”。传递给享元方法的状态被称为 “外在状态”。
//: 3. 情景（Context）类包含原始对象中各不相同的外在状态。情景与享元对象组合在一起就能表示原始对象的全部状态。
//: 4. 通常情况下，原始对象的行为会保留在享元类中。因此调用享元方法必须提供部分外在状态作为参数。但你也可将行为移动到情景类中，然后将连入的享元作为单纯的数据对象。
//: 5. 客户端（Client）负责计算或存储享元的外在状态。在客户端看来，享元是一种可在运行时进行配置的模板对象，具体的配置方式为向其方法中传入一些情景数据参数。
//: 6. 享元工厂（Flyweight Factory）会对已有享元的缓存池进行管理。有了工厂后，客户端就无需直接创建享元，它们只需调用工厂并向其传递目标享元的一些内在状态即可。
//:    工厂会根据参数在之前已创建的享元中进行查找，如果找到满足条件的享元就将其返回；如果没有找到就根据参数新建享元。
//:
//: ## 享元模式优缺点
//:
//: ### 优点
//: 如果程序中有很多相似对象， 那么你将可以节省大量内存。
//:
//: ### 缺点
//: 1. 你可能需要牺牲执行速度来换取内存，因为他人每次调用享元方法时都需要重新计算部分情景数据。
//: 2. 代码会变得更加复杂。团队中的新成员总是会问：“为什么要像这样拆分一个实体的状态？”。
//:

/// Flyweight Example

import XCTest

/// The Flyweight stores a common portion of the state (also called intrinsic state （内部状态）) that belongs to
/// multiple real business entities. The Flyweight accepts the rest of the state (extrinsic state（外部状态）, unique for each entity)
/// via its method parameters.
class Flyweight {
    
    private let sharedState: [String]
    
    init(sharedState: [String]) {
        self.sharedState = sharedState
    }
    
    func operation(uniqueState: [String]) {
        print("Flyweight: Displaying shared(\(sharedState)) and unique(\(uniqueState))")
    }
}

/// The Flyweight Factory creates and manages the Flyweight objects. It ensures that flyweights are shared correctly.
/// When the client requests a flyweight, the factory either returns an existing instance or creates a new one, if it doesn't exist yet.
class FlyweightFactory {
    
    private var flyweights: [String: Flyweight]
    
    init(states: [[String]]) {
        var flyweights = [String: Flyweight]()
        
        for state in states {
            flyweights[state.key] = Flyweight(sharedState: state)
        }
        
        self.flyweights = flyweights
    }
    
    /// Returns an existing Flyweight with a given state or creates a new one.
    func flyweight(for state: [String]) -> Flyweight {
        
        let key = state.key
        
        guard let foundFlyweight = flyweights[key] else {
            print("FlyweightFactory: Can't find a flyweight, creating new one.\n")
            
            let flyweight = Flyweight(sharedState: state)
            flyweights.updateValue(flyweight, forKey: key)
            
            return flyweight
        }
        
        print("FlyweightFactory: Reusing existing flyweight.\n")
        return foundFlyweight
    }
    
    func printFlyweights() {
        print("FlyweightFactory: I have \(flyweights.count) flyweights:\n")
        for item in flyweights {
            print(item.key)
        }
    }
}

// MARK: Array's extension, add a key to array
extension Array where Element == String {
    
    /// Returns a Flyweight's string hash for a given state.
    var key: String {
        return self.joined()
    }
}

class FlyweightConceptual: XCTestCase {

    func testFlyweight() {

        /// The client code usually creates a bunch of pre-populated flyweights
        /// in the initialization stage of the application.
        
        let states: [[String]] =  [
            ["Chevrolet", "Camaro2018", "pink"],
            ["Mercedes Benz", "C300", "black"],
            ["Mercedes Benz", "C500", "red"],
            ["BMW", "M5", "red"],
            ["BMW", "X6", "white"]
        ]
        let factory = FlyweightFactory(states: states)

        factory.printFlyweights()

        /// ...

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "M5",
                "red")

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "X1",
                "red")

        factory.printFlyweights()
    }

    func addCarToPoliceDatabase(
            _ factory: FlyweightFactory,
            _ plates: String,
            _ owner: String,
            _ brand: String,
            _ model: String,
            _ color: String) {

        print("Client: Adding a car to database.\n")

        let flyweight = factory.flyweight(for: [brand, model, color])

        /// The client code either stores or calculates extrinsic state and
        /// passes it to the flyweight's methods.
        flyweight.operation(uniqueState: [plates, owner])
    }
}

let flyweight = FlyweightConceptual()

flyweight.testFlyweight()

// FlyweightFactory: I have 5 flyweights:
//
// ChevroletCamaro2018pink
// BMWX6white
// BMWM5red
// Mercedes BenzC500red
// Mercedes BenzC300black
// Client: Adding a car to database.
//
// FlyweightFactory: Reusing existing flyweight.
//
// Flyweight: Displaying shared(["BMW", "M5", "red"]) and unique(["CL234IR", "James Doe"])
// Client: Adding a car to database.
//
// FlyweightFactory: Can't find a flyweight, creating new one.
//
// Flyweight: Displaying shared(["BMW", "X1", "red"]) and unique(["CL234IR", "James Doe"])
// FlyweightFactory: I have 6 flyweights:
//
// BMWX1red
// ChevroletCamaro2018pink
// BMWX6white
// BMWM5red
// Mercedes BenzC500red
// Mercedes BenzC300black
