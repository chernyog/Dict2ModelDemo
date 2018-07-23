//
//  Model.swift
//  Dict2ModelDemo
//
//  Created by cheny on 2018/7/13.
//  Copyright © 2018年 cheny. All rights reserved.
//

import UIKit

/**
 TIPS:
 1. 如果模型中的字段比字典中多，并且多出的字段不是可选的，转换失败！
 2. 为了转换成功，可以将模型中的字段标记成可选的【?】
 3. 模型的字段中如果有关键字，需要用``符号，如：`if`
 4. 可以替换接口返回的字段名，做个映射，如：case nickName = "nick_name"
 */

protocol BaseModel: Codable { }

struct Student: BaseModel {
    var id: Int
    var name: String
    var nickName: String
    var books: [Book]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nickName = "nick_name"   // 左边：自定义字段名  右边：接口返回的字段名
        case books = "borrow_books"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(name, forKey: .name)
        try? container.encode(nickName, forKey: .nickName)
        try? container.encode(books, forKey: .books)
    }

    init(id: Int, name: String, nickName: String, books: [Book]) {
        self.id = id
        self.name = name
        self.nickName = nickName
        self.books = books
    }
}

struct Book: BaseModel {
    var id: Int
    var name: String
    var pages: Int
    var delete: Bool?
    var `if`: Float?

    enum CodingKeysEnum: String, CodingKey {
        case id
        case name
        case pages
        case delete
        case `if`
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysEnum.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(name, forKey: .name)
        try? container.encode(pages, forKey: .pages)
        try? container.encode(delete, forKey: .delete)
        try? container.encode(`if`, forKey: .`if`)
    }
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeysEnum.self)

        id = (try? container?.decode(Int.self, forKey: .id) ?? 0) ?? 0
        name = (try? container?.decode(String.self, forKey: .name) ?? "") ?? ""
        pages = (try? container?.decode(Int.self, forKey: .pages) ?? 0) ?? 0
        delete = try? container?.decode(Bool.self, forKey: .delete) ?? false
        `if` = try? container?.decode(Float.self, forKey: .if) ?? 0
    }
    init(id: Int, name: String, pages: Int, delete: Bool, `if`: Float) {
        self.id = id
        self.name = name
        self.pages = pages
        self.delete = delete
        self.if = `if`
    }
}
