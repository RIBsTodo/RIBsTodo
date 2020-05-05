//
//  TasksInteractorSpec.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import Quick
import Nimble
import RxSwift

@testable import RIBsTodo

final class TasksInteractorSpec: QuickSpec {

  override func spec() {
    super.spec()
    
    var interactor: TasksInteractor!
    var taskService: TaskService!
    var listener: TasksListenerStub!
    var viewController: TasksViewControllableStub!
    var router: TasksRoutingStub!
    
    beforeEach {
      viewController = TasksViewControllableStub()
      taskService = TaskService(repository: TaskRepositoryFake(tasks: [TaskFixture.task1, TaskFixture.task2]))
      listener = TasksListenerStub()
      interactor = TasksInteractor(presenter: viewController, taskService: taskService)
      interactor.listener = listener
      viewController.listener = interactor
      
      router = TasksRoutingStub(interactable: interactor, viewControllable: viewController)
      interactor.router = router
      
      Stubber.register(router.load) {}
      router.load()
      router.interactable.activate()
    }
    
    describe("an initial state") {
      it("is not loading") {
        expect(interactor.currentState.isLoading) == false
      }
      it("has not editing") {
        expect(interactor.currentState.isEditing) == false
      }
      it("has empty tasks") {
        expect(interactor.currentState.tasks).to(beEmpty())
      }
      it("has empty section items") {
        expect(interactor.currentState.sections[0].items).to(beEmpty())
      }
    }
    
    context("when receives a refresh action") {
      it("fetches tasks") {
        viewController.listener?.action.onNext(.refresh)
        expect(interactor.currentState.tasks.count) == 2
      }
    }
    
    context("when receives a toggle editing action") {
      it("toggle editing") {
        let disposeBag = DisposeBag()
        var toggleEditings: [Bool] = []
        
        interactor.state
          .subscribe(onNext: { state in toggleEditings.append(state.isEditing) })
          .disposed(by: disposeBag)
        
        viewController.listener?.action.onNext(.toggleEditing)
        viewController.listener?.action.onNext(.toggleEditing)
        
        expect(toggleEditings[0]) == false
        expect(toggleEditings[1]) == true
        expect(toggleEditings[2]) == false
      }
    }
    
    context("when receives a toggle task done action") {
      it("toggle mark") {
        viewController.listener?.action.onNext(.refresh)
        expect(interactor.currentState.tasks[0].isMarked) == false
        expect(interactor.currentState.tasks[1].isMarked) == false
        
        viewController.listener?.action.onNext(.toggleTaskDone(IndexPath(item: 0, section: 0)))
        expect(interactor.currentState.tasks[0].isMarked) == true
        expect(interactor.currentState.tasks[1].isMarked) == false
        
        viewController.listener?.action.onNext(.toggleTaskDone(IndexPath(item: 0, section: 0)))
        expect(interactor.currentState.tasks[0].isMarked) == false
        expect(interactor.currentState.tasks[1].isMarked) == false
        
        viewController.listener?.action.onNext(.toggleTaskDone(IndexPath(item: 1, section: 0)))
        expect(interactor.currentState.tasks[0].isMarked) == false
        expect(interactor.currentState.tasks[1].isMarked) == true
      }
    }
    
    context("when receives a delete task action") {
      it("delete task") {
        viewController.listener?.action.onNext(.refresh)
        expect(interactor.currentState.tasks.count) == 2
        
        viewController.listener?.action.onNext(.deleteTask(IndexPath(item: 0, section: 0)))
        expect(interactor.currentState.tasks.count) == 1
      }
    }
    
    context("when receives a addTask action") {
      it("route taskEditingRIB") {
        Stubber.register(router.routeToTaskEditing) { _ in }
        viewController.listener?.action.onNext(.addTask)
        expect(Stubber.executions(router.routeToTaskEditing).count) == 1
      }
    }
    
    context("when receives a editTask action") {
      it("route taskEditingRIB") {
        Stubber.register(router.routeToTaskEditing) { _ in }
        viewController.listener?.action.onNext(.refresh)
        viewController.listener?.action.onNext(.editTask(IndexPath(item: 0, section: 0)))
        expect(Stubber.executions(router.routeToTaskEditing).count) == 1
      }
    }
  }
}
