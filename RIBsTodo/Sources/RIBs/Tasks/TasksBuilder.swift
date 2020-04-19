//
//  TasksBuilder.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TasksDependency: Dependency {
}

final class TasksComponent: Component<TasksDependency> {
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
    let _ = TasksComponent(dependency: dependency)
    let viewController = TasksViewController()
    let interactor = TasksInteractor(presenter: viewController)
    interactor.listener = listener
    return TasksRouter(interactor: interactor, viewController: viewController)
  }
}
