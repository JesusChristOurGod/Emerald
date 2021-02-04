//
//  StructView.swift
//  Emerald
//
//  Created by Горячев Александр on 20.10.2020.
//

import SwiftUI

func colorGenerator() -> Color {
    return Color( red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), opacity: 1.0)
}

struct CoordsProcessor: View {
    var startX: CGFloat?
    var startY: CGFloat?
    var currentX: CGFloat?
    var currentY: CGFloat?
    var drawType: String?
    var shapes: [ShapeModel] = []
    var currentSelectionModel: SelectModel?
    //Dirty hack
    var body: some View {Text("")}
    
    mutating func addShape(selStartX: CGFloat, selStartY: CGFloat, selCurrentX: CGFloat,selCurrentY: CGFloat) {
        self.shapes.append(.init( id: .init(), color: colorGenerator(), startX: selStartX, startY: selStartY, currentX: selCurrentX, currentY: selCurrentY, highlighted: false))
    }
    
    mutating func addCurrentCoords(startX: CGFloat, startY: CGFloat, currentX: CGFloat,currentY: CGFloat) {
        self.startX = startX
        self.startY = startY
        self.currentX = currentX
        self.currentY = currentY
    }
    
    mutating func processControlFigureResult() {
        let sx = self.startX ?? 0
        let sy = self.startY ?? 0
        let cx = self.currentX ?? 0
        let cy = self.currentY ?? 0
        
        self.addShape(selStartX: sx, selStartY: sy, selCurrentX: cx, selCurrentY: cy)
        self.resetCoords()
    }
    
    mutating func setDrawType(type: String) {
        self.drawType = type
    }
    
    mutating func resetCoords() {
        self.startX = nil
        self.startY = nil
        self.currentX = nil
        self.currentY = nil
    }
    
    func isCurrentCoordsFilled() -> Bool {
        if (self.startX == nil || self.startY == nil || self.currentX == nil || self.currentY == nil) {
            return false
        }
        
        return true
    }
    
    //TODO Implement control figure for each state of tool: rectangle, choosing, etc
    //TODO Implement else statement a bit more correctly
    func drawControlFigure() -> some View {
        let sx = self.startX ?? 0
        let sy = self.startY ?? 0
        let cx = self.currentX ?? 0
        let cy = self.currentY ?? 0
        
        if (self.isCurrentCoordsFilled()) {
            return Path() { path in
                path.addRect(CGRect(x: sx, y: sy, width: cx - sx, height: cy - sy))
            }.stroke(style: StrokeStyle( lineWidth: 1, dash: [5])).foregroundColor(Color.black)
        } else {
            return Path() { path in
                path.addRect(CGRect(x: 0, y: 0, width: 0, height: 0))
            }.stroke(style: StrokeStyle( lineWidth: 0, dash: [0])).foregroundColor(Color.black)
        }
    }
}

