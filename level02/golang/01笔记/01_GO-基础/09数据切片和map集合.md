# 数组
数据是具有相同类型的一组已编号且长度固定的数据项序列，这种类型可以是任意的基础数据类型、自定义类型、指针以及其他数据结构。

## 数组声明
```go
// 仅声明，数组本身已经初始化好了，其中的元素的值为类型的零值
var <array name> [<length>]<type>

// 声明以及初始化
var <array name> = [<length>]<type>{<element1>, <element2>,...}
<array name> := [<length>]<type>{<element1>, <element2>,...}

// 可以使用...代替数组长度，编译器会根据初始化时元素个数推断数组长度
var <array name> = [...]<type>{<element1>, <element2>,...}
<array name> := [...]<type>{<element1>, <element2>,...}

//在已指定数组长度的情况下，对指定下标的元素初始化
var <array name> = [<length>]<type>{<position1>:<element value1>, <position2>:<element value2>,...}
<array name> := [<length>]<type>{<position1>:<element value1>, <position2>:<element value2>,...}
```
## 示例
```go
func main() {
    // 仅声明
    var a [5]int
    fmt.Println("a = ", a)

    var marr [2]map[string]string // map[string]string 表示数组中的每个元素都是一个映射，键和值的类型都是 string
    fmt.Println("marr = ", marr)
    // map的零值是nil，虽然打印出来是非空值，但真实的值是nil
    // marr[0]["test"] = "1"

    // 声明以及初始化
    var b [5]int = [5]int{1, 2, 3, 4, 5}
    fmt.Println("b = ", b)

    // 类型推导声明方式
    var c = [5]string{"c1", "c2", "c3", "c4", "c5"}
    fmt.Println("c = ", c)

    d := [3]int{3, 2, 1}
    fmt.Println("d = ", d)

    // 使用 ... 代替数组长度
    autoLen := [...]string{"auto1", "auto2", "auto3"}
    fmt.Println("autoLen = ", autoLen)

    // 声明时初始化指定下标的元素值
    positionInit := [5]string{1: "position1", 3: "position3"}
    fmt.Println("positionInit = ", positionInit)
    
    // 初始化时，元素个数不能超过数组声明的长度
    //overLen := [2]int{1, 2, 3}
}
```
## 遍历数组
```go
func main() {
    a := [5]int{5, 4, 3, 2, 1}

    // 方式1，使用下标读取数据
    element := a[2]
    fmt.Println("element = ", element)

    // 方式2，使用range遍历
    for i, v := range a {
        fmt.Println("index = ", i, "value = ", v)
    }

    for i := range a {
        fmt.Println("only index, index = ", i)
    }

    // 读取数组长度
    fmt.Println("len(a) = ", len(a))
    // 使用下标，for循环遍历数组
    for i := 0; i < len(a); i++ {
        fmt.Println("use len(), index = ", i, "value = ", a[i])
    }
}
```
## 数组作为参数
数组的部分特性类似基础数据类型，当数组作为参数传递时，在函数中并`不能改变外部实参的值`。
如果想要修改外部实参的值，需要把`数组的指针`作为参数传递给函数。
```go
type Custom struct {
    i int
}

var carr [5]*Custom = [5]*Custom{
    {6},
    {7},
    {8},
    {9},
    {10},
}

func main() {
    a := [5]int{5, 4, 3, 2, 1}
    fmt.Println("before all, a = ", a) // 5 4 3 2 1
    for i := range carr {
		// 使用指针获取数据 &carr[i]获取指针地址  *carr[i]获取指针指向的值
        fmt.Printf("in main func, carr[%d] = %p, value = %v \n", i, &carr[i], *carr[i])
    }
    printFuncParamPointer(carr) // 这里修改了carr的值，因为是指针传递，所以会改变carr的值

    receiveArray(a) // 这里修改了a的值，但是因为是值传递，所以不会改变a的值
    fmt.Println("after receiveArray, a = ", a) // [5 4 3 2 1]

    receiveArrayPointer(&a) // 这里修改了a的值，因为是指针传递，所以会改变a的值
    fmt.Println("after receiveArrayPointer, a = ", a) // [5 -5 3 2 1]
}

func receiveArray(param [5]int) {
    fmt.Println("in receiveArray func, before modify, param = ", param) // 5 4 3 2 1
    param[1] = -5
    fmt.Println("in receiveArray func, after modify, param = ", param) // 5 -5 3 2 1
}

func receiveArrayPointer(param *[5]int) {
    fmt.Println("in receiveArrayPointer func, before modify, param = ", param) // &[5 4 3 2 1]
    param[1] = -5
    fmt.Println("in receiveArrayPointer func, after modify, param = ", param) // &[5 -5 3 2 1]
}

/**
 * 指针参数
 */
func printFuncParamPointer(param [5]*Custom) {
    for i := range param {
        fmt.Printf("in printFuncParamPointer func, param[%d] = %p, value = %v \n", i, &param[i], *param[i])
    }
}
```

