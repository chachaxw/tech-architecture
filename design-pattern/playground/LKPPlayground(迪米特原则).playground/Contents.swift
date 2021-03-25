//: ###  什么是迪米特法则(Law of Demeter, LoD)？
//:
//: 迪米特法则（Law of Demeter，LoD）也称为最少知识原则（Least Knowledge Principle，LKP），一个对象应该对其他对象有最少的了解。
//: 通俗的讲，一个类应该对自己需要耦合或调用的类知道的最少。
//:
var str = "Hello, Law of Demeter(Least Knowledge Principle，迪米特原则)"

//: ### 迪米特法则的4层含义
//:
//: 1. 只和朋友交流
//:
//: 迪米特法则有一个英文解释是：Only talk to your immediate friends（只与直接的朋友通信）。什么叫做直接的朋友呢？每个对象都必然会与其他对象有耦合关系，
//: 两个对象之间耦合就成为朋友关系，这种关系的类型有很多，比如组合、聚合、依赖等。下面我们举个例子来说明如何才能做到只与直接的朋友类交流。
//:
//: 我们有这样一个场景，上体育课的时候，体育老师想让体育委员确认一下全班女生来齐没有，就对他说：“你去把全班女生清一下。"
//:
//: 我们先看看在这个场景下的UML类图：
//:
//: ![迪米特法则LKP](迪米特法则LKP_1.png)
//:
//: 下面我们用代码来描述上面的UML类图：
/// Teacher 类
class Teacher {
    public func command(leader: Leader) {
        var girls: [Girl] = []
        
        for i in 0...20 {
            girls.append(Girl(name: String(i)))
        }
        
        leader.countGirls(girls: girls)
    }
}

/// Leader 类
class Leader {
    public func countGirls(girls: [Girl]) {
        print("女生的数量 \(girls.count)")
    }
}

/// Girl 类
class Girl {
    private var name: String

    init(name: String) {
        self.name = name
    }
}

/// 运行示例
let teacher = Teacher()
teacher.command(leader: Leader())

//: 体育委员按照老师的要求对女生进行了清点，并得出了数量。我们思考一下上面的代码有没有什么问题。首先，我们确定一下`Teacher`有几个朋友类，
//: 从业务逻辑上来说，它应该只有一个朋友类，那就是`Leader`类。为什么Girl不是朋友类呢？我们先看看朋友类的定义：出现在成员变量、
//: 方法的输入输出参数中的类为成员朋友类，而出现在方法体内部的类不属于朋友类。而Girl这个类就是出现在commond方法体内，因此不属于Teacher类的朋友类。
//: 我们在`Teacher`类中的`command`方法内，定义了一个`girls`的数组变量，也就是与`Girl`类产生联系，这样就破坏了Teacher的健壮性。
//: 方法是类的一个行为，类竟然不知道自己的行为与其他类 产生依赖关系，这是不允许的，严重违反了迪米特法则。
//:
//: 假如我们修改一下上面的列子，会是什么样呢？我们还是先来看看修改之后的UML类图：
//:
//: ![迪米特法则LKP](迪米特法则LKP_2.png)
//:
//: 我们再来用代码来描述上面的UML类图：
//:
/// NewTeacher 类
class NewTeacher {
    public func command(leader: NewLeader) {
        leader.countGirls()
    }
}

/// NewLeader 类
class NewLeader {
    private var girls: [Girl]
    
    init(girls: [Girl]) {
        self.girls = girls
    }
    
    public func countGirls() {
        print("女生的数量 \(girls.count)")
    }
}

/// 运行示例
var girls: [Girl] = []

for i in 0...20 {
    girls.append(Girl(name: String(i)))
}

let teacher1 = NewTeacher()
teacher1.command(leader: NewLeader(girls: girls))

//: 上面代码，我们把`Teacher`中对`List<Girl>`的初始化移动到了`Teacher`类外面，同时 在`NewLeader`中增加了对Girl的注入，
//: 避开了`Teacher`类对陌生类`Girl`的访问，降低了系统间的耦合，提高了系统的健壮性。
//:
//: 2. 朋友间也是有距离的
//:
//: 一个类公开的pulbic属性或方法越多，修改时涉及的面也就越大，变更引起的风险扩散也就越大。因此，为了保持朋友类间的距离，
//：在设计时需要反复衡量:是否还可以再减少 public方法和属性，是否可以修改为private、package-private(包类型，在类、方法、
//：变量前 不加访问权限，则默认为包类型)、protected等访问权限，是否可以加上final关键字等。
//:
//: 3. 是自己的就是自己的
//:
//: 如果一个方法在本类中，既不增加类间关系，也对本类不产生负面影响，那就放置在本类。
//:
//: 4. 谨慎使用Serializable（[Java序列化](https://www.runoob.com/java/java-serialization.html)）

//: ### 总结
//:
//: 迪米特法则的核心观念就是类间解藕，若耦合，只有若耦合之后，类的复用率才能提高。在实际以臃肿，如果一个类跳转两次以上才能访问到另一个类，
//: 就需要想办法进行重构了，跳转次数越多，系统越复杂，维护就越困难，所以只要类跳转不超过两次都是可以接受的，这需要具体问题具体分析。
