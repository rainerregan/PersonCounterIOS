//
//  PersonCounterIOSApp.swift
//  PersonCounterIOS
//
//  Created by Rainer Regan on 13/07/23.
//

import SwiftUI
import Firebase

@main
struct PersonCounterIOSApp: App {
    @UIApplicationDelegateAdaptor(FirebaseConnection.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(delegate)
        }
    }
}
