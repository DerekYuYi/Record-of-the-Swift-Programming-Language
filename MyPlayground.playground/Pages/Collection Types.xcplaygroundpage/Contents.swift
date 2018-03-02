//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

/// 使用 stride 进行周期性的运算
//: 从 from 开始，以间距 by 为单位到 to 但小于 to
for tickMark in stride(from: 0, to: 60, by: 5) {
    print(tickMark)
}

let hours = 12
let hourInterval = 3
//: 从 from 开始，以间距 by 为单位到 through 但不超过
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    print("----\(tickMark)")
}

// Tuples
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}

// Value Bindings
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y)")
}

// Where
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

///: 使用 `fallthrough` 来实现 switch 中 case 的贯穿

///: Checking API Availability
if #available(iOS 11, macOS 10.12, *) {
    
}
