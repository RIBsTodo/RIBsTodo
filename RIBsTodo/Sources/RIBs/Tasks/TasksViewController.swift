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

enum TasksViewAction {
  case refresh
  case toggleEditing
  case addTask
  case editTask(IndexPath)
  case toggleTaskDone(IndexPath)
  case deleteTask(IndexPath)
  case moveTask(IndexPath, IndexPath)
}

protocol TasksPresentableListener: class {
  var state: Observable<TasksViewState> { get }
  var currentState: TasksViewState { get }
  var action: ActionSubject<TasksViewAction> { get }
}

typealias TasksViewReactor = (
  state: Observable<TasksViewState>,
  action: ActionSubject<TasksViewAction>
)

final class TasksViewController
  : BaseViewController
  , TasksPresentable
  , TasksViewControllable {
  
  var targetViewController: ViewControllable?
  var animationInProgress: Bool = false
  
  enum Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }
  
  weak var listener: TasksPresentableListener?
  
  private let dataSource = RxTableViewSectionedAnimatedDataSource<TasksViewSection>(
    animationConfiguration: AnimationConfiguration(
      insertAnimation: .none,
      reloadAnimation: .none,
      deleteAnimation: .none
    ),
    configureCell: { _, tableView, indexPath, sectionItem in
      switch sectionItem {
      case let .task(cellReactor):
        let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
        cell.reactor = cellReactor
        return cell
      }
    }
  )
  
  private let addButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: nil,
    action: nil
  )
  
  private let activityIndicatorView = UIActivityIndicatorView(style: .large)
  
  private let tableView = UITableView().then {
    $0.allowsSelectionDuringEditing = true
    $0.register(Reusable.taskCell)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    self.navigationItem.rightBarButtonItem = self.addButtonItem
    
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.activityIndicatorView)
    
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    self.activityIndicatorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    guard let action = self.listener?.action else { return }
    guard let state = self.listener?.state else { return }
    let reactor = (state, action)
    
    self.bindDelegate(reactor: reactor)
    self.bindDataSources(reactor: reactor)
    self.bindLoading(reactor: reactor)
    self.bindRefresh(reactor: reactor)
    self.bindAddTask(reactor: reactor)
    self.bindEditing(reactor: reactor)
    self.bindTaskMoved(reactor: reactor)
    self.bindTaskDeleted(reactor: reactor)
    self.bindTaskSelected(reactor: reactor)
  }

  private func bindDelegate(reactor: TasksViewReactor) {
    self.tableView.rx.setDelegate(self)
      .disposed(by: self.disposeBag)
  }
  
  private func bindDataSources(reactor: TasksViewReactor) {
    self.dataSource.canEditRowAtIndexPath = { _, _  in true }
    self.dataSource.canMoveRowAtIndexPath = { _, _  in true }
    
    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }
  
  private func bindRefresh(reactor: TasksViewReactor) {
    self.rx.viewWillAppear
      .take(1)
      .map { _ in .refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindLoading(reactor: TasksViewReactor) {
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.activityIndicatorView.rx.isAnimating)
      .disposed(by: self.disposeBag)
  }
  
  private func bindAddTask(reactor: TasksViewReactor) {
    self.addButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TasksViewAction.addTask }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindEditing(reactor: TasksViewReactor) {
    self.editButtonItem.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { TasksViewAction.toggleEditing }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state.map { $0.isEditing }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isEditing in
        guard let self = self else { return }
        self.navigationItem.leftBarButtonItem?.title = isEditing ? "Done" : "Edit"
        self.navigationItem.leftBarButtonItem?.style = isEditing ? .done : .plain
        self.tableView.setEditing(isEditing, animated: true)
      })
      .disposed(by: self.disposeBag)
    
    self.tableView.rx.itemSelected
      .filter(reactor.state.map { $0.isEditing })
      .map { indexPath in .editTask(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskMoved(reactor: TasksViewReactor) {
    self.tableView.rx.itemMoved
      .map(TasksViewAction.moveTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskDeleted(reactor: TasksViewReactor) {
    self.tableView.rx.itemDeleted
      .map(TasksViewAction.deleteTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  private func bindTaskSelected(reactor: TasksViewReactor) {
    self.tableView.rx.itemSelected
      .filterNot(reactor.state.map { $0.isEditing })
      .map { indexPath in .toggleTaskDone(indexPath) }
      .bind(to: reactor.action)
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
