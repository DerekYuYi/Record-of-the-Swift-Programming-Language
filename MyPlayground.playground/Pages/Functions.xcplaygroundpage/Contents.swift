//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

let bounds = minMax(array:[8, 1, -2, 100, 5, 20])
if let bounds = bounds {
    print("\(bounds.min), \(bounds.max)")
} else {
    assert(false, "the value of bounds is nil.")
}


///: Use Default Parameter Values

func someFunction(parameterFirst: Int, parameterSecond: Int = 12) ->  Int {
    print("\(parameterFirst + parameterSecond)")
    return (parameterFirst + parameterSecond)
}

let x = someFunction(parameterFirst: 2, parameterSecond: 3)
let y = someFunction(parameterFirst: 2)


///: Variadic Parameters 变长参数实现  推荐：一个函数应该最多有一个变长参数列表
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

let arithmetic = arithmeticMean(1, 2, 3, 4, 5)
let arithmeticTwo = arithmeticMean(3, 8.25, 19.25)

///: In-Out Parameters
//: 函数参数默认是常量，在函数作用域里去修改参数会抛出运行时错误，如果需要修改一个函数的参数，并且使得该修改的参数在函数调用结束后仍然有效，使用 `inout ` 关键字修饰需要修改的参数, 在传入需要修改的参数时，需要传变量，不能传常量和数字
//: 修改的参数用 `inout` 声明，传入参数时用 `&`修饰`inout参数
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)

///: Function Types
//: 每个函数都有一个特殊的函数类型，该函数类型是有函数的参数类型和返回值类型组成

// function type: `(Int, Int) -> Int`
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

// function type: `() -> Void`
func printHelloWorld() {
    print("hello world")
}


///: Using Function Types
//: 使用函数类型可以像使用其他类型一样
var mathFunction: (Int, Int) -> Int = addTwoInts //: 定义变量 mathFunction, 该变量的类型是“带有两个 Int 类型参数，和一个返回值为 Int 类型 ”函数类型
print("Result: \(mathFunction(2, 3))")

//: 拥有相同类型的不同函数变量之间可以相互赋值（内部拥有 Swift's type-checker）
mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")

///: Function Types as Parameter Types
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b:Int) {
    print("ResultL \(mathFunction(a, b))")
}

// printMathResult 不关心具体的实现过程，只关心传入的函数类型是不是我要求的正确类型，这点保证了 printMathResult 能够以类型安全的方式将其功能传递给函数的调用者.(printMathResult 把先认证 addTwoInts / multiplyTwoInts 是其需要的正确类型，保证类型安全，然后名义上是 printMathResult 在进行计算，实际上是把参数给 addTwoInts / multiplyTwoInts 进行内部计算)
printMathResult(addTwoInts, 3, 5)
printMathResult(multiplyTwoInts, 3, 5)

///: Function Types as Return Types
//: 把某个函数类型作为函数的返回类型
func stepForward(_ input: Int) -> Int {
    return input + 1
}

func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}

var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)

print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)...")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")

///: Nested Functions
//: 大多数函数定义在一个全局的作用域内，称为全局函数，我们也可以在函数体内定义函数，称为嵌套函数（nested functions）.

func _chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}



