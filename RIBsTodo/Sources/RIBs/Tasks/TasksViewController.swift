//
//  TasksViewController.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol TasksPresentableListener: class {
}

final class TasksViewController
  : UIViewController
  , TasksPresentable
  , TasksViewControllable {
  
  weak var listener: TasksPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
}
