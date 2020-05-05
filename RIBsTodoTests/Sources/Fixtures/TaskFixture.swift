//
//  TaskFixture.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Foundation

@testable import RIBsTodo

enum TaskFixture {
  static let task1 = Task(
    id: UUID().uuidString,
    title: "task1",
    memo: "",
    isMarked: false,
    createdAt: Date(),
    updateAt: Date()
  )
  static let task2 = Task(
    id: UUID().uuidString,
    title: "task2",
    memo: "",
    isMarked: false,
    createdAt: Date(),
    updateAt: Date()
  )
}
