//
//  TaskTable.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RealmSwift

@objcMembers class TaskTable: Object {
  
  enum Property: String {
    case id, title, memo, isChecked, createdAt, updateAt
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var title: String = ""
  dynamic var memo: String = ""
  dynamic var isChecked: Bool = false
  dynamic var createdAt: Date = Date()
  dynamic var updateAt: Date = Date()
  
  override static func primaryKey() -> String? {
    return TaskTable.Property.id.rawValue
  }
  
  override class func indexedProperties() -> [String] {
    return [TaskTable.Property.updateAt.rawValue]
  }
}

extension TaskTable {
  convenience init(title: String, memo: String) {
    self.init()
    self.title = title
    self.memo = memo
  }
}
