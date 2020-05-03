//
//  ViewControllable+Extension.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import UIKit

extension ViewControllable where Self: UIViewController {  
  func push(viewController: ViewControllable?) {
    if let viewController = viewController?.uiviewController {
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  func pop() {
    self.navigationController?.popViewController(animated: true)
  }
}
