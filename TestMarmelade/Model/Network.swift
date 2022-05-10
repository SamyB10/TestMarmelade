//
//  Network.swift
//  TestMarmelade
//
//  Created by Samy Boussair on 09/05/2022.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://demotivation-quotes-api.herokuapp.com/")!)
}
