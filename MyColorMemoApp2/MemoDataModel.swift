//
//  MemoDataModel.swift
//  MyColorMemoApp2
//
//  Created by 米谷裕輝 on 2021/11/25.
//

import Foundation
import RealmSwift

class MemoDataModel:Object{
    @objc dynamic var id:String = UUID().uuidString
    @objc dynamic var text:String = ""
    @objc dynamic var recordDate:Date = Date()
}
