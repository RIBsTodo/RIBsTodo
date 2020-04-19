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
  var event: PublishRelay<Task.Event> { get set }
  func create(title: String, memo: String) -> Single<Task>
  func tasks() -> Single<[Task]>
}

class TaskService: TaskServiceProtocol {
  var event: PublishRelay<Task.Event> = .init()
  
  private let realm: Realm
  
  init(realm: Realm) {
    self.realm = realm
  }
  
  func create(title: String, memo: String) -> Single<Task> {
    return Single.create { observer in
      do {
        try self.realm.write {
          let taskTable = TaskTable(title: title, memo: memo)
          self.realm.add(taskTable)
          observer(.success(Task(taskTable)))
        }
      } catch let error {
        observer(.error(error))
      }
      return Disposables.create()
    }
  }
  
  func tasks() -> Single<[Task]> {
    return Single.create { observer in
      let tasks = Array(self.realm.objects(TaskTable.self).map(Task.init))
      observer(.success(tasks))
      return Disposables.create()
    }
  }
}
