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
 4. 引用计数（Reference counting）： 允许对类实例有多个引用，结构体在内部传递的方式是 copy，每次只有一个引用
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

//: 1. 结构体中成员逐一复制的初始化方法 (所有的结构体都会自动生成一个成员逐一覆盖的初始化方法)
let vga = Resolution(width: 640, height: 480)

//: 2. 结构体和枚举都是值类型(Value Type)
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

//: 3. 类是引用类型（Reference Type）
/*:
 reference type: 当一个类型的值被赋值给一个常量或者变量，或者当它被作为参数传递给一个函数时，这个值被引用而不是被复制，在内存中只会存在一份实例，但同时会有两个引用指向该地址，此时我们该值对应的类型为引用类型
 */
let tenEighty = VideoMode()
tenEighty.resolution = hd // resolution is structrue and is value type
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty // tenEighty and alsoTenEighty actually both refer to the same VideoMode instance, Effectively, they are just two different names for the same single instance.
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")

//: 4. Identity Operators
//: 由于类是引用类型，所以有可能在内存中同时存在多个常量或者变量指向同一个实例，我们可以使用`恒等(===)`或者`不恒等(!==)`来区分是不是多个常量或者变量指向的是同一个类实例

if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}

/*:
 NOTE:
 - "Identical to" （恒等) 是指两个常量和变量精确的指向同一个类实例（内存地址），这两个常量或者变量是类类型
 - "Equal to" （等于）是指两个实例的值是相等的，仅仅局限于 value
*/

//: 5. Pointers (指针)
//: 在 C, C++, Objective-C 中，均用指针来指向内存地址，Swift 中常量或者变量指向引用类型的实例跟 C 中相似，但是不是直接使用指针指向内存地址，也不用在创建的实例前面加 “*” 来标明我是一个引用类型实例，相反，直接像定义常量或者变量来定义引用即可

//: 6. 合适选择 类 和 结构体 的使用
/*:
 由于结构体的实例在传递时总是值传递方式，而类实例在传递时总是以引用传递方式，我们在选择使用需根据具体的数据结构来选择结构体还是类去实现。
 一般来说，用结构体应该满足如下条件（或者之一）：
  - 结构体的初衷是概括简单数据类型；
  - 当你分配或者传递某个结构体的实例时，预期封装的值将会被复制（copy）而不是被引用；
  - 以结构体形式存储的任何属性本身是值类型，这也期望他们在使用时被复制而不是被引用；
  - 结构体不需要去继承另一个存在类型的属性或者函数功能.
 
 典型使用结构体例子如下：
  I. 几何图形的大小 size，封装属性比如 width 或者 height, double 类型
     struct GeometricShapeSize {
     var width = 0.0
     var height = 0.0
     }
 
  II. 表示范围 range，比如封装属性 start 或者 length, Int 类型
  III. 三维坐标点，例如 (x, y, z)
 
 除了上述使用 结构体 的情况之外，其他情况大部分使用类的实例。实际上，大部分自定义的数据结构用类，不是结构体.
 */

//: 7. Strings, Arrays 和 Dictionaries 的复制行为
//: 在 Swift 中，许多的基础类型例如 String, Array, 和 Dictionary 内部都是用 structure 实现，这也意味着当然他们的实例赋值给其他常量或者变量，或者作为参数被传递给函数或者方法时，在内存上是会拷贝一份，而不是引用。这个行为跟 Foundation中完全不同。在 Foundation 中，NSString, NSArray 和 NSDictionary 内部用类实现，而非 structure, 所以当他们的实例在传递时是以引用的方式，而不是拷贝复制。

//: NOTE: Swift 中的写实特性
/*:
 The description above refers to the "copying" of strings, arrays, and dictionaries. The behavior you see in you code will always be as if a copy took place. However, Swift only performs an actual copy behind the scenes when it is absolutely necessary to do so. Swift manages all value copying to ensure optimal performance, and you should not avoid assignment to try to preempt this optimization.
 上面描述的是指字符串、数组和字典的`复制`。您在您的代码中看到的行为总是一个副本发生的。然而，在绝对必要的时候，Swift 才在后台执行一个实际的拷贝。Swift 管理所有的值复制，以确保最优性能，并且你不应该避免分配来尝试抢占这个优化。
 */

