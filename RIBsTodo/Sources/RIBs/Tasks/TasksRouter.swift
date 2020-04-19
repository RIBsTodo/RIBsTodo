//
//  TasksRouter.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TasksInteractable: Interactable {
  var router: TasksRouting? { get set }
  var listener: TasksListener? { get set }
}

protocol TasksViewControllable: ViewControllable {
}

final class TasksRouter
  : ViewableRouter<TasksInteractable, TasksViewControllable>
  , TasksRouting {
  
  override init(interactor: TasksInteractable, viewController: TasksViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
