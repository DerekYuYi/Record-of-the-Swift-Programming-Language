//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///: String Literals
//: 1. Multiline String Literals
//: 用 三对双引号 ”“”  “”“来标记多行字符串常量

let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""

//: 加 “\“增加可读性，并不会在增加 “\”的地方换行
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""
print(softWrappedQuotation)

//: 以换行符开头，以换行符结尾
let lineBreaks = """

This string starts with a line break.
It also ends with a line break.

"""
print(lineBreaks)

//: 多行字符串会自动匹配空白字符占位，在引号开始之后的空白字符串个数是下面多行字符串前面均自动忽略的空白字符串个数
let linesWithIndentation = """
    This line doesn't begin with whitespace.
        This line begins with four spaces.
    This line doesn't begin with whitespace.
"""
print(linesWithIndentation)

///: Special Characters is String Literals
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
let dollarSign = "\u{24}"
let blackHeart = "\u{2665}"
let sparklingHeart = "\u{1F496}"

let threeDoubleQuotationMarks = """
Escaping the first quotation mark \"""
Escaping all three quotation marks \"\"\"
"""
print(threeDoubleQuotationMarks)

///: Strings are Value Types, 当作为参数传递给函数或方法时，或者赋值给其他变量时，均被拷贝一份，地址复制而不是指针复制，每次都是创建新的对象而不是原来的值引用

///: Accessing and Modifying a String
//: String Indices: String.Index, startIndex, endIndex, index(before:), index(after:), index(_:offsetBy:)
let greeting = "Guten Tag!"
//greeting[greeting.endIndex] // runtime error

for index in greeting.indices {
    print("\(greeting[index]) ")
}

//: Inserting and Removing
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex) // 插入单个
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex)) // 插入多个

welcome.remove(at: welcome.index(before: welcome.endIndex)) // 移除单个
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex // 移除多个
welcome.removeSubrange(range)

// Substrings: 子字符串的性能表现更好。因为 substring 会重用 origin string 的部分内存，这意味着在修改 origin string 或者 substring之前，substring 是不会占用额外的内存消耗，但是 substring 只适合短时间内存值，因为 substring 重用了 origin string 的部分内存，origin string 必须保证整个memory直到 substring 作出改变
let hello = "Hello, world!"
let index = hello.index(of: ",") ?? hello.endIndex
let beginning = hello[..<index] // substring and short-term storage

let newString = String(beginning) // string, Convert the result to a String for long-term storage

// Prefix and Suffix: hasPrefix(_:), hasSuffix(_:)


let dogString = "Dog!!🐶 "
for codeUnit in dogString.utf8 {
    print("\(codeUnit) ")
}

for codeUnit in dogString.utf16 {
    print("--\(codeUnit) ")
}

for scalar in dogString.unicodeScalars {
    print("----\(scalar.value) ")
}
