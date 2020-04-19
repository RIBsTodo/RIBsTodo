//
//  TasksInteractor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift

protocol TasksRouting: ViewableRouting {
}

protocol TasksPresentable: Presentable {
  var listener: TasksPresentableListener? { get set }
}

protocol TasksListener: class {
}

final class TasksInteractor
  : PresentableInteractor<TasksPresentable>
  , TasksInteractable
  , TasksPresentableListener {
  
  weak var router: TasksRouting?
  weak var listener: TasksListener?
  
  override init(presenter: TasksPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}
