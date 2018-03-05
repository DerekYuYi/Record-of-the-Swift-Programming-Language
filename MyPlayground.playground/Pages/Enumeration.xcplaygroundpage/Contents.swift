//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

/*
 Swift 中枚举类型本身是一流的，它使用许多仅仅由类支持的功能特性
 1. 可以使用组合属性 (computed properties)
 2. 可以使用实例方法
 3. 可以定义初始化方法
 4. 可以在原来的实现上扩展新的功能
 5. 可以遵守某个协议来提供标准的对外功能
*/

//: 1. Enumeration Syntax (与 C 和 Objective-C 不同，Swift 中枚举不使用默认值，每个枚举本身就是明确语义的值)
enum CompassPoint {
    case north
    case south
    case east
    case west
}

//: 多行显示, 枚举名以大些字母开头
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
directionToHead = .north

//: 2. Associated Values (存储任何给定类型的关联值，并且给定的类型可以不同)
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
// 可以这样描述 Barcode 枚举类型：定义枚举类型名为 Barcode, 其包括两个值 upc 和 qrCode，我们可以通过类型 (Int, Int, Int, Int) 的关联值取 upc 的值，通过类型 String 的关联值取 qrCode 的值.

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

//: 2. Raw Values (枚举可以通过 raw values 来实现递增，但是前提是此枚举类型是某一特定的类型, 这些类型可以是 string, character, floating-point, 每个 raw value 在枚举类型内一定是唯一的)
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

let a = ASCIIControlCharacter.tab.rawValue
let b = ASCIIControlCharacter.carriageReturn.rawValue

// 跟 OC 中的枚举一样，Swift 中的枚举也有隐式赋值(默认赋值)。当枚举类型是用来存储 整型 或者 字符串类型时，Swift 都会自动赋给隐式值。整型默认第一个值 raw value 为 0, 如果有赋值，则往上递增； 对于字符串类型会给默认的自身字符串值.
enum PlanetInt: Int {
    case mercury = 0, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPointString: String {
    case north, south, east, west
}

let me = PlanetInt.mercury.rawValue
let earthsOrder = PlanetInt.earth.rawValue

let sunsetDirection = CompassPointString.west.rawValue


// 可以使用 Raw Value 来初始化某个枚举
let possiblePlanet = PlanetInt(rawValue: 7)
// 返回结果是 optional type, 也就是说这个可选类型是一个 可失败的初始化（Failable Initializers）

//: 3. 递归枚举 （Recursive Enumerations）: 有该枚举实例类型作为该枚举某个 case 的关联值的枚举称为递归枚举（一个枚举类型中的某个或者多个 case 取值由该枚举类型中其他 case 类型的实例关联）。我们可以在对应的 case 前面添加关键字 indirect 来声明递归枚举, 可以在 enum 前添加 indirect 来申明该枚举所有的 case 都有关联值

enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
    
    static func evaluate(_ expression: ArithmeticExpression) -> Int {
        
        print("执行了枚举函数")
        switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .multiplication(left, right):
            return evaluate(left) * evaluate(right)
        }
    }
}

/*
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
*/
// 我们可以先构造各种算法对应的流程，利用枚举提供的各种功能组合，输出为 枚举实例，在函数中实现（递归函数居多）

// (4 + 5) * 2 的流程
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
//product.evaluate(product)
ArithmeticExpression.evaluate(product)
ArithmeticExpression.evaluate(sum)
ArithmeticExpression.evaluate(four)
// 递归函数是处理具有递归结构的数据的简单方法

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product))


