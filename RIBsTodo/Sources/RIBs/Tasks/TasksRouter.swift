//
//  TasksRouter.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TasksInteractable: Interactable, TaskEditingListener {
  var router: TasksRouting? { get set }
  var listener: TasksListener? { get set }
}

protocol TasksViewControllable: ViewControllable, ReplaceModalable {
  func replaceModal(viewController: ViewControllable?)
}

final class TasksRouter
  : ViewableRouter<TasksInteractable, TasksViewControllable>
  , TasksRouting {
  
  private var taskEditingBuilder: TaskEditingBuildable
  private var taskEditing: TaskEditingRouting?
  
  init(
    interactor: TasksInteractable,
    viewController: TasksViewControllable,
    taskEditingBuilder: TaskEditingBuildable
  ) {
    self.taskEditingBuilder = taskEditingBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func routeToTaskEditing(mode: TaskEditingViewMode) {
    let taskEditing = self.taskEditingBuilder.build(
      withListener: self.interactor,
      mode: mode
    )
    self.taskEditing = taskEditing
    self.attachChild(taskEditing)
    
    self.viewController.replaceModal(
      viewController: UINavigationController(
        root: taskEditing.viewControllable
      )
    )
  }
  
  func closeTaskEditing() {
    if let taskEditing = taskEditing {
      self.detachChild(taskEditing)
      self.taskEditing = nil
      self.viewController.replaceModal(viewController: nil)
    }
  }
}
