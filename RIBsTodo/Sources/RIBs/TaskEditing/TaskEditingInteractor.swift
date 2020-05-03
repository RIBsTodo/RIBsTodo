//
//  TaskEditingInteractor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import ReactorKit
import RxCocoa
import RxSwift

enum TaskEditingViewMode {
  case new
  case edit(Task)
}

enum TaskEditingViewCancelAlertAction: AlertActionType {
  case leave
  case stay
  
  var title: String? {
    switch self {
    case .leave: return "Leave"
    case .stay: return "Stay"
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
    case .leave: return .destructive
    case .stay: return .default
    }
  }
}

protocol TaskEditingRouting: ViewableRouting {
}

protocol TaskEditingPresentable: Presentable {
  var listener: TaskEditingPresentableListener? { get set }
}

protocol TaskEditingListener: class {
  func taskEditingDidFinish()
}

struct TaskEditingViewState {
  var title: String
  var taskTitle: String
  var canSubmit: Bool
  var shouldConfirmCancel: Bool

  init(title: String, taskTitle: String, canSubmit: Bool) {
    self.title = title
    self.taskTitle = taskTitle
    self.canSubmit = canSubmit
    self.shouldConfirmCancel = false
  }
}

final class TaskEditingInteractor
  : PresentableInteractor<TaskEditingPresentable>
  , TaskEditingInteractable
  , TaskEditingPresentableListener
  , Reactor {
  
  typealias State = TaskEditingViewState
  typealias Action = TaskEditingViewAction
  
  enum Mutation {
    case updateTaskTitle(String)
  }
  
  weak var router: TaskEditingRouting?
  weak var listener: TaskEditingListener?
  
  private let taskService: TaskServiceProtocol
  private let alertService: AlertServiceProtocol
  private let mode: TaskEditingViewMode
  
  let initialState: State
  
  init(
    presenter: TaskEditingPresentable,
    mode: TaskEditingViewMode,
    taskService: TaskServiceProtocol,
    alertService: AlertServiceProtocol
  ) {
    
    self.mode = mode
    self.taskService = taskService
    self.alertService = alertService

    switch mode {
    case .new:
      self.initialState = State(
        title: "New",
        taskTitle: "",
        canSubmit: false
      )
    case .edit(let task):
      self.initialState = State(
        title: "Edit",
        taskTitle: task.title,
        canSubmit: true
      )
    }
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateTaskTitle(taskTitle):
      return .just(.updateTaskTitle(taskTitle))
      
    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      return self.submitMutation(mode: mode)
      
    case .cancel:
      return self.cancelMutation()
    }
  }
  
  private func submitMutation(mode: TaskEditingViewMode) -> Observable<Mutation> {
    switch self.mode {
    case .new:
      return self.newMutation()
      
    case let .edit(task):
      return editMutation(task: task)
    }
  }
  
  private func newMutation() -> Observable<Mutation> {
    return self.taskService
      .create(title: self.currentState.taskTitle, memo: "")
      .asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in
        self?.listener?.taskEditingDidFinish()
      })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func editMutation(task: Task) -> Observable<Mutation> {
    return self.taskService
      .update(id: task.id, title: self.currentState.taskTitle, memo: "")
      .asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.listener?.taskEditingDidFinish() })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func cancelMutation() -> Observable<Mutation> {
    if !self.currentState.shouldConfirmCancel {
      return Observable.just(())
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.listener?.taskEditingDidFinish() })
      .flatMap { _ -> Observable<Mutation> in .empty() }
    }
    let alertActions: [TaskEditingViewCancelAlertAction] = [.leave, .stay]
    return self.alertService
      .show(
        title: "Really?",
        message: "All changes will be lost",
        preferredStyle: .alert,
        actions: alertActions
      )
      .observeOn(MainScheduler.instance)
      .do(onNext: { alertAction in
        switch alertAction {
        case .leave:
          self.listener?.taskEditingDidFinish()

        case .stay:
          break
        }
      })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .updateTaskTitle(taskTitle):
      newState.taskTitle = taskTitle
      newState.canSubmit = !taskTitle.isEmpty
      newState.shouldConfirmCancel = taskTitle != self.initialState.taskTitle
      return newState
    }
  }
}
