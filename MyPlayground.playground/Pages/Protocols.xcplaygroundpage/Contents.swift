//: [Previous](@previous)

import Foundation

var str = "Hello, Protocols!"

//: Document address: https://docs.swift.org/swift-book/LanguageGuide/Protocols.html

//: [Next](@next)

//: Protocol定义: 定义方法或者属性的计划, 定义适合特殊任务和功能块的要求.
//:      使用对象: 类, 结构体, 枚举

//: 1 - Property Requirements (必要属性)
///: 必要属性表示提供的实例属性和类型属性在遵循协议的地方必须实现
///: 都是变量, 以 var 声明
///: 两种形式: 1. Gettable and Settable -> { get set } 2.  Gettable -> { get }
///: 提供默认的属性实现, 每个遵循这个协议的类型必须添加改默认属性实现
protocol SomeProtocol {
    var mustBeSettable: Int { get set } /// 让遵循该协议的类型去实现对应的的 get set 方法
    var doesNotNeedToBeSettable: Int { get }
}

//: - 使用 static 关键字声明 type property
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let john = Person(fullName: "John Appleseed")

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String?) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var ncc = Starship(name: "Enterprise", prefix: "USS")


//: 2 - Method Requirements (必要方法)
///: 为遵循者提供默认的方法声明
protocol SomeMethodProtocol {
    static func someTypeMethod() // type method requirement
}

protocol RandomNumberGenerator {
    func random() -> Double // instance method requirement
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")

//: 3 - Mutating Method Requirements (可变必要方法)
///: 功能: 修改方法中的实例. 对值类型(value type)的实例方法, 可以修改该实例, 并且可以修改实例的属性
///: 声明方法时用 `mutating`, 如果该协议被某个类遵守, 在该类中, 可以不写 `mutating` 关键字, `mutating` 只能作用于 structure 和 enumeration, 使用在泪中无效

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()

//: 4 - Initializer Requirements (必要初始化方法)
protocol InitializerProtocol {
    init(someParasmeter: Int) /// 不需要 body
}

///: - 必要初始化协议在类中的实现
///: - 在类中遵循该协议, 实现 init 方法时, 可以作为 designated initializer 或者 convenience initializer, 不管是哪种方法, 都需要前缀 `required` 关键字声明
///: required 关键字可以保证在子类中都可以遵循该协议的实现
///: 如果一个类中使用了 `final` 修饰符, 就不要是使用 `required`, 因为 final class 不能被子类化

class Someclass: InitializerProtocol {
    required init(someParasmeter: Int) {
        // initializer implementation goes here
    }
}

///: 如果一个子类从父类中重载了一个 designated initializer, 并且从 Initializer Requirements 实现了初始化方法, 那么在该子类中的初始化方法中需要标记 `required` 和 `override`
protocol InitializerProtocol2 {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, InitializerProtocol2 {
    // "required" from InitializerProtocol2 conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

//: 5 - Protocols as Types (协议作为属性)
/**
  - 可以在函数, 方法, 和初始化作为参数和返回值
  - 可以做为 constant, variable 和 property 的 类型
  - 可以作为容器类元素的类型
**/

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator // generator 的值可以是: 任何遵循 RandomNumberGenerator 协议的类型实例
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}


//: 6 - Delegation
/**
 : 定义: 代理是一种设计模式, 允许一个类或者结构体去转换它的一部分功能到另外一个类型实例处理. 这种设计模式通过定义协议来实现, 此时协议封装的是需要被代理的功能
 : 使用时请用 weak 修饰, 避免循环引用
 **/

protocol DiceGame {
    var dice: Dice { get }
    func play() ///: 所有游戏的逻辑移到了这个方法中
}

/**
 提供三个方法来跟踪游戏的进度
 **/
protocol DiceGameDelegate: AnyObject {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

///: 摆梯子的游戏
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    
    weak var delegate: DiceGameDelegate?
    
    func play() {
        square = 0
        // 1. start game
        delegate?.gameDidStart(self)
        
        // 2. loop game
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
                
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
                
            default:
                square += diceRoll
                square += board[square]
            }
        }
        // 3. end game
        delegate?.gameDidEnd(self)
    }
}


/**
 实现 DiceGameDelegate
 **/
class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()

//: 7 - 添加符合扩展的协议 (Adding Protocol Conformance with an Extension)

protocol TextRepresentable {
    var textualDescription: String { get }
}
///: 扩展协议时,在扩展中当一致性被添加到实例的类型时, 该类型的现有实例们会自动采用并遵循协议. Dice 的实例都采用和遵循协议 TextRepresentable
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)

extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

/**
 有条件的遵循协议(Conditionally Conforming to a Protocol)
 Array 遵循 TextRepresentable 协议, 前提条件是 Array 中的元素也必须遵循 TextRepresentable
 **/
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" +  itemsAsText.joined(separator: ", ") + "]"
    }
}

let myDice = [d6, d12]
print(myDice.textualDescription)

/**
 用扩展声明协议的采用(Declaring Protocol Adoption with an Extension)
- 实现了协议中的所有要求
- 只是没有声明该协议 (也可以理解没有与协议建立一个联系)
- 使用空的 extension 来声明协议的采用
 **/
struct Hamster {
    var name: String
    // 实现了协议 TextRepresentable 的要求
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
print(simonTheHamster.textualDescription)
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)



//: 8 - 协议类型集合 (Collections of Protocol Types)

let things: [TextRepresentable] = [game, d12, simonTheHamster]
///:  thing 都是 TextRepresentable 类型, 而不是 Dice, DiceGame... 尽管背后真实的类型是它们
for thing in things {
    print(thing.textualDescription)
}

//: 9 - 协议继承 (Protocol Inheritance)
/**
 - 可以继承一个或者多个
 - 遵循子协议所有要求之前, 必须遵循父协议的所有要求
 **/
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

struct Name: PrettyTextRepresentable {
    var name: String = ""
    
    var prettyTextualDescription: String {
        return "parentName:\(name)"
    }
    // 一定要实现父协议中的所有必要要求
    var textualDescription: String {
        return "Name:\(name)"
    }
}

let bob = Name(name: "Bob")
bob.prettyTextualDescription
bob.textualDescription

//: 10 - 类协议 (Class-Only Protocols)
/**
 我们可以限制协议只能被类类型采用, 而不被 枚举和结构体采用, 通过添加 `AnyObject` 来限制
 **/
protocol ClassOnlyProtocol: AnyObject {
    // class-only protocol definition goes here
}

//: 11 - 协议合成 (Protocol Composition)
/**
 - 当我们同时遵循多个协议的时候, 会存在多个协议要求, 通过协议合成, 我们可以把多个协议要求合成为一个单独要求.
 - 协议合成类似建立一个临时的协议, 这个协议结合其他所有协议的属性, 本质上协议合成没有定义新的协议类型
 - 形式: protocol1 & protocol2
 - 协议合成中除了协议类型之外, 还可以包含一个类类型, 这个类类型用来制定该类的父类 (required class)
 **/
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person2: Named, Aged {
    var name: String
    var age: Int
}

/// 这里的类型是 Named & Aged, 意思是“任何同时遵循 Named 协议和 Aged 协议的类型”
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person2(name: "YuYi", age: 25)
wishHappyBirthday(to: birthdayPerson)

class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

/// 这里的类型是 Named & Location, 意思是“任何同时遵循 Named 协议和继承 Location 的子类的类型”
func beginContert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginContert(in: seattle)


//: 12 - 检查协议一致性 (Checking for Protocol Conformance)
/**
 - `is`: 返回 true 表示遵循对应协议, 否则表示不遵循
 - `as?`: 值为 nil 表示没有遵循对应协议
 - `as!`: 强制转换类型为协议类型, 如果转换不成功, 会发生运行时错误
 **/

protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius } // as Computed property
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area } // as Stored property
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}

//: 13 - 可选协议要求 (Optional Protocol Requirements)
/**
  - 可选要求 可以不实现
  - 以 `optional` 修饰
  - 与 Objective-C 交互 (增加 @objc 修饰), 前提是只有类类型, 不能是枚举类型和结构体类型
 **/
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

// implement optional property
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

// implement optional method
class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}


//: 14 - 协议扩展 (Protocol Extensions)
/**
 协议可以为遵循的类型扩展: 方法, 初始化器, 下标方法, 计算属性
 好处: 可以在协议本身上定义行为(之前都是协议提供规范, 遵循者去执行), 而不是每种类型的单独一致性或全局函数中定义行为
 协议扩展不能从另外一个协议继承. 注: 协议继承总是在协议声明本身处指定
 提供默认实现, 如果遵循类型实现了协议方法的自身实现, 该实现将会代替在扩展中的的默认实现
 可以为**协议属性**添加条件约束
 **/

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

let generator1 = LinearCongruentialGenerator()
print("Here's a random number: \(generator1.random())")
print("And here's a random Boolean: \(generator1.randomBool())")

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]

print(equalNumbers.allEqual())
print(differentNumbers.allEqual())

