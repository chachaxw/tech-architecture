//: ### 什么是里氏替换原则(Liskov Substitution Principle)？
//:
//: 里氏替换原则有两种定义：
//: 
//: 第一种定义：如果对每一个类型为S的对象O1，都有类型为T的对象O2，使得以T定义的所有程序P
//: 在所有的对象O1都代换成O2时，程序P的行为没有发生变化，那么类型S是类型T的子类型，
//:
//: ![里氏替换原则定义](里氏替换原则定义.png)
//:
//: If for each object O1 of type S there is an object O2 of type T such that for all programs P defined in terms of T,
//: the behavior of P is unchanged when O1 is substituted for O2 then S is subtype of T.
//:
//: 第二种定义：所有引用基类的地方必须能透明地使用其子类的对象
//: Function that use pointers or references to base classes must be able to use objects of derived classes without knowing it.
//:

var str = "Hello, Liskov Substitution Principle(里氏替换原则)，简称LSP"

print("\(str)")

//: 里氏替换原则为良好的继承定义了一个规范，一句简单的定义包含了4层含义:
//:
//: 1. 子类必须完全实现父类的方法
//: 例如下图：
//:
//: ![里氏替换原则(LSP)](里氏替换原则(LSP).png)

//: 我们都会打吃鸡游戏，里面有各种各样的枪支，我们用上图来描述一下里面用到的各种枪支。枪的主要职责是射击，
//: 所以我们定义了一个基本枪支类Gun，在士兵类中定义了一个killEnemy方法，使用枪来杀敌人，具体用什么枪来杀敌人，要调用
//: setGun才知道，我们首先来看看类Gun。
//: 我们首先定义一个PGun协议，遵循这个协议的所有类都需要实现shoot方法，
//: [面向协议编程](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)是swift的一个优秀特性，作用类似于Java里面的Interface

/// 枪支协议
protocol PGun {
    func shoot() -> Void
}

/// 枪支类Gun
class Gun: PGun {
    /// 枪的主要作用就是射击
    func shoot() -> Void {
        print("父类枪支设计")
    }
}
//: 定义完基本的枪支父类之后，我们来看看手枪、步枪、机枪的协议实现

/// 手枪
class HandGun: Gun {
    override func shoot() {
        print("手枪射击")
    }
}

/// 步枪
class Rifle: Gun {
    override func shoot() {
        print("步枪射击")
    }
}

/// 机枪
class MachineGun: Gun {
    override func shoot() {
        print("机枪射击")
    }
}

//: 上述代码的HandGun、Rifle、MachineGun都实现了继承了父类Gun的 shoot方法，且均对父类方法进行了覆盖重写
//:
//: 有了枪支之后，我们还要有使用这些枪支的士兵，所以，我们再来定义一个士兵类，代码如下：

/// 士兵类
class Soldier {
    private var gun: Gun?

    public func setGun(gun: Gun) {
        self.gun = gun
    }
    
    public func killEnemy() {
        print("\(String(describing: gun)) 射击")
        gun?.shoot()
    }
}

let soldier = Soldier()
let soldier1 = Soldier()

soldier1.setGun(gun: Rifle())

let soldier2 = Soldier()

soldier2.setGun(gun: MachineGun())

soldier.killEnemy()
soldier1.killEnemy()
soldier2.killEnemy()

//: 我们完成了Soldier和Gun类的基本定义，现在来看看当士兵要拿枪杀敌的时候，士兵想要用什么枪，
//: 直接调用`setGun`方法，就可以完成相应操作。
//:
//: > 在类中调用其他类时务必要使用父类或接口，如果不能使用父类或接口，则说明类的设计已经违背了LSP原则。
//: 我们再来想一想，假如我们有一个玩具枪，该如何定义呢？相信我们都知道可以直接添加一个类似的ToyGun类，继承父类就可以了。
//: 我们可以画出如下类图:
//:
//: ![里氏替换原则(LSP)1](里氏替换原则(LSP)_1.png)
/// 玩具枪(ToyGun)的实现
class ToyGun: Gun {
    //玩具枪是不能射击的，但是编译器又要求实现这个方法，可以重写shoot方法!
    override func shoot() {
        // 玩具枪不能射击，这个方法就不实现了
    }
}

//: 此时我们的场景就变成了，士兵用玩具枪射击，代码如下:
let soldier3 = Soldier()

soldier3.setGun(gun: ToyGun())
soldier3.killEnemy()

//: 但是，我们发现一个问题，ToyGun是不能射出子弹的，但是玩家用玩具枪去射击的话，就会出现问题。虽然我们可以在Soldier类中添加判断，
//: 但是在程序中，每增加一个类，所有与这个父类有关系的类都必须修改，是不合理的。正确的做法是重新声明一个ToyGun的父类ToyGunParent。
//: 我们可以画出如下类图:
//:
//: ![里氏替换原则(LSP)2](里氏替换原则(LSP)_2.png)
//: > 如果子类不能完整的实现父类的方法，或者父类的某些方法在子类中已经发生了“畸变”，则建议断开父子继承关系，采用依赖、聚集、组合等关系代替继承。

