//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

//: 相关链接 - https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID254
//: 小结 - 属性包括储存属性(stored properties) 和 计算属性(computed properties)。
/*:
 - 存储属性:
    存储常量或者变量作为实例的一部分;
    只使用在类和结构体中
 
 - 计算属性:
    只是计算一个值而不是存储;
    可以使用在类，结构体和枚举中;
 
 - 类型属性（type properties）
 
 - 属性观察者（property observers）
    可以监听属性值的改变，并在改变时对自定义的行为作出响应；
    可以被加在存储属性
*/


//: 1. 存储属性
//: 存储属性可以为常量或者变量，可以为存储属性提供初始值，也可以在初始化后设置和修改初始值
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6

//: 1.1. 常量结构体实例的存储类型
//:如果创建一个常量的结构体实例，是不能去修改该实例的属性的，尽管属性申明为 var. 内部的原因是 value type 和 reference type 的区别。当一个值类型的实例被申明为一个常量时，他的所有属性均被标记为常量，但是引用类型则不同。如果申明一个引用类型实例为常量时，你仍然可以改变实例的变量属性。

let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
//rangeOfFourItems.firstValue = 3 // report an error

//: 1.2. 懒加载存储属性
//: 懒加载属性是在属性第一次用到的时候才去计算初始值，在一次生命周期中都不会再去计算该属性值。以关键字`lazy`冠再属性前申明，只能声明变量
class DataImporter {
    var filename = "data.txt"
}

class DataManager {
    lazy var importer = DataImporter()
}

// NOTE: 如果声明的懒加载属性在多线程中同时执行被取操作，这里不保证属性只被初始化一次


//: 计算属性
///: 类，结构体和枚举都可以定义计算属性。计算属性不存储值，相反，它们提供一个 getter 和 可选的 setter 去直接操作其他的属性和值
struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