struct StructView: View {
    @State var coordsProcessor: CoordsProcessor = CoordsProcessor();
    @State var data: [ShapeModel] = []
    @State var selectData: [SelectModel] = []
    @State var isToolDisactivated = true;
    @State var startXPos: CGFloat = 0
    @State var startYPos: CGFloat = 0
    @State var startRealYPos: CGFloat = 0
    @State var startRealXPos: CGFloat = 0
    @State var drawType: String = ""
    @State var isIt: Bool = false
    var body: some View {
        VStack {
        ZStack {
            GeometryReader{ geo in
                Rectangle().frame(width: 800, height:800, alignment: .center).foregroundColor(.gray).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged{ dragGesture in
                    if self.isToolDisactivated {
                        self.startXPos = dragGesture.location.x
                        self.startYPos = dragGesture.location.y
                        self.isToolDisactivated = false
                    }
                    self.startRealXPos = dragGesture.location.x
                    self.startRealYPos = dragGesture.location.y
                    
                    coordsProcessor.addCurrentCoords(startX: self.startXPos, startY: self.startYPos, currentX: self.startRealXPos, currentY: self.startRealYPos)
                    
                }
                .onEnded{dragGesture in
                    self.isToolDisactivated = true;
                    coordsProcessor.processControlFigureResult();
                }
            )
            coordsProcessor.drawControlFigure()
            ForEach(coordsProcessor.shapes){ shape in
                ShapeViewer(data: shape)
            }
            
//            if coordsProcessor.drawType == "rectangle" {
//                Path() { path in
//                    path.addRect(CGRect(x: self.startXPos, y: self.startYPos, width: self.startRealXPos-self.startXPos, height: self.startRealYPos-self.startYPos))
//                }.stroke(Color.blue, lineWidth: 5)
//            }
//            Path() { path in
//                path.addRect(CGRect(x: self.startXPos, y: self.startYPos, width: self.startRealXPos-self.startXPos, height: self.startRealYPos-self.startYPos))
//            }.stroke(Color.blue, lineWidth: 5)

//            ForEach(data){ items in
//                ShapeViewer(data: items)
//                if (selectData[0].selCurrentX > items.startX && selectData[0].selCurrentX < items.currentX) {
//                    isIt =  true
//                }
//                if (selectData[0].selStartX > items.startX && selectData[0].selStartX < items.currentX) {
//                    isIt =  true
//                }
//
//
//                if (selectData[0].selCurrentX>items.currentX && selectData[0].selStartX < items.startX && selectData[0].selCurrentY>items.currentY && selectData[0].selStartX < items.startY ) {
//                    isIt =  true
//                }
//                if (selectData[0].selStartX>items.currentX && selectData[0].selCurrentY < items.startX && selectData[0].selStartY>items.currentY && selectData[0].selCurrentY < items.startY ) {
//                    isIt =  true
//                }
//
//
//                if (selectData[0].selCurrentY>items.currentX && selectData[0].selStartX < items.startX && selectData[0].selCurrentY<items.currentY && selectData[0].selCurrentY>items.startY  && selectData[0].selStartY < items.startY ) {
//                    isIt =  true
//                }
//                if (selectData[0].selStartX>items.currentX && selectData[0].selCurrentX < items.startX && selectData[0].selStartY<items.currentY && selectData[0].selStartY>items.startY && selectData[0].selCurrentY < items.startY ) {
//                    isIt =  true
//                }
//
//
//                if (selectData[0].selCurrentY>items.currentY && selectData[0].selCurrentY > items.currentX && selectData[0].selStartX < items.startX && selectData[0].selStartY > items.startY && selectData[0].selStarY < items.currentY) {
//                    isIt =  true
//                }
//                if (selectData[0].selStartY>items.currentY && selectData[0].selStartX > items.currentX && selectData[0].selCurrentY < items.startX && selectData[0].selCurrentY > items.startY && selectData[0].selCurrentY < items.currentY) {
//                    isIt =  true
//                }
//                items.highlighted = true
//            }
            ForEach(selectData) { items in
                SelectViewer(selectData: items)
            }
                HStack {
                    Button(action: {
                        coordsProcessor.setDrawType(type: "rectangle")
                        
                    }) {
                        Text ("Rectangle").frame(width: 100, height: 20)
                    }
                    Button(action: {
                        coordsProcessor.setDrawType(type: "choosing")
                        
                    }) {
                        Text ("Choosing").frame(width: 100, height: 20)
                    }
                }.position(x: UIScreen.main.bounds.width/2, y: 1000)
        }
        }
    }
    
    
//    func isSelected() -> Bool {
//        var isIt: Bool = false
//        var selectStartX: CGFloat = 0
//        var selectStartY: CGFloat = 0
//        var selectEndX: CGFloat = 0
//        var selectEndY: CGFloat = 0
//
//        data.forEach { items in
//            if (selectEndX > items.startX && selectEndX < items.currentX) {
//                isIt =  true
//            }
//            if (selectStartX > items.startX && selectStartX < items.currentX) {
//                isIt =  true
//            }
//
//
//            if (selectEndX>items.currentX && selectStartX < items.startX && selectEndY>items.currentY && selectStartY < items.startY ) {
//                isIt =  true
//            }
//            if (selectStartX>items.currentX && selectEndX < items.startX && selectStartY>items.currentY && selectEndY < items.startY ) {
//                isIt =  true
//            }
//
//
//            if (selectEndX>items.currentX && selectStartX < items.startX && selectEndY<items.currentY && selectEndY>items.startY  && selectStartY < items.startY ) {
//                isIt =  true
//            }
//            if (selectStartX>items.currentX && selectEndX < items.startX && selectStartY<items.currentY && selectStartY>items.startY && selectEndY < items.startY ) {
//                isIt =  true
//            }
//
//
//            if (selectEndY>items.currentY && selectEndX > items.currentX && selectStartX < items.startX && selectStartY > items.startY && selectStartY < items.currentY) {
//                isIt =  true
//            }
//            if (selectStartY>items.currentY && selectStartX > items.currentX && selectEndX < items.startX && selectEndY > items.startY && selectEndY < items.currentY) {
//                isIt =  true
//            }
//
//        }
//        return isIt
//    }
}

struct ShapeModel: Identifiable {
    var id: UUID
    var color: Color
    var startX: CGFloat
    var startY: CGFloat
    var currentX: CGFloat
    var currentY: CGFloat
    var highlighted: Bool
}

// TODO add correct color fill behavior
// Interprated with https://stackoverflow.com/questions/56786163/swiftui-how-to-draw-filled-and-stroked-shape
struct ShapeViewer: View {
    var data: ShapeModel
    var body: some View {
        Path() { path in
            path.addRect(CGRect(x: self.data.startX, y: self.data.startY, width: self.data.currentX-self.data.startX, height: self.data.currentY-self.data.startY))
        }.overlay(
            Path() { path in
                path.addRect(CGRect(x: self.data.startX, y: self.data.startY, width: self.data.currentX-self.data.startX, height: self.data.currentY-self.data.startY))
            }
        ).foregroundColor(self.data.color)
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
        }.stroke(Color.blue)
    }
}

struct StructView_Previews: PreviewProvider {
    static var previews: some View {
        StructView()
    }
}
