//
//  TaskCellReactor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import ReactorKit
import RxSwift

class TaskCellReactor: Reactor, IdentityHashable {
  
  enum Action {
  }
  
  enum Mutation {
  }
  
  struct State {
    var title: String {
      return self.task.title
    }
    var isChecked: Bool {
      return self.task.isChecked
    }
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
