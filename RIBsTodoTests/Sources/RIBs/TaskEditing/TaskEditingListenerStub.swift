//
//  TaskEditingListenerStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//


import Stubber

@testable import RIBsTodo

class TaskEditingListenerStub: TaskEditingListener {
  func taskEditingDidFinish() {
    Stubber.invoke(taskEditingDidFinish, args: ())
  }
}
