# 接口
在 Go 语言中，`接口（interface）` 是一种抽象类型，它定义了一组方法签名（方法名、参数、返回值），但不包含方法的实现。接口的核心作用是规定 “行为契约”，任何类型只要实现了接口中声明的所有方法，就被视为 “实现了该接口”，从而可以通过接口类型的变量来统一操作这些类型的实例。

## 接口声明
```go
// 定义一个接口，包含一组方法签名
type 接口名 interface {
    方法名1(参数列表) 返回值列表
    方法名2(参数列表) 返回值列表
    // ... 更多方法
}
```
示例: 定义一个 Animal 接口，要求实现 “叫” 和 “跑” 的行为：
```go
type Animal interface {
    Speak() string  // 方法签名：返回动物的叫声
    Run() string    // 方法签名：返回跑步的描述
}
```

## 接口的隐式实现
Go 中接口的实现是隐式的（无需显式声明 implements 关键字），这是它与其他语言（如 Java）的重要区别。
只要一个类型（结构体、自定义类型等）`实现了接口中所有方法，就默认实现了该接口`。

示例：Dog 和 Cat 结构体实现 Animal 接口：
```go
// Dog 结构体
type Dog struct{}

// 实现 Animal 接口的 Speak 方法
func (d Dog) Speak() string {
    return "汪汪汪"
}

// 实现 Animal 接口的 Run 方法
func (d Dog) Run() string {
    return "狗跑得很快"
}

// Cat 结构体
type Cat struct{}

// 实现 Animal 接口的 Speak 方法
func (c Cat) Speak() string {
    return "喵喵喵"
}

// 实现 Animal 接口的 Run 方法
func (c Cat) Run() string {
    return "猫跑得很轻"
}

// 此时，Dog 和 Cat 都被视为实现了 Animal 接口，可直接赋值给 Animal 类型的变量。
```

## 多态
接口的核心价值在于多态：通过接口类型的变量，可以统一调用不同实现类型的方法，而无需关心具体类型。

示例：用 Animal 接口统一处理 Dog 和 Cat：
```go
func main() {
    // 接口类型变量可以接收所有实现了该接口的类型
    var animal Animal

    animal = Dog{}  // 赋值 Dog 实例
    fmt.Println(animal.Speak())  // 输出：汪汪汪
    fmt.Println(animal.Run())    // 输出：狗跑得很快

    animal = Cat{}  // 赋值 Cat 实例
    fmt.Println(animal.Speak())  // 输出：喵喵喵
    fmt.Println(animal.Run())    // 输出：猫跑得很轻
}
```

## 接口的分类
- 非空接口(有方法的接口)
    即包含至少一个方法的接口（如上面的 Animal），用于约束类型的行为。
- 空接口
    不包含任何方法的接口（interface{}），它是`所有类型的隐式实现`（因为任何类型都不需要额外实现方法）。
    空接口可以存储任意类型的值，常用于需要 “通用类型” 的场景（如函数参数接受任意类型）。
```go
// 空接口作为函数参数，可接收任何类型
func printAny(v interface{}) {
    fmt.Println(v)
}

func main() {
    printAny(123)      // 输出：123（int）
    printAny("hello")  // 输出：hello（string）
    printAny(Dog{})    // 输出：{}（Dog 结构体）
}
```

## 获取接口存储的具体类型
接口变量存储的是 “实现类型的实例”，但接口本身是抽象的。若需要获取其底层的具体类型和值，需使用`类型断言`
```go
// 语法：value, ok := 接口变量.(具体类型)
// ok 为 true 表示断言成功，value 是具体类型的值；否则断言失败

func checkType(animal Animal) {
    // 断言 animal 是否为 Dog 类型
    if dog, ok := animal.(Dog); ok {
        fmt.Println("这是狗：", dog)
    } else if cat, ok := animal.(Cat); ok {  // 断言是否为 Cat 类型
        fmt.Println("这是猫：", cat)
    }
}

func main() {
    checkType(Dog{})  // 输出：这是狗：{}
    checkType(Cat{})  // 输出：这是猫：{}
}
```
需要判断多种类型可以使用`switch`配合类型断言
```go
func checkTypeSwitch(animal Animal) {
    switch v := animal.(type) {
    case Dog:
        fmt.Println("Dog 类型：", v)
    case Cat:
        fmt.Println("Cat 类型：", v)
    default:
        fmt.Println("未知类型：", v)
    }
}
```

## 接口的 "nil" 注意事项
接口变量的底层由两部分组成：动态类型（存储的具体类型）和动态值（存储的具体值）。
- 当接口的动态类型和动态值都为 `nil` 时，接口才是真正的 `nil`
- 若接口的动态类型不为 `nil`，但动态值为 `nil`（如指向 `nil` 的指针），则接口本身不为 `nil`。
```go
type MyInterface interface {
    Do()
}

type MyStruct struct{}

func (m *MyStruct) Do() {}  // 指针接收者实现接口

func main() {
    var s *MyStruct  // s 是 nil 指针（动态值为 nil，类型为 *MyStruct）
    var i MyInterface = s   // 接口 i 的动态类型是 *MyStruct，动态值是 nil

    fmt.Println(s == nil)   // 输出：true（s 本身是 nil）
    fmt.Println(i == nil)   // 输出：false（接口 i 的类型不为 nil）
}
```