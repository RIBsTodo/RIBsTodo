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

final class TaskService: TaskServiceProtocol {
  var event: PublishRelay<Task.Event> = .init()
  
  func tasks() -> Single<[Task]> {
    return Stubber.invoke(tasks, args: (), default: .never())
  }
}
