import UIKit

var greeting = "Hello, Composite Pattern playground"

//: ## 组合模式
//:
//: ![组合模式](composite.png)
//:
//: 组合模式是一种结构型设计模式，你可以使用它将对象组合成树状结构，并且能像使用独立对象一样使用它们。
//:
//: ## 组合模式的结构
//:
//: ![组合模式的结构](structure.png)
//:
//: 1. 组件（Component）接口描述了树中简单项目和复杂项目所共有的操作。
//: 2. 叶节点（Leaf） 是树的基本结构， 它不包含子项目。一般情况下，叶节点最终会完成大部分的实际工作，因为它们无法将工作指派给其他部分。
//: 3. 容器（Container）——又名 “组合（Composite）”——是包含叶节点或其他容器等子项目的单位。容器不知道其子项目所属的具体类，
//:    它只通过通用的组件接口与其子项目交互。容器接收到请求后会将工作分配给自己的子项目，处理中间结果，然后将最终结果返回给客户端。
//: 4. 客户端 （Client） 通过组件接口与所有项目交互。 因此， 客户端能以相同方式与树状结构中的简单或复杂项目交互。
//:
//: ## 组合模式适合应用场景
//:
//: 1. 如果你需要实现树状对象结构，可以使用组合模式。组合模式为你提供了两种共享公共接口的基本元素类型：
//:    简单叶节点和复杂容器。容器中可以包含叶节点和其他容器。这使得你可以构建树状嵌套递归对象结构。
//: 2. 如果你希望客户端代码以相同方式处理简单和复杂元素，可以使用该模式。
//:    组合模式中定义的所有元素共用同一个接口。在这一接口的帮助下，客户端不必在意其所使用的对象的具体类。
//:
//: ## 实现方式
//:
//: 1. 确保应用的核心模型能够以树状结构表示。尝试将其分解为简单元素和容器。记住，容器必须能够同时包含简单元素和其他容器。
//: 2. 声明组件接口及其一系列方法，这些方法对简单和复杂元素都有意义。
//: 3. 创建一个叶节点类表示简单元素。程序中可以有多个不同的叶节点类。
//: 4. 创建一个容器类表示复杂元素。在该类中，创建一个数组成员变量来存储对于其子元素的引用。
//:    实现组件接口方法时，记住容器应该将大部分工作交给其子元素来完成。该数组必须能够同时保存叶节点和容器，因此请确保将其声明为组合接口类型。
//: 5. 最后，在容器中定义添加和删除子元素的方法。记住，这些操作可在组件接口中声明。
//:    这将会违反接口隔离原则，因为叶节点类中的这些方法为空。但是，这可以让客户端无差别地访问所有元素，即使是组成树状结构的元素。
//:
//: ## 组合模式优缺点
//:
//: ### 优点
//: 1. 你可以利用多态和递归机制更方便地使用复杂树结构。
//: 2. 开闭原则。无需更改现有代码，你就可以在应用中添加新元素，使其成为对象树的一部分。
//:
//: ### 缺点
//: 1. 对于功能差异较大的类，提供公共接口或许会有困难。在特定情况下，你需要过度一般化组件接口，使其变得令人难以理解。
//:
//:

import XCTest

/// The base Component class declares common operations for both simple and
/// complex objects of a composition.
protocol Component {
    
    /// The base Component may optionally declare methods for setting and
    /// accessing a parent of the component in a tree structure. It can also
    /// provide some default implementation for these methods.
    var parent: Component? { get set }
    
    /// In some cases, it would be beneficial to define the child-management
    /// operations right in the base Component class. This way, you won't need
    /// to expose any concrete component classes to the client code, even during
    /// the object tree assembly. The downside is that these methods will be
    /// empty for the leaf-level components.
    func add(component: Component)
    
    func remove(component: Component)
    
    /// You can provide a method that lets the client code figure out whether a
    /// component can bear children.
    func isComposite() -> Bool
    
    /// The base Component may implement some default behavior or leave it to
    /// concrete classes.
    func operation() -> String
}

extension Component {
    
    func add(component: Component) {}
    
    func remove(component: Component) {}
    
    func isComposite() -> Bool {
        return false
    }
}

/// The Leaf class represents the end objects of a composition. A leaf can't
/// have any children.
///
/// Usually, it's the Leaf objects that do the actual work, whereas Composite
/// objects only delegate to their sub-components.
class Leaf: Component {
    
    var parent: Component?
    
    func operation() -> String {
        return "Leaf"
    }
}

/// The Composite class represents the complex components that may have
/// children. Usually, the Composite objects delegate the actual work to their
/// children and then "sum-up" the result.
class Composite: Component {
    
    var parent: Component?
    
    private var children = [Component]()
    
    func add(component: Component) {
        var item = component
        item.parent = self
        children.append(item)
    }
    
    func remove(component: Component) {
        // ...
    }

    func isComposite() -> Bool {
        return true
    }
    
    /// The Composite executes its primary logic in a particular way. It
    /// traverses recursively through all its children, collecting and summing
    /// their results. Since the composite's children pass these calls to their
    /// children and so forth, the whole object tree is traversed as a result.
    func operation() -> String {
        let result = children.map({ $0.operation() })
        return "Branch(" + result.joined(separator: " ") + ")"
    }
}

class Client {

    /// The client code works with all of the components via the base interface.
    static func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }

    /// Thanks to the fact that the child-management operations are also
    /// declared in the base Component class, the client code can work with both
    /// simple or complex components.
    static func moreComplexClientCode(leftComponent: Component, rightComponent: Component) {
        if leftComponent.isComposite() {
            leftComponent.add(component: rightComponent)
        }
        print("Result: " + leftComponent.operation())
    }
}

/// Let's see how it all comes together.
class CompositeConceptual: XCTestCase {
    
    func testCompositeConceptual() {
        
        /// This way the client code can support the simple leaf components...
        print("Client: I've got a simple component:")
        Client.someClientCode(component: Leaf())
        
        /// ...as well as the complex composites.
        let tree = Composite()
        
        let branch1 = Composite()
        
        branch1.add(component: Leaf())
        branch1.add(component: Leaf())
        
        let branch2 = Composite()
        
        branch2.add(component: Leaf())
        branch2.add(component: Leaf())
        
        tree.add(component: branch1)
        tree.add(component: branch2)
        
        print("\nClient: Now I've got a composite tree:")
        Client.someClientCode(component: tree)

        print("\nClient: I don't need to check the components classes even when managing the tree:")
        Client.moreComplexClientCode(leftComponent: tree, rightComponent: Leaf())
    }
}

let composite = CompositeConceptual()

composite.testCompositeConceptual()

// Output Result
// Client: I've got a simple component:
// Result: Leaf
//
// Client: Now I've got a composite tree:
// Result: Branch(Branch(Leaf Leaf) Branch(Leaf Leaf))
//
// Client: I don't need to check the components classes even when managing the tree:
// Result: Branch(Branch(Leaf Leaf) Branch(Leaf Leaf) Leaf)
