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
    case setTasks([Task])
  }
  
  weak var router: TasksRouting?
  weak var listener: TasksListener?
  
  let initialState: TasksState
  
  private let taskService: TaskServiceProtocol
  
  init(presenter: TasksPresentable, taskService: TaskServiceProtocol) {
    defer { _ = self.state }
    self.taskService = taskService
    self.initialState = TasksState()
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
    switch action {
    case .refresh:
      return self.tasksMutation()
    }
  }
  
  private func tasksMutation() -> Observable<Mutation> {
    return self.taskService.tasks().asObservable()
      .map(Mutation.setTasks)
  }
  
  func reduce(state: TasksState, mutation: Mutation) -> TasksState {
    var newState = state
    switch mutation {
    case let .setTasks(tasks):
      newState.cellReactors = tasks.map(TaskCellReactor.init)
    }
    return newState
  }
}
