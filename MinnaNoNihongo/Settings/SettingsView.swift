//
//  SettingsView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 18/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @State var isShowKanaEnabled: Bool = true
    @State var isShowRomajiTestEnabled: Bool = true
    @State var isShowFuriganasTestEnabled: Bool = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning").font(.headline)) {
                    Toggle("Show kana chapter", isOn: $isShowKanaEnabled)
                    Toggle("Show romaji", isOn: $isShowRomajiTestEnabled)
                }
                
                Section(header: Text("Testing").font(.headline)) {
                    Toggle("Show furiganas", isOn: $isShowFuriganasTestEnabled)
                }
                
                Section(header: Text("Data").font(.headline)) {
                    Button("Reset learned cards") {}
                }
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
