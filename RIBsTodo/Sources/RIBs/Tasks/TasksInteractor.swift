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
import RealmSwift

protocol TasksRouting: ViewableRouting {
  func routeToTaskEditing(mode: TaskEditingViewMode)
  func closeTaskEditing()
}

protocol TasksPresentable: Presentable {
  var listener: TasksPresentableListener? { get set }
}

protocol TasksListener: class {
}

struct TasksViewState {
  var isLoading: Bool = false
  var isEditing: Bool = false
  
  var tasks: [Task] = []
  var sections: [TasksViewSection] {
    let sectionItems = tasks
      .map(TaskCellReactor.init)
      .map(TasksViewSection.Item.task)
    
    return [TasksViewSection(identity: .tasks, items: sectionItems)]
  }
}

final class TasksInteractor
  : PresentableInteractor<TasksPresentable>
  , TasksInteractable
  , TasksPresentableListener
  , Reactor {
  
  let scheduler = SerialDispatchQueueScheduler(qos: .background)
  
  typealias State = TasksViewState
  typealias Action = TasksViewAction
  
  enum Mutation {
    case setLoading(Bool)
    case setTasks([Task])
    case toggleEditing
    case createTask(Task)
    case deleteTask(index: Int)
    case updateTask(index: Int, Task)
    case moveTask(from: Int, to: Int)
  }
  
  weak var router: TasksRouting?
  weak var listener: TasksListener?
  
  let initialState: State
  
  private let taskService: TaskServiceProtocol
  
  init(presenter: TasksPresentable, taskService: TaskServiceProtocol) {
    defer { _ = self.state }
    self.taskService = taskService
    self.initialState = State()
    super.init(presenter: presenter)
    self.presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return Observable.concat([
        Observable.just(.setLoading(true)),
        self.tasksMutation(),
        Observable.just(.setLoading(false))
      ])
      
    case .toggleEditing:
      return .just(.toggleEditing)
      
    case let .toggleTaskDone(indexPath):
      return self.toggleTaskDoneMutation(indexPath: indexPath)
      
    case let .deleteTask(indexPath):
      return self.deleteTaskMutation(indexPath: indexPath)
      
    case let .moveTask(sourceIndexPath, destinationIndexPath):
      return self.moveTask(
        sourceIndexPath: sourceIndexPath,
        destinationIndexPath: destinationIndexPath
      )
    case .addTask:
      return self.addTaskMutation()
      
    case let .editTask(indexPath):
      return self.editTaskMutation(indexPath: indexPath)
    }
  }
  
  private func editTaskMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    return Observable.just(task)
    .observeOn(MainScheduler.instance)
    .do(onNext: { [weak self] task in
      self?.router?.routeToTaskEditing(mode: .edit(task))
    })
    .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func addTaskMutation() -> Observable<Mutation> {
    return Observable.just(Void())
      .observeOn(MainScheduler.instance)
      .do(onNext: { [weak self] _ in self?.router?.routeToTaskEditing(mode: .new) })
      .flatMap { _ -> Observable<Mutation> in .empty() }
  }
  
  private func deleteTaskMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    return self.taskService.delete(id: task.id).asObservable()
      .flatMap { _ in Observable.empty() }
  }
  
  private func toggleTaskDoneMutation(indexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[indexPath.item]
    if !task.isMarked {
      return self.taskService.mark(id: task.id).asObservable()
        .flatMap { _ in Observable.empty() }
    } else {
      return self.taskService.unmark(id: task.id).asObservable()
        .flatMap { _ in Observable.empty() }
    }
  }
  
  func moveTask(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) -> Observable<Mutation> {
    let task = self.currentState.tasks[sourceIndexPath.item]
    return self.taskService.move(
      id: task.id,
      destinationIndex: destinationIndexPath.item
    )
    .asObservable()
    .flatMap { _ in Observable.empty() }
  }

  private func tasksMutation() -> Observable<Mutation> {
    return self.taskService.tasks().asObservable()
      .map(Mutation.setTasks)
      .catchError { _ -> Observable<Mutation> in .empty() }
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, self.taskServiceMutation())
  }
  
  private func taskServiceMutation() -> Observable<Mutation> {
    return self.taskService.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let self = self else { return .empty() }
      let state = self.currentState
      switch event {
      case let .delete(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          return .just(Mutation.deleteTask(index: index))
        } else  {
          return .empty()
        }
        
      case let .move(id, destinationIndex):
        let sourceIndex = state.tasks.firstIndex { task in task.id == id }
        if let sourceIndex = sourceIndex {
          return .just(.moveTask(from: sourceIndex, to: destinationIndex))
        } else {
          return .empty()
        }
        
      case let .create(task):
        return .just(Mutation.createTask(task))
        
      case let .mark(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          var task = state.tasks[index]
          task.isMarked = true
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
        
      case let .unmark(id):
        let index = state.tasks.firstIndex { task in task.id == id }
        if let index = index {
          var task = state.tasks[index]
          task.isMarked = false
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
        
      case let .update(task):
        let taskId = task.id
        let index = state.tasks.firstIndex { task in task.id == taskId }
        if let index = index {
          return .just(Mutation.updateTask(index: index, task))
        } else {
          return .empty()
        }
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
      
    case let .setTasks(tasks):
      newState.tasks = tasks
      
    case .toggleEditing:
      newState.isEditing = !newState.isEditing
      
    case let .createTask(task):
      newState.tasks.insert(task, at: 0)
      
    case let .deleteTask(index):
      newState.tasks.remove(at: index)
      
    case let .updateTask(index, task):
      newState.tasks[index] = task
      
    case let .moveTask(from, to):
      let task = newState.tasks.remove(at: from)
      newState.tasks.insert(task, at: to)
    }
    
    return newState
  }
}

// MARK: TaskEditingListener

extension TasksInteractor {
  func taskEditingDidFinish() {
    self.router?.closeTaskEditing()
  }
}
