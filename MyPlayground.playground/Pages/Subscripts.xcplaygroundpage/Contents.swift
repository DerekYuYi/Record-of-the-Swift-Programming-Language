//: [Previous](@previous)

import Foundation

var str = "Hello, Subscripts"

//: https://docs.swift.org/swift-book/LanguageGuide/Methods.html

//: [Next](@next)

//: - Summary
/**
 - 让开发者可以通过 `[]` 的形式去查询某个类型实例的值
 - 类, 结构体 和 枚举都可以使用下标, 常用于集合(collection), list(表), sequence(序列)
 - 设置或者解析值功能来代替: 某些需要单独的方法来设置或者解析值的功能
 定义关键字: subscript
 ***/

// read-write for computed properties
subscript(index: Int) -> Int {
    get {
        // return an appropriate subscript value here
    }
    
    set(newValue) {
        // perform a suitable setting action here
    }
}

// read-only computed properties
subscript(index: Int) -> Int {
    // return an appropriate subscript value here
}

/*
 n倍乘法表
 */
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int { // read-only computed properties
        return multiplier * index
    }
}

let threeTimesTable = TimesTable(multiplier: 6)
print("six times three is \(threeTimesTable[6])")

//: - Subscript Options
///: subscript overloading(下标运算符重载): 多个下标运算符的定义

/*
 通过下标来取二维矩阵中的每个值
 */
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >=0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range.")
            return grid[(row * columns) + column]
        }
        
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range.")
            grid[(row * columns) + column] = newValue
        }
    }
}
// create a matrix (2*2)
var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2


