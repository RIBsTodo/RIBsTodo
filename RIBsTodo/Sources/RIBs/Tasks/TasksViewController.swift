//
//  TasksViewController.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import ReusableKit
import ReactorKit
import RxDataSources

enum TasksAction {
  case refresh
}

protocol TasksPresentableListener: class {
  var state: Observable<TasksState> { get }
  var currentState: TasksState { get }
  var action: ActionSubject<TasksAction> { get }
}

typealias TasksReactor = (
  state: Observable<TasksState>,
  action: ActionSubject<TasksAction>
)

final class TasksViewController
  : BaseViewController
  , TasksPresentable
  , TasksViewControllable {
  
  enum Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }
  
  weak var listener: TasksPresentableListener?
  
  let dataSource = RxTableViewSectionedAnimatedDataSource<TasksViewSection>(
    configureCell: { _, tableView, indexPath, sectionItem in
      switch sectionItem {
      case let .task(cellReactor):
        let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
        cell.reactor = cellReactor
        return cell
      }
    }
  )
  
  private let tableView = UITableView().then {
    $0.register(Reusable.taskCell)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.tableView)
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    guard let action = self.listener?.action else { return }
    guard let state = self.listener?.state else { return }
    let reactor = (state, action)
    self.bindDelegate(reactor: reactor)
    self.bindDataSources(reactor: reactor)
  }
  
  func bindDelegate(reactor: TasksReactor) {
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
  }
  
  func bindDataSources(reactor: TasksReactor) {
    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
}

// MARK: - UITableViewDelegate

extension TasksViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 40
  }
}
