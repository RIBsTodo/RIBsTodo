//
//  RootRouter.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, TasksListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
  func replaceChildViewController(viewController: ViewControllable?)
}

final class RootRouter
  : LaunchRouter<RootInteractable, RootViewControllable>
  , RootRouting {
  
  private let tasksBuilder: TasksBuildable
  private var tasks: TasksRouting?
  
  init(
    interactor: RootInteractable,
    viewController: RootViewControllable,
    tasksBuilder: TasksBuildable
  ) {
    self.tasksBuilder = tasksBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func routeToTasks() {
    let tasks = tasksBuilder.build(withListener: self.interactor)
    self.tasks = tasks
    self.attachChild(tasks)
    self.viewController.replaceChildViewController(viewController: tasks.viewControllable)
  }
}
