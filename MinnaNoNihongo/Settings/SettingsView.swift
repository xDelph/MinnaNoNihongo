//
//  SettingsView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 18/10/2024.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    let modelContainer: ModelContainer
    
    @State var isShowKanaEnabled: Bool = true
    
    @AppStorage(.settingsUserShowFuriginasTesting)
    private var isShowFuriganasTestEnabled: Bool = true
    
    @AppStorage(.settingsUserShowRomajiLearning)
    private var isShowRomajiTestEnabled: Bool = true
    
    @State private var resetting: Bool = false
    @State private var isResetAlertPresented: Bool = false
    @State private var isPresentingConfirm: Bool = false
    
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
                    Button("Reset learned cards") {
                        isPresentingConfirm.toggle()
                    }
                }
            }
            .navigationTitle(Text("Settings"))
        }
        .allowsHitTesting(!resetting || !isPresentingConfirm)
        .confirmationDialog("Are you sure?",
          isPresented: $isPresentingConfirm) {
          Button("Reset learned cards ?", role: .destructive) {
              Task {    
                  self.resetting.toggle()
                  try? await ThreadsafeBackgroundCardActor(modelContainer: modelContainer).resetValues()
                  self.isResetAlertPresented.toggle()
              }
          }
        } message: {
          Text("You cannot undo this action")
        }
        .alert(isPresented: $isResetAlertPresented) {
            Alert(title: Text("Reset complete"),
                  dismissButton: .default(Text("OK")) {
                        self.resetting.toggle()
                    }
                  )
            }
    }
}

#Preview {
    SettingsView(modelContainer: previewContainer)
}
