//
//  ReplaceModalable.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import UIKit

protocol ReplaceModalable: class {
  var targetViewController: ViewControllable? { get set }
  var animationInProgress: Bool { get set }
  
  func replaceModal(viewController: ViewControllable?)
}

extension ReplaceModalable where Self: UIViewController {
  func replaceModal(viewController: ViewControllable?) {
    self.targetViewController = viewController
    guard !self.animationInProgress else { return }
    
    if self.presentedViewController != nil {
      self.animationInProgress = true
      self.dismiss(animated: true) { [weak self] in
        guard let self = self else { return }
        if self.targetViewController != nil {
          self.presentTargetViewController()
        } else {
          self.animationInProgress = false
        }
      }
    } else {
      self.presentTargetViewController()
    }
  }
  
  private func presentTargetViewController() {
    if let targetViewController = self.targetViewController {
      self.animationInProgress = true
      targetViewController.uiviewController.modalPresentationStyle = .fullScreen
      self.present(targetViewController.uiviewController, animated: true) { [weak self] in
        self?.animationInProgress = false
      }
    }
  }
}
