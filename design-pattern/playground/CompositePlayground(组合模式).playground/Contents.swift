import UIKit

var greeting = "Hello, Composite Pattern playground"

//: ## 组合模式
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
