//
//  TasksRoutingStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift
import Stubber
import RIBs

@testable import RIBsTodo

class TasksRoutingStub: TasksRouting {
  
  var viewControllable: ViewControllable
  
  var interactable: Interactable {
    didSet { self.callSetInteractable() }
  }
  
  var children: [Routing] = [Routing]() {
    didSet { self.callSetChildren() }
  }
  
  var lifecycleSubject: PublishSubject<RouterLifecycle> = PublishSubject<RouterLifecycle>() {
    didSet { self.callSetLifecycleSubject() }
  }
  
  var lifecycle: Observable<RouterLifecycle> {
    return lifecycleSubject
  }
  
  init(interactable: Interactable, viewControllable: ViewControllable) {
    self.interactable = interactable
    self.viewControllable = viewControllable
  }
  
  func callSetInteractable() {
    Stubber.invoke(callSetInteractable, args: ())
  }
  
  func callSetChildren() {
    Stubber.invoke(callSetChildren, args: ())
  }
  
  func callSetLifecycleSubject() {
    Stubber.invoke(callSetLifecycleSubject, args: ())
  }

  func load() {
    Stubber.invoke(load, args: ())
  }

  func attachChild(_ child: Routing) {
    Stubber.invoke(attachChild, args: (child))
  }
  
  func detachChild(_ child: Routing) {
    Stubber.invoke(detachChild, args: (child))
  }
  
  func routeToTaskEditing(mode: TaskEditingViewMode) {
    Stubber.invoke(routeToTaskEditing, args: (mode))
  }
  
  func closeTaskEditing() {
    Stubber.invoke(closeTaskEditing, args: ())
  }
}
