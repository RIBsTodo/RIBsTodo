//
//  TaskEditingBuilder.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TaskEditingDependency: Dependency {
}

final class TaskEditingComponent: Component<TaskEditingDependency> {
  fileprivate var taskService: TaskServiceProtocol {
    return self.container.resolve(TaskServiceProtocol.self)!
  }
  fileprivate var alertService: AlertServiceProtocol {
    return self.container.resolve(AlertServiceProtocol.self)!
  }
}

// MARK: - Builder

protocol TaskEditingBuildable: Buildable {
  func build(
    withListener listener: TaskEditingListener,
    mode: TaskEditingViewMode
  ) -> TaskEditingRouting
}

final class TaskEditingBuilder: Builder<TaskEditingDependency>, TaskEditingBuildable {
  
  override init(dependency: TaskEditingDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: TaskEditingListener,
    mode: TaskEditingViewMode
  ) -> TaskEditingRouting {
    let component = TaskEditingComponent(dependency: dependency)
    let viewController = TaskEditingViewController()
    let interactor = TaskEditingInteractor(
      presenter: viewController,
      mode: mode,
      taskService: component.taskService,
      alertService: component.alertService
    )
    interactor.listener = listener
    return TaskEditingRouter(
      interactor: interactor,
      viewController: viewController
    )
  }
}
