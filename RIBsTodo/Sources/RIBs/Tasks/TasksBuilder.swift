//
//  TasksBuilder.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RealmSwift

protocol TasksDependency: Dependency {
}

final class TasksComponent: Component<TasksDependency> {
  var taskService: TaskServiceProtocol {
    return TaskService(realm: try! Realm())
  }
}

// MARK: - Builder

protocol TasksBuildable: Buildable {
  func build(withListener listener: TasksListener) -> TasksRouting
}

final class TasksBuilder: Builder<TasksDependency>, TasksBuildable {
  
  override init(dependency: TasksDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TasksListener) -> TasksRouting {
    let component = TasksComponent(dependency: dependency)
    let viewController = TasksViewController()
    let interactor = TasksInteractor(
      presenter: viewController,
      taskService: component.taskService
    )
    interactor.listener = listener
    return TasksRouter(interactor: interactor, viewController: viewController)
  }
}
