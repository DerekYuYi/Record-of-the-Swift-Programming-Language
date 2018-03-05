//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

/*:
 比较类和结构体的相同点和不同点：
 相同点：
     1. 能定义属性来保存值
     2. 能定义方法来提供功能
     3. 能定义下标来通过下标的方式取值
     4. 能定义初始化函数
     5. 能在默认实现的基础上扩展功能
     6. 能遵循协议提供某种特定类型的标准功能
 
 不同点：（类独有的功能）
 1. 继承(Inheritance)：使得一个类继承另一个类的特点
 2. 类型转换(Type casting)： 能够在运行时检查和解释类实例的类型
 3. 析构器（Deinitializers）：能够释放类实例分配的任何资源
 4. 引用计数（Reference counting）： 允许对类实例有多个引用，结构体在内部传递的方式是 copy
 */

struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

//: 结构体中成员逐一复制的初始化方法 (所有的结构体都会自动生成一个成员逐一覆盖的初始化方法)
let vga = Resolution(width: 640, height: 480)


//: 结构体和枚举都是值类型(Value Type)
/*:
 value type: 当一个类型的值被赋值给一个常量或者变量，或者当它被作为参数传递给一个函数时，这个值被复制而不是被引用，在内存中会存在原始值和新复制的值，此时我们该值对应的类型为值类型
 value types: 值类型包括 结构体，枚举和所有的基本类型 （integer, floating-point numbers, Booleans, strings, arrays, dictionaries）
 内部实现：所有的值类型内部均以结构体实现
 */
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd

cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide")
print("hd is still \(hd.width) pixels wide")

//: 枚举例子
enum CompassPoint {
    case north, south, east, west
}

var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection = .east


//: 类是引用类型（Reference Type）
/*:
 reference type: 当一个类型的值被赋值给一个常量或者变量，或者当它被作为参数传递给一个函数时，这个值被引用而不是被复制，在内存中只会存在一份实例，此时我们该值对应的类型为值类型
 */
