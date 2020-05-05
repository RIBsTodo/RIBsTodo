//
//  TasksBuildableStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import RIBs

@testable import RIBsTodo

class TasksBuildableStub: TasksBuildable {
  
  init() {}
  
  func build(withListener listener: TasksListener) -> TasksRouting {
    return Stubber.invoke(build, args: (listener))
  }
}
