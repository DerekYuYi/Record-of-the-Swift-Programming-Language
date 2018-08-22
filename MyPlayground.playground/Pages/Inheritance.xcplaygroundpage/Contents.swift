//: [Previous](@previous)

import Foundation

// 继承篇
var str = "Hello, Inheritance"
//: - related link: - https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html

//: - Summary
/**
 - 在 Swift 中继承特性是区分类和其他类型的特性之一
 - 在 Swift 中的类, 可以调用父类的方法, 调用下标, 存取属性, 也能为这些方法、属性和下标提供自己的重载版本,去重新定义和修改它们的行为.
 ***/

//: - Defining a Base Class (定义基类)
/**
 - 任何一个没有从其他类继承的类被称为 base class
 -
 **/
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        
    }
}

//: - Subclassing

class Bicycle: Vehicle { /// 自动获取父类的属性和方法
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true

/// 修改继承的属性 `currentSpeed`
bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")

/// 子类自己也可以被继承. Tandem 继承了 Bicycle 所有的属性和方法
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")

//: Overrding
/**
 - 重载定义: 子类可以为父类的实例方法, 类方法, 实例属性, 类属性以及下标提供自己的实现, 而不是从父类继承.
 - 重载关键字: override
 **/

///: - 访问父类方法, 属性 和下标
/**
 - 当我们重载时, 经常会保留父类中方法, 属性和下标的实现, 并作为重载的一部分, 我们使用 `super` 关键字来实现
  - super.someMethod()
  - super.someProperty
  - super[someIndex]
 **/

////: Overriding Methods
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise()

////: Overriding Properties
//// - 可以重载已继承的实例属性或者类型属性来提供自定义的 getter 或者 setter 方法, 或者添加 属性观察者来在属性值发生根本变化的时候进行监听处理
//// 1- 重载属性 Getter 和 Setter 方法
///(原理: 被继承的属性是 stored 还是 computed, 子类是不知道的. 子类只知道被继承属性的 name 和 type, 所以在重载时只需要注明属性的名字和类型是正确的)
/// 在子类中, 可以把继承的 只读属性 重载为 getter 和 setter, 但是不可以把读写属性重载成只读属性

class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")

//// 2- 重载属性观察者
//// - 当继承的属性是: 常量存储属性或者只读计算属性时, 不能给继承的属性添加属性观察者

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")


//: Preventing Overrides
/**
 - 你可以将方法、属性或者下标标记成 final, 可以防止方法, 属性或者下标被重写. final var, final func, final class func, final subscript
 - 你可以将类标记为 final, 可以防止其被继承. final class
 - 任何重载 final 修饰的类, 方法, 属性, 或者下标都会被标记为错误
 **/

