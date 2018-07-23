//
//  NSObject+Extension.swift
//  Dict2ModelDemo
//
//  Created by cheny on 2018/7/13.
//  Copyright © 2018年 cheny. All rights reserved.
//

import UIKit

extension NSObject {
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
    /// 模型转JSON字符串
    func toJson<T>(_ model: T) -> String? where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    /// JSON字符串转字典
    func dictionaryFrom(jsonString:String) -> Dictionary<String, Any>? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers), let result = dict as? Dictionary<String, Any> else { return nil }
        return result
    }
    /// JSON字符串转数组
    func arrayFrom(jsonString:String) -> [Dictionary<String, Any>]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        guard let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers), let result = array as? [Dictionary<String, Any>] else { return nil }
        return result
    }
    /// 字典转JSON字符串
    func jsonStringFrom(dict: Dictionary<String, Any>?) -> String? {
        guard let dict = dict else { return nil }
        if (!JSONSerialization.isValidJSONObject(dict)) {
            print("字符串格式错误！")
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return nil }
        guard let jsonString = String(data: data, encoding: .utf8) else { return nil }
        return jsonString
    }
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
}
