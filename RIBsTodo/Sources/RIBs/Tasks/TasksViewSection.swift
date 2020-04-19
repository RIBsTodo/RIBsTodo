//
//  TasksViewSection.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxDataSources

struct TasksViewSection: Equatable {
  enum Identity: String {
    case tasks
  }
  let identity: Identity
  var items: [Item]
}

extension TasksViewSection: AnimatableSectionModelType {
  init(original: TasksViewSection, items: [Item]) {
    self = TasksViewSection(identity: original.identity, items: items)
  }
}

extension TasksViewSection {
  enum Item: Hashable {
    case task(TaskCellReactor)
  }
}

extension TasksViewSection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
