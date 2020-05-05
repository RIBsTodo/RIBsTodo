//
//  RootRouterSpec.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import Quick
import Nimble
import RxSwift
import RIBs

@testable import RIBsTodo

final class RootRouterSpec: QuickSpec {
  
  override func spec() {
    super.spec()
    
    var tasksBuilder: TasksBuildableStub!
    var interactor: RootInteractableStub!
    var router: RootRouter!
    
    beforeEach {
      tasksBuilder = TasksBuildableStub()
      interactor = RootInteractableStub()
      Stubber.register(interactor.callSetRouter) {}
      Stubber.register(interactor.callSetActive) { _ in }
      Stubber.register(interactor.callSetListener) {}
      Stubber.register(interactor.activate) {}
      Stubber.register(interactor.deactivate) {}
      
      let viewController = RootViewControllableStub()
      Stubber.register(viewController.callSetUIViewController) {}
      Stubber.register(viewController.replaceChildViewController) { _ in }
      
      router = RootRouter(
        interactor: interactor,
        viewController: viewController,
        tasksBuilder: tasksBuilder
      )
    }
    
    describe("when called routeToTasks") {
      it("attach tasks RIB") {
        let tasksInteractor = TasksInteractableStub()
        Stubber.register(tasksInteractor.callSetRouter) {}
        Stubber.register(tasksInteractor.callSetActive) { _ in }
        Stubber.register(tasksInteractor.callSetListener) {}
        Stubber.register(tasksInteractor.activate) {}
        Stubber.register(tasksInteractor.deactivate) {}
        
        let tasksViewController = TasksViewControllableStub()
        Stubber.register(tasksViewController.callSetUIViewController) {}
        
        let tasksRouter = TasksRoutingStub(
          interactable: tasksInteractor,
          viewControllable: tasksViewController
        )
        Stubber.register(tasksRouter.load) {}
        
        var assignedListener: TasksListener? = nil
        
        Stubber.register(tasksBuilder.build) { listener in
          assignedListener = listener
          return tasksRouter
        }
        
        expect(assignedListener).to(beNil())
        expect(Stubber.executions(tasksBuilder.build).count) == 0
        expect(Stubber.executions(tasksRouter.load).count) == 0
        
        router.routeToTasks()
        
        expect(assignedListener) === interactor
        expect(Stubber.executions(tasksBuilder.build).count) == 1
        expect(Stubber.executions(tasksRouter.load).count) == 1
      }
    }
  }
}
