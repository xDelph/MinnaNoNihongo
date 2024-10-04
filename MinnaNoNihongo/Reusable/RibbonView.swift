//
//  RibbonView.swift
//  MinnaNoNihongo
//
//  Created by Thomas Delalonde on 08/10/2024.
//

import SwiftUI

struct RibbonView: View {
    var text: String
    var value: Int
    
    let trapezoid = Path { path in
        path.move(to: CGPoint(x: -11, y: 17))
        path.addLine(to: CGPoint(x: -29, y: 35))
        path.addLine(to: CGPoint(x: 61, y: 35))
        path.addLine(to: CGPoint(x: 43, y: 17))
    }
    
    init(text: String, value: Int?) {
        self.text = text
        self.value = value ?? 0
    }
    
    var color: Color {
        if value > 2 {
            .green
        } else if value < -2 {
            .red
        } else {
            .orange
        }
    }
    
    var body: some View {
        ZStack{
            Text("")
                .padding()
                .background(color, in: trapezoid)
                .rotationEffect(Angle(degrees: -45))
                .foregroundStyle(.white)
                .position(x: 22, y: 22)
            
            
            Text(text)
                .padding()
                .rotationEffect(Angle(degrees: -45))
                .foregroundStyle(.white)
                .position(x: 24, y: 24)
        }
    }
}

#Preview {
    RibbonView(text: "5", value: 3)
}
