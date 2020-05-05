//
//  TaskEditingBuildableStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import RIBs

@testable import RIBsTodo

class TaskEditingBuildableStub: TaskEditingBuildable {
  
  init() {}
  
  func build(withListener listener: TaskEditingListener, mode: TaskEditingViewMode) -> TaskEditingRouting {
    return Stubber.invoke(build, args: (listener, mode))
  }
}
