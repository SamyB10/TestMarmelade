//
//  Box.swift
//  TestMarmelade
//
//  Created by Samy Boussair on 09/05/2022.
//

import Foundation

final class Box<T> {

  typealias Listener = (T) -> Void
  var listener: Listener?

  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
