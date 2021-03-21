//: ### 什么是开闭原则(Open Close Principle)?
//:
//: 定义：一个软件实体如类、模块和函数应该对扩展开放，对修改关闭。
//:
//: Software entities like classes, modules and functions should be open for extension but closed for modifications.
//:
//: 一个软件产品只要在生命周期内，都会发生变化，我们应该在设计时尽量适应这些变化，以提高项目的稳定性和灵活性，真正实现“拥抱变化”。
//: 开闭原则告诉我们应尽量通过扩展软件实体的行为来实现变化，而不是通过修改已有的代码来完成变化，它是为软件实体的未来事件而制定的
//: 对现有开发设计进行约束的一个原则。
//:

var str = "Hello, Open Close Principle playground"

//: 我们举例说明什么是开闭原则，以书店销售书籍为例，先来看看类图：
//:
//: ![开闭原则](开闭原则(OCP)_1.png)
//:
/// 根据上面的UML类图，我们首先声明一个协议`PBook`（Java中为interface）
protocol PBook {
    func getName() -> String
    
    func getAuthor() -> String
    
    func getPrice() -> Int
}

/// 再来看看小说`NovelBook`类的实现
class NovelBook: PBook {
    private var name: String
    
    private var price: Int
    
    private var author: String
    
    init(name: String, price: Int, author: String) {
        self.name = name
        self.price = price
        self.author = author
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getPrice() -> Int {
        return self.price
    }
    
    func getAuthor() -> String {
        return self.author
    }
}

/// 再来看看我们的`BookStore`类，`BookStore`类中肯定需要维护一个`bookList`，来表示书店中所销售的书籍列表，代码如下
class BookStore {
    private var bookList: [PBook] = []
    
    init() {
        bookList.append(NovelBook(name: "巴黎圣母院", price: 199, author: "雨果"))
        bookList.append(NovelBook(name: "悲惨世界", price: 39, author: "雨果"))
        bookList.append(NovelBook(name: "哈姆雷特", price: 189, author: "莎士比亚"))
        bookList.append(NovelBook(name: "奥赛罗", price: 29, author: "莎士比亚"))
        print("book list is \(String(describing: bookList))")
    }
}

let store = BookStore()

//:
//: 上面代码是一个正常的书店模型，假设现在我们需要让所有40元以上的书籍9折销售，其他的8折销售，我们应该如何应对这样一个需求变化？
//: 一般有如下三种方法可以解决这个问题：
//:
//: 1. 修改接口
//:
//: 在协议`PBook`中新增一个方法`getOffPrice()`，专门用来进行打折处理，所有的实现类实现该方法。但是这样修改的后果就是，实现类
//: `NovelBook`就需要修改，同时`PBook`作为协议应该是稳定可靠的，不应该经常改变，否则协议作为契约的作用就失去了效能，所以该方案不可靠。
//:
//: 2. 修改实现类
//:
//: 第二种方式是直接修改`NovelBook`类中的方法，直接在`getPrice()`中实现打折业务逻辑。的确是个方法，相信我们的项目中有很多类似的操作，
//: 直接修改原有的业务逻辑来适应需求的变化。但是这种方式有个严重的问题，就是修改了`getPrice()`方法后，假设我们的工作人员想要看书籍原来的价格，
//: 这样一些原有的需求就会受到影响，显然这种方法并不是一个合适的方法。
//:
//: 3. 通过扩展实现
//:
//: 我们可以新增一个`OffNovelBook`类来代表所有需要打折的书籍，然后覆写`getPrice()`, 高层次的模块通过`OffNovelBook`类产生新的对象
//: 完成业务变化对系统的最小化开发。此时我们只需要修改`BookStore`中的bookList实现类就可以了。代码如下：
//:
/// OffNovelBook类
class OffNovelBook: NovelBook {
    override func getPrice() -> Int {
        let price = super.getPrice()

        if price > 40 {
            return price * 90 / 100
        } else {
            return price * 80 / 100
        }
    }
}

//: 这样，我们只需要在`BookStore`类初始化的时候，将`NovelBook`类替换成`OffNovelBook`就可以实现需求。
//:
//: > 开闭原则对扩展开放，对修改关闭，并不意味着不做任何修改，低层模块的变更，必然要有高层模块进行耦合，否则就是一个孤立无意义的代码片段。
//:
//: ### 为什么要采用开闭原则？
//:
//: 1. 开闭原则对测试有很大的影响
//:
//: 2. 开闭原则可以用提高复用性
//:
//: 在面向对象的设计中，所有的逻辑都是从原子逻辑组合而来的，而不是在一个类中独立 实现一个业务逻辑。只有这样代码才可以复用，粒度越小，被复用的可能性就越大。
//:
//: 3. 开闭原则可以提高维护性
//:
//: 4. 面向对象开发的基本要求
//:
//: ### 如何使用开闭原则？
//:
//: 1. 抽象约束
//:
//: 通过接口（协议）或抽象类可以约束一组可能变化的行为，并且能够实现对扩展开放，其包含三层含义：
//: 第一，通过接口（协议）或者抽象类约束扩展，对扩展进行边界限定，不允许出现在接口（协议）或抽象类中不存在的`public`方法；
//: 第二，参数类型、引用对象尽量使用接口（协议）或者抽象类，而不是实现类；
//: 第三，抽象层尽量保持稳定，一旦确定就不允许修改。
//: 要实现对扩展开放，首要的前提条件就是抽象约束。
//:
//: 2. 元数据(metadata)控制模块行为
//:
//: 3. 制定项目章程
//:
//: 4. 封装变化
//:
//: 对变化的封装包含两层含义：
//: 第一，将相同的变化封装到一个接口或抽象类中;
//: 第二，将不同的变化封装到不同的接口或抽象类中，不应该有两个不同的变化出现在同一个接口或 抽象类中
//:
//: ### 总结
//:
//: 开闭原则是一个终极目标，任何人包括大师级人物都无法百分之百做到，但朝这个方向 努力，可以非常显著地改善一个系统的架构，真正做到“拥抱变化”。
