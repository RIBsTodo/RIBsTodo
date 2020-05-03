//
//  TaskEditingRouter.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TaskEditingInteractable: Interactable {
  var router: TaskEditingRouting? { get set }
  var listener: TaskEditingListener? { get set }
}

protocol TaskEditingViewControllable: ViewControllable {
}

final class TaskEditingRouter
  : ViewableRouter<TaskEditingInteractable, TaskEditingViewControllable>
  , TaskEditingRouting {
  
  override init(
    interactor: TaskEditingInteractable,
    viewController: TaskEditingViewControllable
  ) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
