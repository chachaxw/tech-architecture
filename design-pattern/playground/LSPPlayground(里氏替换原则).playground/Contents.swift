import UIKit

//:
//: ### 什么是里氏替换原则(Liskov Substitution Principle)？
//:
//: 里氏替换原则有两种定义：
//: 第一种定义：如果对每一个类型为S的对象O1，都有类型为T的对象O2，使得以T定义的所有程序P
//: 在所有的对象O1都代换成O2时，程序P的行为没有发生变化，那么类型S是类型T的子类型，
//:
//: If for each object O1 of type S there is an object O2 of type T such that for all programs P defined in terms of T,
//: the behavior of P is unchanged when O1 is substituted for O2 then S is subtype of T.
//:
//: 第二种定义：所有引用基类的地方必须能透明地使用其子类的对象，Function that use poiners or references to base classes
//: must be able to use objects of derived classes without knowing it.
//:

var str = "Hello, Liskov Substitution Principle(里氏替换原则)，简称LSP"

print("\(str)")

//: 里氏替换原则为良好的继承定义了一个规范，一句简单的定义包含了4层含义:
//:
//: 1. 子类必须完全实现父类的方法
//: 例如下图：
//:
//: ![里氏替换原则(LSP)](../../images/里氏替换原则(LSP).png)
let image = UIImage(named: "里氏替换原则(LSP)")

//: 我们都会打吃鸡游戏，里面有各种各样的枪支，我们用上图来描述一下里面用到的各种枪支。枪的主要职责是射击，
//: 所以我们定义了一个基本枪支类Gun，在士兵类中定义了一个killEnemy方法，使用枪来杀敌人，具体用什么枪来杀敌人，要调用
//: setGun才知道，我们首先来看看类Gun。
//: 我们首先定义一个AbstractGun协议，遵循这个协议的所有类都需要实现shoot方法，
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
    private var gun: Gun
    
    init() {
        /// gun成员变量初始化
        gun = HandGun()
    }

    public func setGun(gun: Gun) {
        self.gun = gun
    }
    
    public func killEnemy() {
        print("\(gun) 射击")
        gun.shoot()
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

//: 2.子类可以有自己的个性

//: 3. 覆盖或实现父类的方法时输入参数可以被放大

//: 4. 覆写或实现父类的方法时输出结果可以被缩小
