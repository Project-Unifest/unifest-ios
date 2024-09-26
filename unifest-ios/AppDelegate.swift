//
//  AppDelegate.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/14/24.
//

import SwiftUI
import Firebase
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import Firebase
import UserNotifications
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // ADHOC 배포 시
        // https://stackoverflow.com/questions/43754848/how-to-debug-firebase-on-ios-adhoc-build/47594030#47594030
        #if DEBUG
        var newArguments = ProcessInfo.processInfo.arguments
        newArguments.append("-FIRDebugEnabled")
        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        #endif
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { granted, error in
                if granted {
                    
                } else {
                    
                }
            }
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    // 앱이 APNs 토큰을 수신할 때 실행되는 메서드
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Foreground(앱 켜진 상태)일 때 알림을 수신하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // foreground에서 알림이 표시되도록 함
        completionHandler([.list, .banner])
    }
    
    // 알림을 탭했을 때 실행되는 메서드(백그라운드, 디바이스 종료 상태에서도 실행됨)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // userInfo에 접근(aps 메시지와 커스텀 데이터로 구성됨)
        let userInfo = response.notification.request.content.userInfo
        
        // aps 메시지 부분
        if let aps = userInfo["aps"] as? [String: Any] {
            // 메시지의 제목, 본문 등 알림의 내용을 확인할 수 있음
        }
        
        // 커스텀 데이터 부분
        if let boothIdString = userInfo["boothId"] as? String, let boothId = Int(boothIdString) {
            print("페이로드에서 도착한 boothId: \(boothId)")
            print("boothId type: \(type(of: boothId))")
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token in UserDefaults: \(fcmToken)")
        }
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
