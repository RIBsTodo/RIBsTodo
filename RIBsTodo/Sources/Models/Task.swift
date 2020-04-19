//
//  Task.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Foundation

struct Task: Hashable {
  var id: String
  var title: String
  var memo: String
  var isChecked: Bool
  var createdAt: Date
  var updateAt: Date
}

extension Task {
  enum Event {
  }
}

extension Task {
  init(_ table: TaskTable) {
    self.id = table.id
    self.title = table.title
    self.memo = table.memo
    self.isChecked = table.isChecked
    self.createdAt = table.createdAt
    self.updateAt = table.updateAt
  }
}
