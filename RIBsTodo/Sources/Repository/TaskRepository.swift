//
//  TaskRepository.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift
import RxRelay
import RealmSwift
import RxRealm

protocol TaskRepositoryProtocol {
  func create(title: String, memo: String) -> Single<Task>
  func tasks() -> Single<[Task]>
  func delete(id: String) -> Single<Task>
  func mark(id: String) -> Single<Task>
  func unmark(id: String) -> Single<Task>
  func move(id: String, destinationIndex: Int) -> Single<Task>
  func update(id: String, title: String, memo: String) -> Single<Task>
}

enum TaskRealmRepositoryError: Error {
  case notFound
  case failedToInsert
}

class TaskRealmRepository: TaskRepositoryProtocol {
  
  private let realm: Realm
  
  init(realm: Realm) {
    self.realm = realm
    if self.realm.isEmpty {
      try! realm.write {
        realm.add(RMTaskList())
      }
    }
  }
  
  func create(title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      let task = RMTask(title: title, memo: memo)
      
      do {
        try self.realm.write {
          taskList.tasks.insert(task, at: 0)
        }
      } catch let error {
        observer(.error(error))
      }
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  func tasks() -> Single<[Task]> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      observer(.success(Array(taskList.tasks.map(Task.init))))
      return Disposables.create()
    }
  }
  
  func delete(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first,
        let taskIndex = taskList.tasks.firstIndex(of: task)
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          taskList.tasks.remove(at: taskIndex)
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  func mark(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.isMarked = true
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  func unmark(id: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.isMarked = false
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  func move(id: String, destinationIndex: Int) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let sourceTask = taskList.tasks.filter("id = %@", id).first,
        let sourceTaskIndex = taskList.tasks.firstIndex(of: sourceTask)
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      let task = taskList.tasks[sourceTaskIndex]
      
      do {
        try self.realm.write {
          taskList.tasks.remove(at: sourceTaskIndex)
          taskList.tasks.insert(task, at: destinationIndex)
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
  
  func update(id: String, title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      guard
        let taskList = self.realm.objects(RMTaskList.self).first,
        let task = taskList.tasks.filter("id = %@", id).first
      else {
        observer(.error(TaskRealmRepositoryError.notFound))
        return Disposables.create()
      }
      
      do {
        try self.realm.write {
          task.title = title
          task.memo = memo
        }
      } catch let error {
        observer(.error(error))
      }
      
      observer(.success(Task(task)))
      return Disposables.create()
    }
  }
}
