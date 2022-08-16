import UIKit

var greeting = "Hello, Iterator Pattern playground"

//:
//: # 迭代器模式(Iterator Pattern)
//:
//: 迭代器模式是一种行为设计模式，让你能在不暴露集合底层表现形式（列表、栈和树等）的情况下遍历集合中所有的元素。
//:
//: ![迭代器模式(Iterator Pattern)](iterator.png)
//:
//: ## 迭代器模式结构
//:
//: ![迭代器模式结构](structure.png)
//:
//: 1. 迭代器（Iter­a­tor）接口声明了遍历集合所需的操作：获取下一个元素、获取当前位置和重新开始迭代等。
//: 2. 具体迭代器（Con­crete Iter­a­tors）实现遍历集合的一种特定算法。迭代器对象必须跟踪自身遍历的进度。这使得多个迭代器可以相互独立地遍历同一集合。
//: 3. 集合（Col­lec­tion）接口声明一个或多个方法来获取与集合兼容的迭代器。请注意，返回方法的类型必须被声明为迭代器接口，因此具体集合可以返回各种不同种类的迭代器。
//: 4. 具体集合（Con­crete Col­lec­tions）会在客户端请求迭代器时返回一个特定的具体迭代器类实体。你可能会琢磨，
//:    剩下的集合代码在什么地方呢？不用担心，它也会在同一个类中。只是这些细节对于实际模式来说并不重要，所以我们将其省略了而已。
//: 5. 客户端（Client）通过集合和迭代器的接口与两者进行交互。这样一来客户端无需与具体类进行耦合，允许同一客户端代码使用各种不同的集合和迭代器。
//:    客户端通常不会自行创建迭代器，而是会从集合中获取。但在特定情况下，客户端可以直接创建一个迭代器（例如当客户端需要自定义特殊迭代器时）。
//:
//: ## 迭代器模式适合应用场景
//:
//: 1. 当集合背后为复杂的数据结构，且你希望对客户端隐藏其复杂性时（出于使用便利性或安全性的考虑），可以使用迭代器模式。
//:    迭代器封装了与复杂数据结构进行交互的细节，为客户端提供多个访问集合元素的简单方法。这种方式不仅对客户端来说非常方便，
//:    而且能避免客户端在直接与集合交互时执行错误或有害的操作，从而起到保护集合的作用
//: 2. 使用该模式可以减少程序中重复的遍历代码。
//:    重要迭代算法的代码往往体积非常庞大。当这些代码被放置在程序业务逻辑中时，它会让原始代码的职责模糊不清，
//:    降低其可维护性。因此，将遍历代码移到特定的迭代器中可使程序代码更加精炼和简洁。
//: 3. 如果你希望代码能够遍历不同的甚至是无法预知的数据结构，可以使用迭代器模式。
//:    该模式为集合和迭代器提供了一些通用接口。如果你在代码中使用了这些接口，那么将其他实现了这些接口的集合和迭代器传递给它时，它仍将可以正常运行。
//:
//: ## 实现方式
//:
//: 1. 声明迭代器接口。该接口必须提供至少一个方法来获取集合中的下个元素。但为了使用方便，
//:    你还可以添加一些其他方法，例如获取前一个元素、记录当前位置和判断迭代是否已结束。
//: 2. 声明集合接口并描述一个获取迭代器的方法。其返回值必须是迭代器接口。如果你计划拥有多组不同的迭代器，则可以声明多个类似的方法。
//: 3. 为希望使用迭代器进行遍历的集合实现具体迭代器类。迭代器对象必须与单个集合实体链接。链接关系通常通过迭代器的构造函数建立。
//: 4. 在你的集合类中实现集合接口。其主要思想是针对特定集合为客户端代码提供创建迭代器的快捷方式。集合对象必须将自身传递给迭代器的构造函数来创建两者之间的链接。
//: 5. 检查客户端代码，使用迭代器替代所有集合遍历代码。每当客户端需要遍历集合元素时都会获取一个新的迭代器。
//:
//: ## 迭代器模式优缺点
//:
//: ### 优点
//:
//: 1. 单一职责原则。通过将体积庞大的遍历算法代码抽取为独立的类，你可对客户端代码和集合进行整理。
//: 2. 开闭原则。你可实现新型的集合和迭代器并将其传递给现有代码，无需修改现有代码。
//: 3. 你可以并行遍历同一集合，因为每个迭代器对象都包含其自身的遍历状态。
//: 4. 相似的，你可以暂停遍历并在需要时继续。
//:
//: ### 缺点
//:
//: 1. 如果你的程序只与简单的集合进行交互，应用该模式可能会矫枉过正。
//: 2. 对于某些特殊集合，使用迭代器可能比直接遍历的效率低。
//:

import XCTest

/// This is a collection that we're going to iterate through using an iterator
/// derived from IteratorProtocol.
class WordsCollection {

    fileprivate lazy var items = [String]()

    func append(_ item: String) {
        self.items.append(item)
    }
}

extension WordsCollection: Sequence {

    func makeIterator() -> WordsIterator {
        return WordsIterator(self)
    }
}

/// Concrete Iterators implement various traversal algorithms. These classes
/// store the current traversal position at all times.
class WordsIterator: IteratorProtocol {

    private let collection: WordsCollection
    private var index = 0

    init(_ collection: WordsCollection) {
        self.collection = collection
    }

    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}


/// This is another collection that we'll provide AnyIterator for traversing its
/// items.
class NumbersCollection {

    fileprivate lazy var items = [Int]()

    func append(_ item: Int) {
        self.items.append(item)
    }
}

extension NumbersCollection: Sequence {

    func makeIterator() -> AnyIterator<Int> {
        var index = self.items.count - 1

        return AnyIterator {
            defer { index -= 1 }
            return index >= 0 ? self.items[index] : nil
        }
    }
}

/// Client does not know the internal representation of a given sequence.
class Client {
    // ...
    static func clientCode<S: Sequence>(sequence: S) {
        for item in sequence {
            print(item)
        }
    }
    // ...
}

/// Let's see how it all works together.
class IteratorConceptual: XCTestCase {

    func testIteratorProtocol() {

        let words = WordsCollection()
        words.append("First")
        words.append("Second")
        words.append("Third")

        print("Straight traversal using IteratorProtocol:")
        Client.clientCode(sequence: words)
    }

    func testAnyIterator() {

        let numbers = NumbersCollection()
        numbers.append(1)
        numbers.append(2)
        numbers.append(3)

        print("\nReverse traversal using AnyIterator:")
        Client.clientCode(sequence: numbers)
    }
}

let iterator = IteratorConceptual()

iterator.testIteratorProtocol()

iterator.testAnyIterator()

// Output
//
// Straight traversal using IteratorProtocol:
// First
// Second
// Third
//
// Reverse traversal using AnyIterator:
// 3
// 2
// 1
//
