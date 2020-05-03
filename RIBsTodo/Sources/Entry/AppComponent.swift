//
//  AppComponent.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import Swinject
import RealmSwift

private let dependencyInjectionContainer = Container()

extension Component {
  var container: Container { return dependencyInjectionContainer }
}

class AppComponent: Component<EmptyDependency>, RootDependency {
  
  init() {
    super.init(dependency: EmptyComponent())
    self.container.register(Realm.self) { r in
      try! Realm()
    }.inObjectScope(.container)
    self.container.register(TaskRepositoryProtocol.self) { r in
      TaskRealmRepository(realm: r.resolve(Realm.self)!)
    }.inObjectScope(.container)
    self.container.register(TaskServiceProtocol.self) { r in
      TaskService(repository: r.resolve(TaskRepositoryProtocol.self)!)
    }.inObjectScope(.container)
    self.container.register(AlertServiceProtocol.self) { r in
      AlertService()
    }.inObjectScope(.container)
  }
}
