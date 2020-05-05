//
//  TaskServiceStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift
import RxRelay
import Stubber

@testable import RIBsTodo

final class TaskServiceStub: TaskServiceProtocol {
  
  var event: PublishRelay<Task.Event> = .init()
  
  let repository: TaskRepositoryProtocol
  
  init(repository: TaskRepositoryProtocol) {
    self.repository = repository
  }
  
  func delete(id: String) -> Single<Void> {
    return Stubber.invoke(delete, args: (id), default: .never())
  }
  
  func create(title: String, memo: String) -> Single<Void> {
    return Stubber.invoke(create, args: (title, memo), default: .never())
  }
  
  func tasks() -> Single<[Task]> {
    return Stubber.invoke(tasks, args: (), default: .never())
  }
  
  func mark(id: String) -> Single<Void> {
    return Stubber.invoke(mark, args: (id), default: .never())
  }
  
  func unmark(id: String) -> Single<Void> {
    return Stubber.invoke(unmark, args: (id), default: .never())
  }
  
  func move(id: String, destinationIndex: Int) -> Single<Void> {
    return Stubber.invoke(move, args: (id, destinationIndex), default: .never())
  }
  
  func update(id: String, title: String, memo: String) -> Single<Void> {
    return Stubber.invoke(update, args: (id, title, memo), default: .never())
  }
}
