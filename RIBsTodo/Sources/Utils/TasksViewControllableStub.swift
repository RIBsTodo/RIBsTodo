//
//  TasksViewControllableStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import UIKit
import RxSwift
import Stubber
import RIBs

@testable import RIBsTodo

class TasksViewControllableStub: TasksViewControllable, TasksPresentable {

  var targetViewController: ViewControllable?
  
  var animationInProgress: Bool = false

  var uiviewController: UIViewController = UIViewController() {
    didSet { self.callSetUIViewController() }
  }
  
  func callSetUIViewController() {
    Stubber.invoke(callSetUIViewController, args: ())
  }
  
  var listener: TasksPresentableListener?
  
  init() {}
  
  func replaceModal(viewController: ViewControllable?) {
    Stubber.invoke(replaceModal, args: (viewController))
  }
}
