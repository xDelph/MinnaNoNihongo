//
//  HomeView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 09/10/2024.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    
    let modelContainer: ModelContainer
    
    @State private var showSettings: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("Minna no nihongo")
                .font(.system(size: 40))
                .bold()
            Text("flashcards")
                .font(.title2)
                .italic()
            
            Spacer()
            
            Button() {
                router.navigate(to: .train)
            } label: {
                HStack {
                    Spacer()
                    Text("Training")
                        .foregroundColor(.white)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .frame(maxWidth: 200)
            .padding()
            .background(.blue)
            .cornerRadius(10)
            
            Button {
                router.navigate(to: .test)
            } label: {
                HStack {
                    Spacer()
                    Text("Test yourself")
                        .foregroundColor(.white)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .frame(maxWidth: 200)
            .padding()
            .background(.red)
            .cornerRadius(10)
            .shadow(color: .red, radius: 15, y: 5)
            
            Spacer()
            Spacer()
            
            Button {
                showSettings.toggle()
            } label: {
                Text("settings")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .frame(maxWidth: 100, maxHeight: 10)
            .padding(10)
            .background(.gray)
            .cornerRadius(10)
        }.sheet(isPresented: $showSettings) {
            SettingsView(modelContainer: modelContainer)
        }
    }
}

#Preview {
     HomeView(modelContainer: previewContainer)
}
