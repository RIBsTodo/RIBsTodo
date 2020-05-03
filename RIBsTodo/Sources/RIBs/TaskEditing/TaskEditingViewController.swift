//
//  TaskEditingViewController.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/03.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxSwift
import ReactorKit

enum TaskEditingViewAction {
  case updateTaskTitle(String)
  case cancel
  case submit
}

typealias TaskEditingViewReactor = (
  state: Observable<TaskEditingViewState>,
  action: ActionSubject<TaskEditingViewAction>
)

protocol TaskEditingPresentableListener: class {
  var state: Observable<TaskEditingViewState> { get }
  var currentState: TaskEditingViewState { get }
  var action: ActionSubject<TaskEditingViewAction> { get }
}

final class TaskEditingViewController
  : UIViewController
  , TaskEditingPresentable
  , TaskEditingViewControllable {
  
  struct Metric {
    static let padding: CGFloat = 15
    static let titleInputCornerRadius: CGFloat = 5
    static let titleInputBorderWidth = 1 / UIScreen.main.scale
  }

  struct Font {
    static let titleLabel = UIFont.systemFont(ofSize: 14)
  }

  struct Color {
    static let titleInputBorder = UIColor.lightGray
  }

  // MARK: UI
  
  let cancelButtonItem = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil,
    action: nil
  )
  let doneButtonItem = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil
  )
  let titleInput = UITextField().then {
    $0.autocorrectionType = .no
    $0.borderStyle = .roundedRect
    $0.font = Font.titleLabel
    $0.placeholder = "Do something..."
  }
  
  var disposeBag = DisposeBag()
  
  weak var listener: TaskEditingPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem
    self.navigationItem.rightBarButtonItem = self.doneButtonItem
    
    self.view.backgroundColor = .white
    self.view.addSubview(self.titleInput)
    
    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Metric.padding)
      make.left.equalTo(Metric.padding)
      make.right.equalTo(-Metric.padding)
    }
    
    guard let action = self.listener?.action else { return }
    guard let state = self.listener?.state else { return }
    let reactor = (state, action)
    
    self.bindCancel(reactor: reactor)
    self.bindSubmit(reactor: reactor)
    self.bindTitle(reactor: reactor)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleInput.becomeFirstResponder()
  }

  private func bindCancel(reactor: TaskEditingViewReactor) {
    self.cancelButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TaskEditingViewAction.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButtonItem.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }
  
  private func bindSubmit(reactor: TaskEditingViewReactor) {
    self.doneButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TaskEditingViewAction.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTitle(reactor: TaskEditingViewReactor) {
    self.titleInput.rx.text
      .filterNil()
      .skip(1)
      .map(TaskEditingViewAction.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.navigationItem.rx.title)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)
  }
}
