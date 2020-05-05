//
//  RootViewControllableStub.swift
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

class RootViewControllableStub: RootViewControllable, RootPresentable {

  var uiviewController: UIViewController = UIViewController() {
    didSet { self.callSetUIViewController() }
  }
  
  func callSetUIViewController() {
    Stubber.invoke(callSetUIViewController, args: ())
  }
  
  var listener: RootPresentableListener?
  
  init() {}
  
  func replaceChildViewController(viewController: ViewControllable?) {
    Stubber.invoke(replaceChildViewController, args: (viewController))
  }
}
