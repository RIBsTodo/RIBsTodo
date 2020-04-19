//
//  AppComponent.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
class AppComponent: Component<EmptyDependency>, RootDependency {
  init() {
    super.init(dependency: EmptyComponent())
  }
}
