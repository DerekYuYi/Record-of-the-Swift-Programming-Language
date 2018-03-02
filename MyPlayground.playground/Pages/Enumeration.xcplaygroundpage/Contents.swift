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

// Raw Values (枚举可以通过 raw values 来实现递增，但是前提是此枚举类型是某一特定的类型, 这些类型可以是 string, character, floating-point, 每个 raw value 在枚举类型内一定是唯一的)
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

let a = ASCIIControlCharacter.tab.rawValue
let b = ASCIIControlCharacter.carriageReturn.rawValue
