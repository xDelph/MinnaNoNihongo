//
//  Router.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 09/10/2024.
//

import SwiftData
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case test
        case train
        case chapter(_ isTraining: Bool, _ selectedChapter: Int)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
