//
//  ContentView.swift
//  PersonCounterIOS
//
//  Created by Rainer Regan on 13/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = "String"
    
    var body: some View {
        VStack {
            HostedViewController(){ number in
                text = String(number)
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
