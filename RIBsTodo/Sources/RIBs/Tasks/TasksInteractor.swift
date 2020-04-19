//
//  TasksInteractor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift
import ReactorKit

protocol TasksRouting: ViewableRouting {
}

protocol TasksPresentable: Presentable {
  var listener: TasksPresentableListener? { get set }
}

protocol TasksListener: class {
}

struct TasksState {
  var cellReactors: [TaskCellReactor] = []
  var sections: [TasksViewSection] {
    let sectionItems = self.cellReactors
      .map(TasksViewSection.Item.task)
    return [TasksViewSection(identity: .tasks, items: sectionItems)]
  }
}

final class TasksInteractor
  : PresentableInteractor<TasksPresentable>
  , TasksInteractable
  , TasksPresentableListener
  , Reactor {
  
  enum Mutation {
    case set
  }
  
  weak var router: TasksRouting?
  weak var listener: TasksListener?
  
  let initialState: TasksState
  
  override init(presenter: TasksPresentable) {
    defer { _ = self.state }
    let cellReactors = (0...10).map { index in
      return TaskCellReactor(
        task: Task(
          id: UUID().uuidString,
          title: "title\(index)",
          memo: "memo\(index)",
          isChecked: false,
          createdAt: Date(),
          updateAt: Date()
        )
      )
    }
    self.initialState = TasksState(cellReactors: cellReactors)
    super.init(presenter: presenter)
    self.presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func mutate(action: TasksAction) -> Observable<Mutation> {
    return .empty()
  }
  
  func reduce(state: TasksState, mutation: Mutation) -> TasksState {
    var newState = state
    return newState
  }
}
