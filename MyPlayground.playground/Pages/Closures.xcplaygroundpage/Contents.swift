//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

///: 闭包采用三种形式之一
/*
 1. 全局函数 (Global functions)： `有名字，但不捕获任何值` 的闭包；
 2. 嵌套函数 (Nested functions)： `有名字，从嵌套的函数内捕获值` 的闭包；
 3. 闭包表达式：没有命名的闭包，从包围的内容中捕获值
 */

///: The sorted Method
//: sorted(by:) 通过传入 true 或者 false 来决定是降序还是升序排列, 源数组不变，返回排序后的新数组
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward) // 接受参数为一个闭包，闭包的类型为：两个参数均为 string 类型，返回值为 Bool

///: Closure Expression Syntax
/*
{
    (#parameters#) -> #return type# in
    #statements#
}
*/

let reversedNames1 = names.sorted(by: { (s1: String, s2: String) -> Bool in
        return s1 > s2
})

///: Inferring Type From Context
//: 上述中的闭包是作为一个参数传给 sorting 函数，Swift 中拥有类型推断的功能，能够推断出函数本身的参数类型和返回值类型。这里是names 数组排序，可以推断出闭包参数的类型为 (String, String) -> Bool, 由此可简写为：
let reversedNames2 = names.sorted(by: { s1, s2 in return s1 > s2 })
//: 当闭包作为一个函数的或者方法的参数时，我们可以通过 Swift's type-checker 来简写参数及返回值类型

///: Implicit Returns from Single-Expression Closures
//: 当 closure 可以单行书写时，可以省略 `return` 关键字
let reversedNames3 = names.sorted(by:  { s1, s2 in s1 > s2 })


///: Shorthand argument Names
//: Swift 中为闭包提供速记参数名的写法，使用 `$0, $1, $2...`来指向代替闭包依次的参数值。如果使用速记法，则可以省略闭包原来的参数列表
//: $0 和 $1 指向闭包的第一个和第二个参数
let reversedNames4 = names.sorted(by: { $0 > $1 })


///: Operator Methods
let reversedNames5 = names.sorted(by: >)


///: Trailing Closures 尾随闭包
//: 当闭包参数多，比较长而不能一行写下的时候，这个时候用 尾随闭包 会使得代码更有可读性.
let reversedNames6 = names.sorted() { $0 > $1 }

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

// map: 把元数组转换为相同或者不同类型的数组输出
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

///: Capturing Values
//: 闭包可以从所在定义的上下文中捕获常量或变量的值，并且可以在闭包内部修改捕获到的常量或者变量的值
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    
    func incrementer() -> Int { // 此闭包（嵌套函数）中捕获了外部值 runningTotal 和 amount 在其内部使用。这里通过引用的方式捕获两个值，确保 runningTotal 和 amount 在调用 makeIncrementer 结束时都不消失
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}


//: 捕获的变量一直在闭包的生命周期内存在
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
incrementBySeven()
incrementByTen()
incrementBySeven()

//: 我们可以理解为：创建了两个 makeIncrementer 实例，两个实例分别通过初始化参数 10 和 7 初始化为 类型 （) -> Int, 初始化成功后分别调用，互不相干


///: Closures Are Reference Types
//: 在上面的例子中， incrementByTen 和 incrementBySeven 都是常量，但是这两个常量指向的闭包仍然能够修改内部 runningTotal 的变量值。这是因为函数和闭包都是引用类型（reference type）
// 把同一个闭包赋值给不同的常量或者变量，这里常量或者变量指向同一个闭包
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()

///: Escaping Closures
//: 当某个闭包被当作参数传递给函数时，这时该闭包逃逸了函数，称为逃逸闭包（表现为 global function），并且闭包在该函数返回后才调用。使用关键字 `@escaping` 申明
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

//: 当闭包用 @escaping 声明时，必须在闭包内部明确使用 self 引用

func someFunctionWithNonescapingClosure(closure: () -> Void) { // non-escaping closure
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 10 } // Must explicit with `self.`
        someFunctionWithNonescapingClosure { x = 200 }
    }
    
}
