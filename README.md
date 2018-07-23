### Dict2ModelDemo
 > Tips: 本文小试牛刀，Demo使用的是官方API来进行JSON与Model之间的转换。
 
#### 目录
* [工具类方法](#Dict_Model)
    * [字典 -> 模型](#Dict_Model)
    * [JSON -> 模型](#JSON_Model)
    * [模型 -> JSON字符串](#Model_JSON)
    * [JSON -> 字典](#JSON_Dict)
    * [JSON -> 字典数组](#JSON_DictArray)
    * [字典 -> JSON](#Dict_JSON)
    * [字典数组 -> JSON](#DictArray_JSON)
* [TIPS](#Tips) 

---
 
 ※ 废话少说，直接上代码 ↓
 ---
#### <a id="Dict_Model"></a>字典 -> 模型
##### 工具类方法
``` swift
/// 字典转模型
func toModel<T>(_ type: T.Type, value: Any?) -> T? where T: Decodable {
    guard let value = value else { return nil }
    return toModel(type, value: value)
}
/// 字典转模型
func toModel<T>(_ type: T.Type, value: Any) -> T? where T : Decodable {
    guard let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }
    let decoder = JSONDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
    return try? decoder.decode(type, from: data)
}
```
##### 栗子
###### 代码
``` swift
var studentDict: Dictionary<String, Any> = ["id": 1, "name": "wangwu", "nick_name": "隔壁王叔叔", "borrow_books": []]
guard let model4student1 = toModel(Student.self, value: studentDict) else { return }
print("[dict -> model]: \(model4student1)")
```
###### 输出
```
[dict -> model]: Student(id: 1, name: "wangwu", nickName: "隔壁王叔叔", books: [])
```
---
#### <a id="JSON_Model"></a>JSON字符串 -> 模型
##### 工具类方法
``` swift
/// JSON字符串转模型
func toModel<T>(_ type: T.Type, value: String?) -> T? where T: Decodable {
    guard let value = value else { return nil }
    return toModel(type, value: value)
}
/// JSON字符串转模型
func toModel<T>(_ type: T.Type, value: String) -> T? where T : Decodable {
    let decoder = JSONDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
    guard let t = try? decoder.decode(T.self, from: value.data(using: .utf8)!) else { return nil }
    return t
}
```
---
#### <a id="Model_JSON"></a>模型 -> JSON字符串
##### 工具类方法
``` swift
/// 模型转JSON字符串
func toJson<T>(_ model: T) -> String? where T : Encodable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let data = try? encoder.encode(model) else { return nil }
    return String(data: data, encoding: .utf8)
}
```
---
#### <a id="JSON_Dict"></a>JSON字符串 -> 字典
##### 工具类方法
``` swift
/// JSON字符串转字典
func dictionaryFrom(jsonString:String) -> Dictionary<String, Any>? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil }
    guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers), let result = dict as? Dictionary<String, Any> else { return nil }
    return result
}
```
---
#### <a id="JSON_DictArray"></a>JSON字符串 -> 数组
##### 工具类方法
``` swift
/// JSON字符串转数组
func arrayFrom(jsonString:String) -> [Dictionary<String, Any>]? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil }
    guard let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers), let result = array as? [Dictionary<String, Any>] else { return nil }
    return result
}
```
---
#### <a id="Dict_JSON"></a>字典 -> JSON字符串
##### 工具类方法
``` swift
/// 字典转JSON字符串
func jsonStringFrom(dict: Dictionary<String, Any>) -> String? {
    if (!JSONSerialization.isValidJSONObject(dict)) {
        print("字符串格式错误！")
        return nil
    }
    guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return nil }
    guard let jsonString = String(data: data, encoding: .utf8) else { return nil }
    return jsonString
}
```

#### <a id="DictArray_JSON"></a>字典数组 -> JSON字符串
##### 工具类方法
``` swift
/// 字典数组转JSON字符串
func jsonStringFrom(array: [Dictionary<String, Any>?]?) -> String? {
    guard let array = array else { return nil }
    var jsonString = "["
    var i = 0
    let count = array.count
    for dict in array {
        guard let dict = dict else { return nil }
        if (!JSONSerialization.isValidJSONObject(dict)) {
            print("字符串格式错误！")
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return nil }
        guard let tmp = String(data: data, encoding: .utf8) else { return nil }
        jsonString.append(tmp)
        if i < count - 1 {
            jsonString.append(",")
        }
        i = i + 1
    }
    jsonString.append("]")
    return jsonString
}
```

#### <a id="Tips"></a>TIPS
* Demo中使用的是结构(Struct)，而不是类(Class)
* 这里没有显示完整的代码，比如模型类，有需要的自行下载
* 如果模型中的字段比字典中多，并且多出的字段不是可选的，转换失败！(为了转换成功，可以将模型中的字段标记成可选的【?】)
* 模型的字段中如果有关键字，需要用 **\`\`** 符号，如：\`if\`
* 可以替换接口返回的字段名，做个映射，如：case nickName = "nick_name"

##### 关于映射
> 作用：自定义有个性的字段名称，不需要局限于后端接口命名。

``` swift
enum CodingKeys: String, CodingKey {
    case id
    case name
    case nickName = "nick_name"   // 左边：自定义字段名  右边：接口返回的字段名
    case books = "borrow_books"
}
```



