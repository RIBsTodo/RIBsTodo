//
//  TasksInteractableStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import UIKit
import RxSwift
import Stubber
import RIBs

@testable import RIBsTodo

class TasksInteractableStub: TasksInteractable {

  var router: TasksRouting? {
    didSet { self.callSetRouter() }
  }
  
  var listener: TasksListener? {
    didSet { self.callSetListener() }
  }
  
  var isActive: Bool = false {
    didSet { self.callSetActive(self.isActive) }
  }
  
  var isActiveStreamSubject: PublishSubject<Bool> = PublishSubject<Bool>() {
    didSet { self.callSetActiveStreamSubject() }
  }
  
  var isActiveStream: Observable<Bool> {
    return isActiveStreamSubject
  }
  
  func callSetRouter() {
    Stubber.invoke(callSetRouter, args: ())
  }
  
  func callSetListener() {
    Stubber.invoke(callSetListener, args: ())
  }
  
  func callSetActive(_ isActive: Bool) {
    Stubber.invoke(callSetActive, args: (isActive))
  }
  
  func callSetActiveStreamSubject() {
    Stubber.invoke(callSetActiveStreamSubject, args: ())
  }
  
  init() {}
  
  func activate() {
    Stubber.invoke(activate, args: ())
  }
  
  func deactivate() {
    Stubber.invoke(deactivate, args: ())
  }
  
  func taskEditingDidFinish() {
    Stubber.invoke(taskEditingDidFinish, args: ())
  }
}
