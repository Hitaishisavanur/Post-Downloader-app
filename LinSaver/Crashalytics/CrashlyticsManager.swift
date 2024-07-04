//
//  CrashalyticsManager.swift
//  LinSaver
//
//  Created by Hitaishi Savanur on 26/06/24.
//

import Foundation
import FirebaseCrashlytics

final class CrashlyticsManager: ObservableObject{
    static let shared = CrashlyticsManager()
    private init(){}
    
    func addLog(message: String){
        Crashlytics.crashlytics().log(message)
    }
}
