//
//  TaskCell.swift
//  RIBsTodo
//
//  Created by myung gi son on 2020/04/19.
//  Copyright © 2020 myunggison. All rights reserved.
//

import UIKit
import ReactorKit

class TaskCell: BaseTableViewCell, ReactorKit.View {
  
  let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .black
    $0.numberOfLines = 2
  }
  
  override func initialize() {
    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.left.equalToSuperview().offset(15)
      make.right.equalToSuperview().offset(-15)
    }
  }
  
  func bind(reactor: TaskCellReactor) {
    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
