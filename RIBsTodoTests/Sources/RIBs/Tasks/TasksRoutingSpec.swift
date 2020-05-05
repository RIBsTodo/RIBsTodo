//
//  TasksRoutingSpec.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import Quick
import Nimble
import RxSwift
import RIBs

@testable import RIBsTodo

final class TasksRouterSpec: QuickSpec {
  
  override func spec() {
    super.spec()
    
    var taskEditingBuilder: TaskEditingBuildableStub!
    var interactor: TasksInteractableStub!
    var router: TasksRouter!
    
    beforeEach {
      taskEditingBuilder = TaskEditingBuildableStub()
      
      interactor = TasksInteractableStub()
      Stubber.register(interactor.callSetRouter) {}
      Stubber.register(interactor.callSetActive) { _ in }
      Stubber.register(interactor.callSetListener) {}
      Stubber.register(interactor.activate) {}
      Stubber.register(interactor.deactivate) {}
      
      let viewController = TasksViewControllableStub()
      Stubber.register(viewController.callSetUIViewController) {}
      Stubber.register(viewController.replaceModal) { _ in }
      
      router = TasksRouter(
        interactor: interactor,
        viewController: viewController,
        taskEditingBuilder: taskEditingBuilder
      )
    }
    
    describe("when called routeToTaskEditing") {
      it("attach taskEditing RIB") {
        let taskEditingInteractor = TaskEditingInteractableStub()
        Stubber.register(taskEditingInteractor.callSetRouter) {}
        Stubber.register(taskEditingInteractor.callSetActive) { _ in }
        Stubber.register(taskEditingInteractor.callSetListener) {}
        Stubber.register(taskEditingInteractor.activate) {}
        Stubber.register(taskEditingInteractor.deactivate) {}
        
        let taskEditingViewController = TaskEditingViewControllableStub()
        Stubber.register(taskEditingViewController.callSetUIViewController) {}
        
        let taskEditingRouter = TaskEditingRoutingStub(
          interactable: taskEditingInteractor,
          viewControllable: taskEditingViewController
        )
        Stubber.register(taskEditingRouter.load) {}
        
        var assignedListener: TaskEditingListener? = nil
        
        Stubber.register(taskEditingBuilder.build) { listener, mode in
          assignedListener = listener
          return taskEditingRouter
        }
        
        expect(assignedListener).to(beNil())
        expect(Stubber.executions(taskEditingBuilder.build).count) == 0
        expect(Stubber.executions(taskEditingRouter.load).count) == 0
        
        router.routeToTaskEditing(mode: .new)
        
        expect(assignedListener) === interactor
        expect(Stubber.executions(taskEditingBuilder.build).count) == 1
        expect(Stubber.executions(taskEditingRouter.load).count) == 1
      }
    }
    
    describe("when called closeTaskEditing") {
      it("detach taskEditing RIB") {
        let taskEditingInteractor = TaskEditingInteractableStub()
        Stubber.register(taskEditingInteractor.callSetRouter) {}
        Stubber.register(taskEditingInteractor.callSetActive) { _ in }
        Stubber.register(taskEditingInteractor.callSetListener) {}
        Stubber.register(taskEditingInteractor.activate) {}
        Stubber.register(taskEditingInteractor.deactivate) {}
        
        let taskEditingViewController = TaskEditingViewControllableStub()
        Stubber.register(taskEditingViewController.callSetUIViewController) {}
        
        let taskEditingRouter = TaskEditingRoutingStub(
          interactable: taskEditingInteractor,
          viewControllable: taskEditingViewController
        )
        Stubber.register(taskEditingRouter.load) {}
        
        Stubber.register(taskEditingBuilder.build) { listener, mode in
          return taskEditingRouter
        }
        
        router.routeToTaskEditing(mode: .new)
        
        expect(router.children.filter { $0 === taskEditingRouter }.first).notTo(beNil())
        
        router.closeTaskEditing()
        
        expect(router.children.filter { $0 === taskEditingRouter }.first).to(beNil())
      }
    }
  }
}
