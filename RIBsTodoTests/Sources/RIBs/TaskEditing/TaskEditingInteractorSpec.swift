//
//  TaskEditingInteractorSpec.swift
//  RIBsTodoTests
//
//  Created by myung gi son on 2020/05/05.
//  Copyright © 2020 myunggison. All rights reserved.
//

import Stubber
import Quick
import Nimble
import RxSwift

@testable import RIBsTodo

final class TaskEditingInteractorSpec: QuickSpec {

  override func spec() {
    super.spec()
    func createRIB(
      mode: TaskEditingViewMode,
      taskService: TaskServiceProtocol = TaskServiceStub(repository: TaskRepositoryStub()),
      alertService: AlertServiceProtocol = AlertServiceStub()
    ) -> (
      taskService: TaskServiceProtocol,
      alertService: AlertServiceProtocol,
      viewController: TaskEditingViewControllableStub,
      interactor: TaskEditingInteractor,
      listener: TaskEditingListenerStub,
      router: TaskEditingRoutingStub
    ) {
        let viewController = TaskEditingViewControllableStub()
        let listener = TaskEditingListenerStub()
        let interactor = TaskEditingInteractor(
          presenter: viewController,
          mode: mode,
          taskService: taskService,
          alertService: alertService
        )
        interactor.listener = listener
        viewController.listener = interactor
        
        let router = TaskEditingRoutingStub(
          interactable: interactor,
          viewControllable: viewController
        )
        interactor.router = router
        
        Stubber.register(router.load) {}
        router.load()
        router.interactable.activate()
      
      return (taskService, alertService, viewController, interactor, listener, router)
    }
    
    describe("an initial state") {
      describe("state.title") {
        context("when mode is .new") {
          it("title is New") {
            let (_, _, _, interactor, _, _) = createRIB(mode: .new)
            expect(interactor.currentState.title) == "New"
          }
        }
        context("when mode is .edit") {
          it("title is Edit") {
            let (_, _, _, interactor, _, _) = createRIB(
              mode: .edit(TaskFixture.task1)
            )
            expect(interactor.currentState.title) == "Edit"
          }
        }
      }
      describe("state.taskTitle") {
        context("when mode is .new") {
          it("is empty") {
            let (_, _, _, interactor, _, _) = createRIB(mode: .new)
            expect(interactor.currentState.taskTitle) == ""
          }
        }
        context("when mode is .edit") {
          it("is task.title") {
            let (_, _, _, interactor, _, _) = createRIB(
              mode: .edit(TaskFixture.task1)
            )
            expect(interactor.currentState.taskTitle) == TaskFixture.task1.title
          }
        }
      }
      describe("state.canSubmit") {
        context("when mode is .new") {
          it("is false") {
            let (_, _, _, interactor, _, _) = createRIB(mode: .new)
            expect(interactor.currentState.canSubmit) == false
          }
        }
        context("when mode is .edit") {
          it("is true") {
            let (_, _, _, interactor, _, _) = createRIB(
              mode: .edit(TaskFixture.task1)
            )
            expect(interactor.currentState.canSubmit) == true
          }
        }
      }
      describe("state.shouldConfirmCancel") {
        context("when mode is .new") {
          it("is false") {
            let (_, _, _, interactor, _, _) = createRIB(mode: .new)
            expect(interactor.currentState.shouldConfirmCancel) == false
          }
        }
        context("when mode is .edit") {
          it("is false") {
            let (_, _, _, interactor, _, _) = createRIB(
              mode: .edit(TaskFixture.task1)
            )
            expect(interactor.currentState.shouldConfirmCancel) == false
          }
        }
      }
    }
    
    context("when receives a updateTaskTitle action") {
      it("update state.taskTitle") {
        let (_, _, viewController, interactor, _, _) = createRIB(
          mode: .edit(TaskFixture.task1)
        )
        viewController.listener?.action.onNext(.updateTaskTitle("a"))
        expect(interactor.currentState.taskTitle) == "a"
        viewController.listener?.action.onNext(.updateTaskTitle("ab"))
        expect(interactor.currentState.taskTitle) == "ab"
        viewController.listener?.action.onNext(.updateTaskTitle(""))
        expect(interactor.currentState.taskTitle) == ""
      }
      it("change state.canSubmit") {
        let (_, _, viewController, interactor, _, _) = createRIB(
          mode: .edit(TaskFixture.task1)
        )
        expect(interactor.currentState.canSubmit) == true
        viewController.listener?.action.onNext(.updateTaskTitle("a"))
        expect(interactor.currentState.canSubmit) == true
        viewController.listener?.action.onNext(.updateTaskTitle("ab"))
        expect(interactor.currentState.canSubmit) == true
        viewController.listener?.action.onNext(.updateTaskTitle(""))
        expect(interactor.currentState.canSubmit) == false
      }
      it("change state.shouldComfirmCancel") {
        let (_, _, viewController, interactor, _, _) = createRIB(
          mode: .edit(TaskFixture.task1)
        )
        expect(interactor.currentState.shouldConfirmCancel) == false
        viewController.listener?.action.onNext(.updateTaskTitle("a"))
        expect(interactor.currentState.shouldConfirmCancel) == true
        viewController.listener?.action.onNext(.updateTaskTitle(TaskFixture.task1.title))
        expect(interactor.currentState.shouldConfirmCancel) == false
      }
    }
    
    context("when mode is .edit") {
      context("when receives a submit action") {
        it("edit task") {
          let taskService = TaskServiceStub(repository: TaskRepositoryFake())
          let (_, _, viewController, _, listener, _) = createRIB(
            mode: .edit(TaskFixture.task1),
            taskService: taskService
          )
          Stubber.register(taskService.update) { _ in .just(Void()) }
          Stubber.register(listener.taskEditingDidFinish) {}
          viewController.listener?.action.onNext(.updateTaskTitle("a"))
          viewController.listener?.action.onNext(.submit)
          expect(Stubber.executions(taskService.update).count) == 1
          expect(Stubber.executions(listener.taskEditingDidFinish).count) == 1
        }
      }
    }
    
    context("when mode is .new") {
      context("when receives a submit action") {
        it("create task") {
          let taskService = TaskServiceStub(repository: TaskRepositoryFake())
          let (_, _, viewController, _, listener, _) = createRIB(
            mode: .new,
            taskService: taskService
          )
          Stubber.register(taskService.create) { _ in .just(Void()) }
          Stubber.register(listener.taskEditingDidFinish) {}
          viewController.listener?.action.onNext(.updateTaskTitle("a"))
          viewController.listener?.action.onNext(.submit)
          expect(Stubber.executions(taskService.create).count) == 1
          expect(Stubber.executions(listener.taskEditingDidFinish).count) == 1
        }
      }
    }
  }
}
