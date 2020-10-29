//
//  StructView.swift
//  Emerald
//
//  Created by Горячев Александр on 20.10.2020.
//

import SwiftUI

struct StructView: View {
    var data: [ShapeModel] = [
//        .init(id: 1, color: .red, startX: 120, startY: 275, currentX: 200, currentY: 350),
//        .init(id: 2, color: .yellow, startX: 100, startY: 320, currentX: 300, currentY: 470)

    ]
    @State var changeCounter: Int = 0
    @State var startXPos: CGFloat = 0
    @State var startYPos: CGFloat = 0
    @State var startRealYPos: CGFloat = 0
    @State var startRealXPos: CGFloat = 0
    var body: some View {
        ZStack {
            GeometryReader{ geo in
                Rectangle().frame(width: 800, height:800, alignment: .center).foregroundColor(.blue).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged{ dragGesture in
                            if changeCounter == 0 {
                                self.startXPos = dragGesture.location.x
                                self.startYPos = dragGesture.location.y
                                self.changeCounter += 1
                            }
                            self.startRealXPos = dragGesture.location.x
                            self.startRealYPos = dragGesture.location.y
                        }
                        .onEnded{dragGesture in
                            
                            self.changeCounter = 0
                            data.append(.init(id: 3, color: colorGenerator(), startX: startXPos, startY: startYPos, currentX: startRealXPos, currentY: startRealYPos))
                        }
            )
            
            
                
           
            ForEach(data){ items in
                ShapeViewer(data: items)
            }
         
        }
    }
    
    func colorGenerator() -> Color {
        return  Color.init(red: Double((Int.random(in: 0..<255)/255)), green: Double((Int.random(in: 0..<255)/255)), blue: Double((Int.random(in: 0..<255)/255)))
       
    }
}

struct ShapeModel: Identifiable {
    var id: Int
    var color: Color
    var startX: CGFloat
    var startY: CGFloat
    var currentX: CGFloat
    var currentY: CGFloat
}

struct ShapeViewer: View {
    var data: ShapeModel
    var body: some View {
        Path{ path in
            path.addRect(CGRect(x: self.data.startX, y: self.data.startY, width: self.data.currentX-self.data.startX, height: self.data.currentY-self.data.startY))
        }.foregroundColor(self.data.color)
    }
}

struct StructView_Previews: PreviewProvider {
    static var previews: some View {
        StructView()
    }
}
