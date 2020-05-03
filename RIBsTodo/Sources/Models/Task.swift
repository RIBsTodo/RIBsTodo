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
  var isMarked: Bool
  var createdAt: Date
  var updateAt: Date
}

extension Task {
  enum Event {
    case update(Task)
    case create(Task)
    case delete(id: String)
    case move(id: String, destinationIndex: Int)
    case mark(id: String)
    case unmark(id: String)
  }
}
