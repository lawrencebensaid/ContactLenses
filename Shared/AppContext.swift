//
//  AppContext.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 6/1/22.
//

import SwiftUI

class AppContext: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    enum UserAction: Identifiable {
        case editPair(LensPair)
        case deletePair([LensPair])
        case settings
        
        var id: String { Mirror(reflecting: self).children.first?.label ?? "\(self)" }
    }
    
    enum PresentedSheet: Identifiable {
        case editPair(LensPair)
        case settings
        
        var id: String { Mirror(reflecting: self).children.first?.label ?? "\(self)" }
    }
    
    enum PresentedAlert: Identifiable {
        case deletePair([LensPair])
        case notificationPrompt
        
        var id: String { Mirror(reflecting: self).children.first?.label ?? "\(self)" }
    }
    
    @Published public var presentedSheet: PresentedSheet?
    @Published public var presentedAlert: PresentedAlert?
    
    @AppStorage("authorisedAPN") public var authorisedAPN = false
    
    public override init() {
        super.init()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.authorisedAPN = true
                } else {
                    self.authorisedAPN = false
                    self.presentedAlert = .notificationPrompt
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    public func present(_ action: UserAction) {
        switch action {
        case .settings:
            presentedSheet = .settings
        case .editPair(let pair):
            presentedSheet = .editPair(pair)
        case .deletePair(let pair):
            presentedAlert = .deletePair(pair)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.banner, .badge, .sound, .list])
    }
    
}
