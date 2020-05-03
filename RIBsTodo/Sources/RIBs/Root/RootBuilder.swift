//
//  RootBuilder.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
}

final class RootComponent: Component<RootDependency> {
  let rootViewController: RootViewController
  
  init(dependency: RootDependency, rootViewController: RootViewController) {
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}

protocol RootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
  
  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
    let viewController = RootViewController()
    let component = RootComponent(
      dependency: self.dependency,
      rootViewController: viewController
    )
    let interactor = RootInteractor(presenter: viewController)
    let tasksBuilder = TasksBuilder(dependency: component)
    let router = RootRouter(
      interactor: interactor,
      viewController: viewController,
      tasksBuilder: tasksBuilder
    )
    return (router, interactor)
  }
}
