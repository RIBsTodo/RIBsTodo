//
//  RootInteractor.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
  func routeToTasks()
}

protocol RootPresentable: Presentable {
  var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {
}

final class RootInteractor
  : PresentableInteractor<RootPresentable>
  , RootInteractable
  , RootPresentableListener {
  
  weak var router: RootRouting?
  weak var listener: RootListener?
  
  override init(presenter: RootPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.router?.routeToTasks()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

extension RootInteractor: UrlHandler {
  func handle(_ url: URL) {}
}
