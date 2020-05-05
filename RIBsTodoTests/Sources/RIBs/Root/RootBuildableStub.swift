//
//  RootBuildableStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import RIBs

@testable import RIBsTodo

class RootBuildableStub: RootBuildable {
  
  init() {}
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
    return Stubber.invoke(build, args: ())
  }
}
