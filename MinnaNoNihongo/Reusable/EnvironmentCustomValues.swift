//
//  EnvironmentCustomValues.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 13/10/2024.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var isTraining: Bool = .init(true)
    @Entry var chapterSelected: Int = .init(1)
}

extension View {
    func isTraining(_ myCustomValue: Bool) -> some View {
        environment(\.isTraining, myCustomValue)
    }
    
    func selectChapter(_ myCustomValue: Int) -> some View {
        environment(\.chapterSelected, myCustomValue)
    }
}