# 切片
切片(Slice)并不是数组或者数组指针，而是数组的一个引用，
切片本身是一个标准库中实现的一个特殊的结构体，这个结构体中有三个属性，分别代表数组指针、长度、容量。

src/runtime/slice.go
```go
type slice struct {
    array unsafe.Pointer
    len   int
    cap   int
}
```
## 切片的声明
```go
// 方式1，声明并初始化一个空的切片
var s1 []int = []int{}

// 方式2，类型推导，并初始化一个空的切片
var s2 = []int{}

// 方式3，与方式2等价
s3 := []int{}

// 方式4，与方式1、2、3 等价，可以在大括号中定义切片初始元素
s4 := []int{1, 2, 3, 4}

// 方式5，用make()函数创建切片，创建[]int类型的切片，指定切片初始长度为0
s5 := make([]int, 0)

// 方式6，用make()函数创建切片，创建[]int类型的切片，指定切片初始长度为2，指定容量参数4
s6 := make([]int, 2, 4) 

// 方式7，引用一个数组，初始化切片
a := [5]int{6,5,4,3,2}
// 从数组下标2开始，直到数组的最后一个元素
s7 := arr[2:]
// 从数组下标1开始，直到数组下标3的元素，创建一个新的切片
s8 := arr[1:3]
// 从0到下标2的元素，创建一个新的切片
s9 := arr[:2]
```
## 数组与切片的区别
|特征 | 数组(Array) | 切片(Slice) |
|:---|:----------:|:----------: |
|长度固定|是|否|
|容量固定|是|否|
|元素类型固定|是|否|

**当切片是基于同一个数组指针创建出来时，修改数组中的值时，同样会影响到这些切片。**

```go
func main() {
    a := [5]int{6, 5, 4, 3, 2}
    // 从数组下标2开始，直到数组的最后一个元素
    s7 := a[2:]
    // 从数组下标1开始，直到数组下标3的元素，创建一个新的切片
    s8 := a[1:3] // 6 5 4 ,  左闭右开原则
    // 从0到下标2的元素，创建一个新的切片
    s9 := a[:2]
    fmt.Println(s7)
    fmt.Println(s8)
    fmt.Println(s9)
    a[0] = 9
    a[1] = 8
    a[2] = 7
    fmt.Println(s7)
    fmt.Println(s8)
    fmt.Println(s9)
}
```
## 切片的访问
访问切片中的元素，与访问数组一样使用下标访问切片, 可以指定位置赋值, range 遍历等

切片还可以使用 `len()` 和 `cap()` 函数访问切片的长度和容量。
- 长度: 切片的长度是指切片中元素的个数，使用 `len()` 函数可以获取切片的长度。
- 容量: 切片的容量是指切片底层数组的长度，使用 `cap()` 函数可以获取切片的容量。

切片是 nil 时，`len()` 和 `cap()` 函数获取的到值都是 0。

## 切片添加元素
append() 函数可以向切片中添加元素，返回一个新的切片。
```go
s3 := []int{}
fmt.Println("s3 = ", s3)

// append函数追加元素
s3 = append(s3)
s3 = append(s3, 1)
s3 = append(s3, 2, 3)
fmt.Println("s3 = ", s3)


// 向指定位置添加元素
s4 := []int{1, 2, 4, 5} // 初始切片：[1, 2, 4, 5]
s4 = append(s4[:2], append([]int{3}, s4[2:]...)...)
/*
内层 append([]int{3}, s4[2:]...)：
    先创建一个临时切片 []int{3}，然后将 s4[2:]（即 [4,5]）追加到这个临时切片后，得到 [3,4,5]。
外层 append(s4[:2], ...)：
    再将 s4[:2]（即 [1,2] 左闭右开原则, 不包含索引 2）与上一步得到的 [3,4,5] 合并，最终得到 [1,2,3,4,5]。
*/
fmt.Println("s4 = ", s4) // 输出：s4 =  [1 2 3 4 5]

// 移除指定位置的元素
s5 := []int{1,2,3,5,4}
s5 = append(s5[:3], s5[4:]...)
/*
s5[:3]：截取切片 s5 的前 3 个元素（索引 0、1、2），结果为 [1, 2, 3]。
s5[4:]：从索引 4 开始截取到末尾，结果为 [4]（因为原切片长度为 5，索引 4 是最后一个元素）。
append(...)：将两部分子切片合并，得到新切片 [1, 2, 3, 4]。
*/

fmt.Println("s5 = ", s5)
```

