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
