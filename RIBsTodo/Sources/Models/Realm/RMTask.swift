//
//  RMTask.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RealmSwift

@objcMembers class RMTask: Object {
  
  enum Property: String {
    case id, title, memo, isMarked, createdAt, updateAt
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var title: String = ""
  dynamic var memo: String = ""
  dynamic var isMarked: Bool = false
  dynamic var createdAt: Date = Date()
  dynamic var updateAt: Date = Date()
  
  override static func primaryKey() -> String? {
    return Property.id.rawValue
  }
  
  override class func indexedProperties() -> [String] {
    return [Property.updateAt.rawValue]
  }
}

extension RMTask {
  convenience init(title: String, memo: String) {
    self.init()
    self.title = title
    self.memo = memo
  }
}

extension Task {
  init(_ task: RMTask) {
    self.id = task.id
    self.title = task.title
    self.memo = task.memo
    self.isMarked = task.isMarked
    self.createdAt = task.createdAt
    self.updateAt = task.updateAt
  }
}
