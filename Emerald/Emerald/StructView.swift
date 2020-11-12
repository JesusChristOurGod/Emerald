//
//  StructView.swift
//  Emerald
//
//  Created by Горячев Александр on 20.10.2020.
//

import SwiftUI

struct StructView: View {
   @State var data: [ShapeModel] = []
    @State var selectData: [SelectModel] = []
    @State var changeCounter: Int = 0
    @State var startXPos: CGFloat = 0
    @State var startYPos: CGFloat = 0
    @State var startRealYPos: CGFloat = 0
    @State var startRealXPos: CGFloat = 0
    @State var drawType: String = ""
    var body: some View {
        VStack {
        ZStack {
            GeometryReader{ geo in
                Rectangle().frame(width: 800, height:800, alignment: .center).foregroundColor(.gray).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
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
                            if self.drawType == "rectangle" {
                            data.append(.init( id: .init(), color: colorGenerator(), startX: self.startXPos, startY: self.startYPos, currentX: self.startRealXPos, currentY: self.startRealYPos))
                            self.changeCounter = 0
                            }
                            if self.drawType=="choosing" {
                                selectData.append(.init(id: .init(), selStartX: self.startXPos, selStartY: self.startYPos, selCurrentX: self.startRealXPos, selCurrentY: self.startRealYPos))

                            }
                            
                        }
            )
            ForEach(data){ items in
                ShapeViewer(data: items)
            }
            ForEach(selectData) { items in
                SelectViewer(selectData: items)
            }
                HStack {
                    Button(action: {
                        self.drawType = "rectangle"
                        
                    }) {
                        Text ("Rectangle").frame(width: 100, height: 20)
                    }
                    Button(action: {
                        self.drawType = "choosing"
                        
                    }) {
                        Text ("Choosing").frame(width: 100, height: 20)
                    }
                }.position(x: UIScreen.main.bounds.width/2, y: 1000)
        }
        }
    }
    
    func colorGenerator() -> Color {
        return  Color( red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1.0)
       
    }
    
    
    func isSelected() -> Bool {
        var isIt: Bool = false
        var selectStartX: CGFloat = 0
        var selectStartY: CGFloat = 0
        var selectEndX: CGFloat = 0
        var selectEndY: CGFloat = 0
        
        data.forEach { items in
            if (selectEndX > items.startX && selectEndX < items.currentX) {
                isIt =  true
            }
            if (selectStartX > items.startX && selectStartX < items.currentX) {
                isIt =  true
            }
            
            
            if (selectEndX>items.currentX && selectStartX < items.startX && selectEndY>items.currentY && selectStartY < items.startY ) {
                isIt =  true
            }
            if (selectStartX>items.currentX && selectEndX < items.startX && selectStartY>items.currentY && selectEndY < items.startY ) {
                isIt =  true
            }
            
            
            if (selectEndX>items.currentX && selectStartX < items.startX && selectEndY<items.currentY && selectEndY>items.startY  && selectStartY < items.startY ) {
                isIt =  true
            }
            if (selectStartX>items.currentX && selectEndX < items.startX && selectStartY<items.currentY && selectStartY>items.startY && selectEndY < items.startY ) {
                isIt =  true
            }
            
            
            if (selectEndY>items.currentY && selectEndX > items.currentX && selectStartX < items.startX && selectStartY > items.startY && selectStartY < items.currentY) {
                isIt =  true
            }
            if (selectStartY>items.currentY && selectStartX > items.currentX && selectEndX < items.startX && selectEndY > items.startY && selectEndY < items.currentY) {
                isIt =  true
            }
            
        }
        return isIt
    }
}

struct ShapeModel: Identifiable {
    var id: UUID
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

struct SelectModel: Identifiable {
    var id: UUID
    var selStartX: CGFloat
    var selStartY: CGFloat
    var selCurrentX: CGFloat
    var selCurrentY: CGFloat
}
struct SelectViewer:View {
    var selectData:SelectModel
    var body: some View {
        Path{ path in
            path.addRect(CGRect(x: self.selectData.selStartX, y: self.selectData.selStartY, width: self.selectData.selCurrentX-self.selectData.selStartX, height: self.selectData.selCurrentY-self.selectData.selStartY))
        }.stroke(Color.blue,style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}


struct StructView_Previews: PreviewProvider {
    static var previews: some View {
        StructView()
    }
}
