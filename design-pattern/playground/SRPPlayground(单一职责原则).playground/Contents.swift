import UIKit

//: ### 单一职责原则(Single Responsibility Principle)
//: > 定义：就一个类而言， 应该仅有一个引起它变化的原因
//: >  There should never be more than one reason for a class to change.
//:
//: 单一职责的划分界限并不是那么清晰，很多时候需要靠个人经验界定。当然最大的问题就是对职责的定义，什么是类的职责，以及怎么划分类的职责。
//:
//: ![单一职责原则(SRP)](../../images/单一职责原则(SRP).jpg)
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
//: 应该把用户的信息抽取成一个业务对象BO（Business Object），把用户行为抽取成一个业务逻辑Biz（Business Logic）
//:
//: 改造后：
// 用户基本信息
protocol UserInfoBO {
    func setUserId(id: String) -> Void
    
    func getUserId() -> String
    
    func setPassword(pwd: String) -> Void
    
    func getPassword() -> String
    
    func setUsername(name: String) -> Void
    
    func getUsername() -> String
}

// 用户业务逻辑
protocol UserInfoBiz {
    func changePassword(old: String) -> Bool
    
    func deleteUser(id: String) -> Bool
    
    func mapUser() -> Void
    
    func addOrg(orgId: String) -> Bool
    
    func addRole(roleId: String) -> Bool
}
