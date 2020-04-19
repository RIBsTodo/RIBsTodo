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
  func tasks() -> Single<[Task]>
}

class TaskService: TaskServiceProtocol {
  var event: PublishRelay<Task.Event> = .init()
  
  private let realm: Realm
  
  init(realm: Realm) {
    self.realm = realm
  }
  
  func tasks() -> Single<[Task]> {
    return Observable
      .array(from: self.realm.objects(TaskTable.self))
      .flatMap { taskTables -> Observable<[Task]>in .just(taskTables.map(Task.init)) }
      .asSingle()
  }
}
