//
//  Operators.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/05/04.
//  Copyright © 2020 myunggison. All rights reserved.
//

import RxSwift

// MARK: - Filter
extension ObservableType {
  func filter<O: ObservableType>(_ predicate: O) -> Observable<E> where O.E == Bool {
    return self
      .withLatestFrom(predicate) { element, predicate in (element, predicate) }
      .filter { _, predicate in predicate }
      .map { element, _ in element }
  }

  func filterNot<O: ObservableType>(_ predicate: O) -> Observable<E> where O.E == Bool {
    return self
      .withLatestFrom(predicate) { element, predicate in (element, predicate) }
      .filter { _, predicate in !predicate }
      .map { element, _ in element }
  }
}
