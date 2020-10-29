//
//  ContentView.swift
//  Emerald
//
//  Created by Горячев Александр on 03.10.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var startXPos: CGFloat = 0
    @State var startYPos: CGFloat = 0
    @State var startRealYPos: CGFloat = 0
    @State var startRealXPos: CGFloat = 0
    @State var newstartXPos: CGFloat = 0
    @State var newstartYPos: CGFloat = 0
    @State var newstartRealYPos: CGFloat = 0
    @State var newstartRealXPos: CGFloat = 0
    @State var changeCounter: Int = 0
    @State var drawType: String = ""

        var body: some View {
            VStack {
                ZStack {
            GeometryReader { geo in
                Rectangle().frame(width: 800, height: 800, alignment: .center).foregroundColor(.green).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged{ dragGesture in
                    if changeCounter == 0 {
                    
                    self.startXPos = dragGesture.location.x
                    self.startYPos = dragGesture.location.y
                    self.changeCounter += 1
                    }
                    self.startRealXPos = dragGesture.location.x
                    self.startRealYPos = dragGesture.location.y
//                    self.newstartXPos = self.startXPos
//                    self.newstartYPos = self.startYPos
//                    self.newstartRealXPos = self.startRealXPos
//                    self.newstartRealYPos = self.startRealYPos
                    
                    
                        }
                .onEnded { dragGesture in
                    self.changeCounter = 0
                    equasion()

            })
                    if drawType == "rectangle" {
                        Path() {path in
                            
                            
                            
                            path.addRect(CGRect(x: startXPos, y: startYPos, width: startRealXPos-startXPos, height: startRealYPos-startYPos))
                            equasion()
                            

                        }
                    }
                    if drawType == "choosing" {
                        Path() { path in
                            path.addRect(CGRect(x: newstartXPos, y: newstartYPos, width: -newstartXPos+newstartRealXPos, height: -newstartYPos+newstartRealYPos))
                            
                        }.stroke(Color.blue, lineWidth: 5)
                        
                    }
                }
            
            HStack {
                Text("Xvalue: \(self.startRealXPos)")
                Spacer().frame(width:50)
                Text("Yvalue: \(self.startRealYPos)")
                Spacer().frame(width: 50)
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
            }
        }
           
            
            
        }
    func equasion() {
        self.newstartXPos = self.startXPos
        self.newstartYPos = self.startYPos
        self.newstartRealXPos = self.startRealXPos
        self.newstartRealYPos = self.startRealYPos
    }
    
    
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
