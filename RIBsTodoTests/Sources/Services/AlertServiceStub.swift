//
//  AlertServiceStub.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import UIKit
@testable import RIBsTodo

import RxSwift

final class AlertServiceStub: AlertServiceProtocol {

  var selectAction: AlertActionType?

  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action> {
    guard let selectAction = self.selectAction as? Action else { return .empty() }
    return .just(selectAction)
  }

}