## 复制切片
可以使用内置函数 `copy()` 把某个切片中的所有元素复制到另一个切片，复制的长度是它们中最短的切片长度。
```go
src1 := []int{1, 2, 3}
dst1 := make([]int, 4, 5) // 长度为4，容量为5的切片

src2 := []int{1, 2, 3, 4, 5}
dst2 := make([]int, 3, 3) // 长度为3，容量为3的切片

fmt.Println("before copy, src1 = ", src1) // src1 =  [1 2 3]
fmt.Println("before copy, dst1 = ", dst1) // dst1 =  [0 0 0 0]

fmt.Println("before copy, src2 = ", src2) // src2 =  [1 2 3 4 5]
fmt.Println("before copy, dst2 = ", dst2) // dst2 =  [0 0 0]

copy(dst1, src1) // copy(dst, src) 复制src中的元素到dst中，返回值为复制的元素个数
copy(dst2, src2)

fmt.Println("before copy, src1 = ", src1) // src1 =  [1 2 3]
fmt.Println("before copy, dst1 = ", dst1) // dst1 =  [1 2 3 0]

fmt.Println("before copy, src2 = ", src2) // src2 =  [1 2 3 4 5]
fmt.Println("before copy, dst2 = ", dst2) // dst2 =  [1 2 3]
```

# map集合
在 Go 中，map 集合是无序的键值对集合。相比切片和数组，map 集合对索引的自定义程度更高，可以使用任意类型作为索引，也可以存储任意类型的数据。
```go
// 声明 
// 方式一
var <map name> map[<key type>]<value type>

// 方式二 使用内置函数 make() 初始化
<map name> := make(map[<key type>]<value type>)
// 还可以使用map，提前指定容量
<map name> := make(map[<key type>]<value type>, <capacity>)

// 方式三 在初始化时，同时插入键值对
// 不会插入任何键值对
<map name> := map[<key type>]<value type> {}

// 插入键值对
<map name> := map[<key type>]<value type> {
    <key1>: <value1>,
    <key2>: <value2>,
    ...
}

// 示例
func main() {
    var m1 map[string]string
    fmt.Println("m1 length:", len(m1))

    m2 := make(map[string]string)
    fmt.Println("m2 length:", len(m2))
    fmt.Println("m2 =", m2)

    m3 := make(map[string]string, 10)
    fmt.Println("m3 length:", len(m3))
    fmt.Println("m3 =", m3)

    m4 := map[string]string{}
    fmt.Println("m4 length:", len(m4))
    fmt.Println("m4 =", m4)

    m5 := map[string]string{
        "key1": "value1",
        "key2": "value2",
    }
    fmt.Println("m5 length:", len(m5))
    fmt.Println("m5 =", m5)
}
```

## 使用map集合
- 元算访问
```go
<value> := <map name>[<key>]

<value>,<exist flag> := <map name>[<key>]
```
- 插入或修改值
```go
<map name>[<key>] = <value>
```
- 遍历
```go
for <key name>, <value name> := range <map name> {
    <expression>
    ...
}

for <key name> := range <map name> {
    <expression>
    ...
}
// 通过内置函数 len() 获取 map 中键值对数量：
length := len(<map name>)
```
- 删除元素
```go
delete(<map name>, <key>)
```
### 代码示例
```go
func main() {
    m := make(map[string]int, 10)

    m["1"] = int(1)
    m["2"] = int(2)
    m["3"] = int(3)
    m["4"] = int(4)
    m["5"] = int(5)
    m["6"] = int(6)

    // 获取元素
    value1 := m["1"]
    fmt.Println("m[\"1\"] =", value1)

    value1, exist := m["1"]
    fmt.Println("m[\"1\"] =", value1, ", exist =", exist)

    valueUnexist, exist := m["10"]
    fmt.Println("m[\"10\"] =", valueUnexist, ", exist =", exist)

    // 修改值
    fmt.Println("before modify, m[\"2\"] =", m["2"])
    m["2"] = 20
    fmt.Println("after modify, m[\"2\"] =", m["2"])

    // 获取map的长度
    fmt.Println("before add, len(m) =", len(m))
    m["10"] = 10
    fmt.Println("after add, len(m) =", len(m))

    // 遍历map集合main
    for key, value := range m {
        fmt.Println("iterate map, m[", key, "] =", value)
    }

    // 使用内置函数删除指定的key
    _, exist_10 := m["10"]
    fmt.Println("before delete, exist 10: ", exist_10)
    delete(m, "10")
    _, exist_10 = m["10"]
    fmt.Println("after delete, exist 10: ", exist_10)

    // 在遍历时，删除map中的key
    for key := range m {
        fmt.Println("iterate map, will delete key:", key)
        delete(m, key)
    }
    fmt.Println("m = ", m)
}
```
**当 map 集合会被并发访问时，需要在使用 map 集合时，添加互斥锁**
```go
func main() {
    m := make(map[string]int)
    var lock sync.Mutex

    go func() {
        for {
            lock.Lock()
            m["a"]++
            lock.Unlock()
        }
    }()

    go func() {
        for {
            lock.Lock()
            m["a"]++
            fmt.Println(m["a"])
            lock.Unlock()
        }
    }()

    select {
    case <-time.After(time.Second * 5):
        fmt.Println("timeout, stopping")
    }
}
// 也可以使用 Go 标准库中的实现 sync.Map，但是 sync.Map 适用于读多写少的场景，并且内存开销会比普通的 map 集合更大。所以碰到这种情况，更推荐使用普通的互斥锁来保证 map 集合的并发读写的线程安全性。
```


