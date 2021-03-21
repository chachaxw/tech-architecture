//: ### 单一职责原则(Single Responsibility Principle)
//: > 定义：就一个类而言， 应该仅有一个引起它变化的原因
//: >  There should never be more than one reason for a class to change.
//:
//: 单一职责的划分界限并不是那么清晰，很多时候需要靠个人经验界定。当然最大的问题就是对职责的定义，什么是类的职责，以及怎么划分类的职责。
//:
//: ![单一职责原则(SRP)](单一职责原则(SRP).png)
//:

//: ### 单一职责原则实例：
var str = "Hello, Single Responsibility Principle(单一职责原则)，简称SRP"

print("\(str)")

//:  我们有一个基本的用户协议(UserInfo), 基本结构如下：
protocol UserInfo {
    func setUserId(id: String) -> Void
    
    func getUserId() -> String
    
    func setPassword(pwd: String) -> Void
    
    func getPassword() -> String
    
    func setUsername(name: String) -> Void
    
    func getUsername() -> String
    
    func changePassword(old: String) -> Bool
    
    func deleteUser(id: String) -> Bool
    
    func mapUser() -> Void
    
    func addOrg(orgId: String) -> Bool
    
    func addRole(roleId: String) -> Bool
}

//: 从上面的用户协议来看，用户的属性和用户行为杂糅在一个协议里面，并未遵循单一职责原则。
//: 应该把用户的信息抽取成一个业务对象BO（Business Object），把用户行为抽取成一个业务逻辑对象Biz（Business Logic）
//:
//: 改造后：
// 用户基本属性对象
protocol UserInfoBO {
    func setUserId(id: String) -> Void
    
    func getUserId() -> String
    
    func setPassword(pwd: String) -> Void
    
    func getPassword() -> String
    
    func setUsername(name: String) -> Void
    
    func getUsername() -> String
}

// 用户业务逻辑对象
protocol UserInfoBiz {
    func changePassword(old: String) -> Bool
    
    func deleteUser(id: String) -> Bool
    
    func mapUser() -> Void
    
    func addOrg(orgId: String) -> Bool
    
    func addRole(roleId: String) -> Bool
}

//: 单一职责原则优点：
//:
//: * 类的复杂性降低，实现什么职责都有清晰明确的定义
//: * 可读性提高，复杂性降低，那当然可读性提高了
//: * 可维护性提高，可读性提高，那当然更容易维护了
//: * 变更引起的风险降低，变更是必不可少的，如果接口的单一职责做得好，
//: 一个接口修 改只对相应的实现类有影响，对其他的接口无影响，这对系统的扩展性、维护性都有非常大 的帮助
//:
//: > NOTE
//: > 单一职责原则提出了一个编写程序的标准，用“职责”或“变化原因”来衡量接口或 类设计得是否优良
//: > 但是“职责”和“变化原因”都是不可度量的，因项目而异，因环境而异。
