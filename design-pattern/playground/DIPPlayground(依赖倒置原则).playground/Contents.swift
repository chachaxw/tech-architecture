import UIKit

//:
//: ### 什么是依赖倒置原则(Dependence Inversion Principle)？
//:
#imageLiteral(resourceName: "依赖倒置原则1.png")//: 依赖倒置原则的原始定义:
//:
//: 高层模块不应该依赖于低层模块，两者都应该依赖于抽象。抽象不应该依赖于细节，细节应该依赖于抽象。
//:
//: High level modules should not depend upon low level modules.Both should depend upon abstractions.
//: Abstractions should not depend upon details.Details should depend upon abstractions.
//:
//: 在Java语言中，抽象就是指接口或抽象类，两者都是不能直接被实例化；细节就实现类，实现接口或继承抽象
//: 而产生的类就是细节，其特点就是可以直接被实例化，也就是可以加上一个关键字new产生一个对象。在Swift
//: 语言中，基本类似，只不过面向接口变成了面向协议，两者基本一致。
//:
//: 采用依赖倒置原则可以减少类间的耦合性，提高系统的稳定性，降低并行开发引起的风险，提高代码的可读性和可维护性。

var str = "Hello, Dependence Inversion Principle playground"

//: 下面我用一个例子来展现依赖倒置原则在提高代码的可读性和可维护性中所起的重要作用。
//: 还是先看看我们的UML图：
//:
//: ![依赖倒置原则](依赖倒置原则1.png)

/// Driver类
class Driver {
    func drive(benz: Benz) {
        print("开车。。。")
        benz.run()
    }
}

/// Benz类
class Benz {
    func run() {
        print("奔驰。。。")
    }
}

let driver = Driver()
driver.drive(benz: Benz())

// 上面代码运行结果: 开车。。。 奔驰。。。

//: 通过上面代码，我们实现了一个基本的司机开奔驰的场景。但是假如我们现在有辆宝马车类`BMW`，这个时候发现，`Driver`类的`drive`方法无法接收`BMW`类。
//: 问题出现了，我们的`Driver`类和`Benz`之间是强耦合的，其导致的结果就是我们的系统可扩展性大大降低。还有一个问题，我们在团队协同开发的时候，
//: 假设`Driver`类和`Benz`类分别由两名开发人员来开发，就会发现`Driver`类在`Benz`类未实现之前，是无法实现`drive`方法的，因为在`drive`方法
//: 中调用了`benz.run()`方法，两者有一定的依赖，这样就导致了两名开发人员无法协同开发，影响整体开发进度。现实中这种情况太多了，由于模块之间
//: 有很强的依赖和耦合，往往会导致多人无法正常协作。这个时候，依赖倒置原则就开始发挥作用了，下面我们来看看利用依赖倒置原则是如何来解决上述问题的。
//:
//: 承接上面的例子，引入依赖倒置原则后的类图如下图所示：
//:
//: ![依赖倒置原则](依赖倒置原则2.png)
//:
//: 我们建立了两个协议（接口）：PDriver和PCar，分别定义了司机和汽车的智能，司机驾驶汽车，所以必须实现drive方法，汽车必须实现run方法。
//:
/// 司机协议
protocol PDriver {
    func drive(car: PCar) -> Void
}

/// 司机类的实现
class NewDriver: PDriver {
    func drive(car: PCar) {
        car.run()
    }
}

/// 汽车协议
protocol PCar {
    func run() -> Void
}

/// 奔驰车类
class BenzCar: PCar {
    func run() {
        print("奔驰车开始运行。。。")
    }
}

/// 奔驰车类
class BMWCar: PCar {
    func run() {
        print("宝马车开始运行。。。")
    }
}

//: 上面是所有代码实现，我们遵循“抽象不应该依赖细节”，也就是我们认为抽象（PCar协议）不依赖`BMW`和`Benz`两个实现类。
//: 下面再来看看我们的业务场景。
//:
///业务代码
let driver1: PDriver = NewDriver()
let benz: PCar = BenzCar()
let bmw: PCar = BMWCar()

/// 开奔驰
driver1.drive(car: benz)
/// 开宝马
driver1.drive(car: bmw)

//: 从上面的例子中，我们的业务逻辑并没有直接依赖具体的类，而是直接依赖抽象协议，BenzCar和BMWCar都遵循PCar协议(Java里面的interface)
//: 所以这里司机类的`drive`方法可以调用具体实现类的`run`方法。从上面的代码也可以看出，无论汽车是什么类型，只要遵循`PCar`协议，
//: 司机类`NewDriver`就可以调用`run`方法，低层模块`BenzCar`或`BMWCar`无论怎么变化，都不影响高层模块业务逻辑的实现。
//:
//: > 只要定义变量就必然要有类型，一个变量可以有两种类型:表面类型 和实际类型，表面类型是在定义的时候赋予的类型，
//: > 实际类型是对象的类型，如driver1的表面类型是PDriver，实际类型是NewDriver。
//:
//: 依赖倒置原则可以减少类间的耦合性，提高系统的稳定性，降低并行开发引起的风险，提高代码的可读性和可维护性。
