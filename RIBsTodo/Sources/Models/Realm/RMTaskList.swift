//
//  RMTaskList.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RealmSwift

@objcMembers class RMTaskList: Object {
  
  enum Property: String {
    case id, tasks
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var tasks: List<RMTask> = List<RMTask>()
  
  override static func primaryKey() -> String? {
    return Property.id.rawValue
  }
}
