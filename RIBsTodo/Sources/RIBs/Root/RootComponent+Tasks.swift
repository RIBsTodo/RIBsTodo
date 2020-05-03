//
//  RootComponent+Tasks.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol RootDependencyTasks: Dependency {}
extension RootComponent: TasksDependency {}
