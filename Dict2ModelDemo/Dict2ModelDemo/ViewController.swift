//
//  ViewController.swift
//  Dict2ModelDemo
//
//  Created by cheny on 2018/7/13.
//  Copyright © 2018年 cheny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        test()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test()
    }

    func test() {
        let bookStr = """
                    {
                        "id": 1,
                        "name": "《iOS从入门到放弃》",
                        "pages": 1,
                        "if": 0.5
                    }
                    """
        let bookDict1 = dictionaryFrom(jsonString: bookStr)
        guard let model4book1 = toModel(Book.self, value: bookDict1) else { return }
        print("[dict -> model]: \(model4book1)")
        guard let model4book2 = toModel(Book.self, value: bookStr) else { return }
        print("[json -> model]: \(model4book2)")
        let bookDict2: Dictionary<String, Any> = ["id": 2, "name": "《活着》", "pages": 2, "delete": true, "if": 2.5]
        guard let model4book3 = toModel(Book.self, value: bookDict2) else { return }
        print("[dict -> model]: \(model4book3)")
        let bookJsonStr = toJson(model4book1) ?? ""
        print("[model -> json]: \(bookJsonStr)")
        print("")
        let bookStrList = "[{\"id\": 3, \"name\": \"《Python宝典》\", \"pages\": 66, \"if\": 10.5}, {\"id\": 4, \"name\": \"《Java从入门到出家》\", \"pages\": 99, \"if\": 5.5}]"
        let bookDictList = arrayFrom(jsonString: bookStrList)
        guard let model4bookList = toModel([Book].self, value: bookDictList) else { return }
        print("[dictList -> modelList]: \(model4bookList)")
        print("")
        print("***********************************************************************************")
        print("")
        var studentDict: Dictionary<String, Any> = ["id": 1, "name": "wangwu", "nick_name": "隔壁王叔叔", "borrow_books": []]
        guard let model4student1 = toModel(Student.self, value: studentDict) else { return }
        print("[dict -> model]: \(model4student1)")
        studentDict["borrow_books"] = [bookDict1, bookDict2]
        guard let model4student2 = toModel(Student.self, value: studentDict) else { return }
        print("[dict -> model]: \(model4student2)")
        let studentJsonStr = toJson(model4student2) ?? ""
        print("[model -> json]: \(studentJsonStr)")
        let bookJsonStr1 = jsonStringFrom(dict: bookDict1)
        print("[dict -> json]: \(bookJsonStr1 ?? "")")
        let bookJsonStr2 = jsonStringFrom(array: [bookDict1, bookDict2])
        print("[dictArray -> json]: \(bookJsonStr2 ?? "")")
    }
}
