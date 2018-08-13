//: [Previous](@previous)

import Foundation

var str = "Extensions"

//: https://docs.swift.org/swift-book/LanguageGuide/Extensions.html

//: [Next](@next)

//: extensions in swift can:
/**
 
 1> add computed instance properties and computed type properties;
 2> Define instance methods and type methods
 3> Provide new initializers
 4> Define subscripts
 5> Define and use new nested types
 6> Make an existing type conform to a protocol
 
 **/
//: 一、format
extension Double {
    
}

//: 二、 计算属性 (Computed Propeties)
///: Extensions 可以添加 computed instance properties 和 computed type properties
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")
/**
 | Note: 1. 这些属性均为只读属性
 |       2. 只能是 computed properties, 不能添加 stored properties 和 observer
 |
 **/

//: 三、 初始化方法 (Initializers)
///: Extensions 可以为存在的类型添加初始化方法, 这让我们可以扩展其他类型在他们的初始化方法中使用自定义的类型作为参数. 可以为 Class, Value Type, Structure 添加. Extensions 只可以添加 convenience initializer, 不能添加 designated initializer or deinitializer. 因为设计 initializers 和 deinitializer 总是必须由本类来实现.

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                          size: Size(width: 5.0, height: 5.0))
///: 为 Rect 添加 extension:
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))


//: 四1、方法 (Methods)
///: 可以添加 instance methods 和 type methods
///: 重复
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions {
    print("Hello!, YuYi.")
}

//: 四2、可变的实例方法 (Mutating Instance Methods)
///: 用 extension 添加的实例方法可以修改实例本身的值. Structure 和 enumration 实例方法修改本身值或者属性值必须用关键字 `mutating` 声明
extension Int {
    mutating func square() {
        self = self * self
    }
}

var three = 3
three.square()

//: 五、下标 (Subscripts)
///: Extensions 可以添加为一个存在的类型添加新的下标
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

75758959[3]
1234[3]
1243[2]
//: 嵌套类型(Nested Types)
///: Extensions 可以为存在的类, 枚举, 结构体添加 nested types
///: 输出一个整形数是不是正数,负数,或者0
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    //: 为 Int 扩展 kind 属性
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        
        case let x where x > 0:
            return .positive
            
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", separator: "", terminator: "")
            
        case .positive:
            print("+ ", separator: "", terminator: "")
            
        case.zero:
            print("0 ", separator: "", terminator: "")
        }
    }
}

printIntegerKinds([3, 0, -3, -5, 6, 6])
3.kind

