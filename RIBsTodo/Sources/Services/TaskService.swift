//
//  TaskService.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift
import RxRelay
import RealmSwift
import RxRealm

protocol TaskServiceProtocol {
  var event: PublishRelay<Task.Event> { get }
  
  func update(id: String, title: String, memo: String) -> Single<Void>
  func create(title: String, memo: String) -> Single<Void>
  func delete(id: String) -> Single<Void>
  func tasks() -> Single<[Task]>
  func mark(id: String) -> Single<Void>
  func unmark(id: String) -> Single<Void>
  func move(id: String, destinationIndex: Int) -> Single<Void>
}

class TaskService: TaskServiceProtocol {
  
  var event: PublishRelay<Task.Event> = .init()
  
  private let repository: TaskRepositoryProtocol
  
  init(repository: TaskRepositoryProtocol) {
    self.repository = repository
  }
  
  func delete(id: String) -> Single<Void> {
    return self.repository.delete(id: id)
      .do(onSuccess: { task in
        self.event.accept(Task.Event.delete(id: task.id))
      })
      .map { _ in }
  }
  
  func create(title: String, memo: String) -> Single<Void> {
    return self.repository.create(title: title, memo: memo)
      .do(onSuccess: { task in
        self.event.accept(Task.Event.create(task))
      })
      .map { _ in }
  }
  
  func tasks() -> Single<[Task]> {
    return self.repository.tasks()
  }
  
  func mark(id: String) -> Single<Void> {
    return self.repository.mark(id: id)
    .do(onSuccess: { task in
      self.event.accept(Task.Event.mark(id: id))
    })
    .map { _ in }
  }
  
  func unmark(id: String) -> Single<Void> {
    return self.repository.unmark(id: id)
    .do(onSuccess: { task in
      self.event.accept(Task.Event.unmark(id: id))
    })
    .map { _ in }
  }
  
  func move(id: String, destinationIndex: Int) -> Single<Void> {
    return self.repository.move(id: id, destinationIndex: destinationIndex)
    .do(onSuccess: { task in
      self.event.accept(Task.Event.move(id: task.id, destinationIndex: destinationIndex))
    })
    .map { _ in }
  }
  
  func update(id: String, title: String, memo: String) -> Single<Void> {
    return self.repository.update(id: id, title: title, memo: memo)
    .do(onSuccess: { task in
      self.event.accept(Task.Event.update(task))
    })
    .map { _ in }
  }
}
