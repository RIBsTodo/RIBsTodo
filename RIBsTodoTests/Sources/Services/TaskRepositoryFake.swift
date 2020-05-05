//
//  TaskRepositoryFake.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift
import RxRelay
import Stubber

@testable import RIBsTodo

final class TaskRepositoryFake: TaskRepositoryProtocol {
  
  private var _tasks: [Task]
  
  init(tasks: [Task] = []) {
    self._tasks = tasks
  }
  
  func create(title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      let task = Task(
        id: UUID().uuidString,
        title: title,
        memo: memo,
        isMarked: false,
        createdAt: Date(),
        updateAt: Date()
      )
      self._tasks.append(task)
      observer(.success(task))
      return Disposables.create()
    }
  }
  
  func tasks() -> Single<[Task]> {
    return Single.create { observer in
      observer(.success(self._tasks))
      return Disposables.create()
    }
  }
  
  func delete(id: String) -> Single<Task> {
    return Single.create { observer in
      let index = self._tasks.firstIndex { task in task.id == id }
      if let index = index {
        let task = self._tasks[index]
        self._tasks.remove(at: index)
        observer(.success(task))
      } else {
        observer(.error(TestError()))
      }
      return Disposables.create()
    }
  }
  
  func mark(id: String) -> Single<Task> {
    return Single.create { observer in
      let index = self._tasks.firstIndex { task in task.id == id }
      if let index = index {
        self._tasks[index].isMarked = true
        observer(.success(self._tasks[index]))
      } else {
        observer(.error(TestError()))
      }
      return Disposables.create()
    }
  }
  
  func unmark(id: String) -> Single<Task> {
    return Single.create { observer in
      let index = self._tasks.firstIndex { task in task.id == id }
      if let index = index {
        self._tasks[index].isMarked = false
        observer(.success(self._tasks[index]))
      } else {
        observer(.error(TestError()))
      }
      return Disposables.create()
    }
  }
  
  func move(id: String, destinationIndex: Int) -> Single<Task> {
    return Single.create { observer in
      let sourceTaskIndex = self._tasks.firstIndex { task in task.id == id }
      if let sourceTaskIndex = sourceTaskIndex {
        let task = self._tasks[sourceTaskIndex]
        self._tasks.remove(at: sourceTaskIndex)
        self._tasks.insert(task, at: destinationIndex)
        observer(.success(task))
      } else {
        observer(.error(TestError()))
      }
      return Disposables.create()
    }
  }
  
  func update(id: String, title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      let index = self._tasks.firstIndex { task in task.id == id }
      if let index = index {
        let task = self._tasks[index]
        self._tasks[index].title = title
        self._tasks[index].memo = memo
        observer(.success(task))
      } else {
        observer(.error(TestError()))
      }
      return Disposables.create()
    }
  }
}