//: 2. 子类可以有自己的个性
//:
//: 例如下图：
//:
//: ![里氏替换原则(LSP)3](里氏替换原则(LSP)_3.png)
//:
//: 子类可以有自己的行为和外观，也就是方法和属性。比如步枪，我们有AK47，AUG狙击步枪等。我们以AUG狙击枪为例，来看看如何实现。
class AUG: Rifle {
    func zoomOut() {
        print("通过望远镜察看敌人...")
    }
    
    override func shoot() {
        print("通过AUG狙击枪射击...")
    }
}

//: 有了狙击枪，我们再来看看狙击手类：
class Snipper {
    private var aug: AUG?

    public func setGun(aug: AUG) {
        self.aug = aug
        print("设置狙击枪...")
    }

    public func killEnemy() {
        aug?.zoomOut()
        aug?.shoot()
    }
}

//: 狙击手使用狙击枪来杀死敌人。
let snipper = Snipper()

snipper.setGun(aug: AUG())
snipper.killEnemy()

//: 3. 覆盖或实现父类的方法时输入参数可以被放大
//:
//: 方法中的输入参数称为前置条件，这是什么意思呢? 里氏替换原则要求制定一个契约，就是父类或接口(Swift中是协议)。
//: 契约制定了，也就同时制定了前置条件和后置条件，前置条件就是你要让我执行，就必须满足我的条件；后置条件就是我
//: 执行完了需要反馈，标准是什么。这里有点难以理解，我们来看一个例子，我们先定义一个父类`Father`
/// 父类的前置条件较大
class Father {
    public func doSomething(dic: Dictionary<String, Int>) -> Dictionary<String, Int>.Values {
        print("父类执行。。。\(dic.values)")
        return dic.values
    }
}

//: 再定义一个子类`Son`
class Son: Father {
    /// 函数重载，子类拥有父类的所有属性和方法，方法名相同，输入参数类型又不相同
    public func doSomething(dic: Dictionary<String, Any>) -> Dictionary<String, Any>.Values {
        print("子类执行。。。\(dic.values)")
        return dic.values
    }
}

//: 我们来看看上面这个两个类代码是如何执行的。
let f = Father()
f.doSomething(dic: ["a": 1, "b": 2])

//: 根据里氏替换原则，父类出现的地方子类就可以出现，我们把上面的代码修改为子类，看如下代码：
let s = Son()
s.doSomething(dic: ["a": 1, "b": 2])

//: 运行结果如下:
/// 父类执行。。。[1, 2]
/// 父类执行。。。[1, 2]
//: 运行结果还是一样，看明白是怎么回事了吗? 父类方法的输入参数是`Dictionary<String, Int>`类型，
//: 子类的输入参数是`Dictionary<String, Any>`类型，也就是说子类的输入参数类型的范围扩大了，子类代替父类传递到调用者中，
//: 子类的方法永远都不会被执行。上述例子显然是正确的，如果你想让子类的方法运行，就必须覆写父类的方法。
//: 大家可以这么理解，在上面的代码例子中，调用了父类的一个方法，子类可以覆写(override)这个方法，也可以重载(overload)这个方法，
//: 但前提是要扩大这个前置条件，就是输入参数的类型要宽于父类的类型覆盖范围。这里我们可以反过来思考这个问题，
//: 假如父类的类型覆盖范围宽于子类的输入参数类型，会出现什么情况？这个时候例子中调用的方法很可能就是会进入子类的范畴。
//:
//: 这条规则的主要目的是避免在发生父类被子类替换时，原来的程序`P`会执行子类的方法，这样会导致
//: 程序P的表现可能会发生改变。在里氏替换原则里是不被允许发生的情况。

//: 4. 覆写或实现父类的方法时输出结果可以被缩小
//:
//: 父类的一个方法的返回值是一个类型T，子类的相同方法(重载或覆写)的返回值类型为S，
//: 那么里氏替换原则就要求S必须小于等于T，也就是说，要么S和T是同一 个类型，要么S是T的子类，为什么呢?
//: 分两种情况，如果是覆写，父类和子类的同名方法的 输入参数是相同的，两个方法的范围值S小于等于T，这是覆写的要求，
//: 这才是重中之重，子类覆写父类的方法，天经地义；如果是重载，则要求方法的输入参数类型或数量不相同，在里氏替换原则要求下，
//: 就是子类的输入参数宽于或等于父类的输入参数，也就是说你写的这个方法是不会被调用的，参考上面讲的前置条件。
//:
//: ![里氏替换原则4](里氏替换原则(LSP)_4.png)
//:
//: ### 总结
//:
//: 里氏替换原则的核心原理是抽象，抽象又依赖于继承这个特性，在OOP中，继承的优缺点相当明显，优点如下：
//:
//: 1. 代码共享，减少创建类的工作量，每个子类都拥有父类的方法和属性
//: 2. 子类可以形似父类，但又异于父类
//: 3. 提高代码的可扩展性
//:
//: 继承的缺点：
//:
//: 1. 继承是侵入性的，只要继承就会拥有父类的所有属性和方法
//: 2. 某种程度上降低了代码的灵活性，子类必须拥有父类的属性和方法，让子类多了些约束
//: 3. 增强了耦合性，当父类的常量、变量和方法被修改时，需要考虑子类的修改
//:
//: 里氏替换原则是针对OOP中类的继承的缺点而建立的一些约束条件和规则
