//
//  TaskCellReactor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import ReactorKit
import RxSwift

class TaskCellReactor: Reactor {
  enum Action {
  }
  
  enum Mutation {
  }
  
  struct State {
    var title: String { self.task.title }
    var isMarked: Bool { self.task.isMarked }
    fileprivate var task: Task
  }
  
  var task: Task {
    return self.currentState.task
  }
  
  let initialState: State
  
  init(task: Task) {
    self.initialState = State(task: task)
  }
}

extension TaskCellReactor: Hashable {
  static func == (lhs: TaskCellReactor, rhs: TaskCellReactor) -> Bool {
    return lhs.task == rhs.task
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.task)
  }
}
