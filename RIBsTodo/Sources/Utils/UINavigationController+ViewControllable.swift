//
//  UINavigationController+ViewControllable.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import UIKit

extension UINavigationController: ViewControllable {
  public var uiviewController: UIViewController {
    return self
  }
  
  convenience init(root: ViewControllable) {
    self.init(rootViewController: root.uiviewController)
  }
}

