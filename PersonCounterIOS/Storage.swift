//
//  Storage.swift
//  PersonCounterIOS
//
//  Created by Rainer Regan on 13/07/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

class FirebaseConnection: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        print("Firebase connected")
        
        return true
    }
    
    func saveSampleData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("sample").child("sample-1").setValue(["data1": 1234])
        print("Data saved")
    }
    
    func updatePersonCountData(newCountData: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // TODO: Update Camera name
        ref.child("camera_1")
            .setValue([
                "person_count": newCountData,
                "last_updated": [".sv": "timestamp"]
            ])
        
        print("New count: \(newCountData)")
    }
}
