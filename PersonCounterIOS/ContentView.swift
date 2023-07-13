//
//  ContentView.swift
//  PersonCounterIOS
//
//  Created by Rainer Regan on 13/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = "String"
    @EnvironmentObject var firebaseConnectionDelegate: FirebaseConnection
    var timer = Timer()
    @State var frameNum: Int = 0
    
    func updateData(number: Int) {
        firebaseConnectionDelegate.updatePersonCountData(newCountData: number)
    }
    
    var body: some View {
        VStack {
            HostedViewController(){ number in
                text = String(number)
                
                // Update Data every 5 seconds
                if frameNum % 150 == 0 {
                    updateData(number: number)
                    frameNum = 0
                }
                
                frameNum += 1
                
            }.ignoresSafeArea()
            
            HStack {
                Text("Number of people: \(text)")
                    .background(.black)
                    .font(.title)
                    .bold()
            }

        }
    }
}
