//: [Previous](@previous)

import Foundation

// https://docs.swift.org/swift-book/LanguageGuide/Methods.html

var str = "Hello, Methods"

//: [Next](@next)

//: - Summary
/**
 方法是与特定类型相关联的函数. 类, 结构体和枚举都能定义实例方法. 这些实例方法为实例封装了特定的任务和功能. 类, 结构体和枚举也能定义类型方法, 类型方法和 OC 中的类方法相似.
 `在结构体和枚举中能够定义方法` 是Swift 和 C、OC的主要区别. 在 OC中, 只有类能够定义方法.
 **/

//: - The Self Property
/**
 每个类型的实例都有一个隐式属性叫 `self`, 它与实例本身完全等价. 你可以在实例方法内使用 `self` 属性去指向实例的属性.
 **/

//: - Modifying Value Types from Within Instance Methods
/**
 默认情况下, 在实例方法内是不能修改一个值类型的属性的. 可以加入 `mutating` 到实例方法声明中, 修改该实例方法内的结构体或者枚举的属性. 当方法结束时, 修改后的值会写会(written back)原值类型实例中. 方法也会分配一个完整的新的实例给 `self` 属性, 并且这个新的实例将会代替原来存在的实例
 **/


///: moveBy 方法的实现, Array 的这个方法是不是这样实现的
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 2.0)

///: Note: 不要在一个结构体的常量实例上调用 mutating 方法, 因为它的属性不能被改变, 尽管它的属性是可变的.
let fixedPoint = Point(x: 3.0, y: 3.0)
/*
fixedPoint.moveBy(x: 2.0, y: 2.0) // this will report an error
 */


//: - Assigning to self Within a Mutating Method - 在可变方法中给 `self` 赋值
/**
 Mutating methods 可以给 self 赋一个完整的新值.
 **/
struct PointSecond {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = PointSecond(x: x + deltaX, y: y + deltaY)
    }
}

/**
 枚举的 Mutating methods 可以为 self 设置成不用的 case 值
 **/
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
            
        case .low:
            self = .high
            
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
ovenLight.next()


//: - Type Methods
/**
 type methods: 能直接被类型本身(而不是 instances of type)调用
 声明: 使用 `static` 和 `class` 关键字, 前者不允许重载, 后者允许重载
 
 **/


struct LevelTracker {
    static var highestUnlockedLevel = 1 //: 跟踪运动员解锁的最高纪录等级
    var currentLevel = 1 //: 跟踪当前运动员的等级
    
    //: 当最高纪录解锁, 更新并保存最高纪录值
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    
    //: 判断特定的值是否有解锁
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    //: 检查请求的等级是否已经解锁
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")

player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}

