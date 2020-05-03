//
//  TasksComponent+TaskEditing.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol TasksDependencyTaskEditing: Dependency {}
extension TasksComponent: TaskEditingDependency {}
