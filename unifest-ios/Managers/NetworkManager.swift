//
//  NetworkManager.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/7/24.
//

import Network
import SwiftUI

/// Network 연결 상태를 감시하는 Network Manager Class
final class NetworkManager: ObservableObject {
    // NWPathMonitor를 사용하여 실시간으로 네트워크 상태를 감시
    private let monitor = NWPathMonitor()
    // Background Queue 생성
    private let queue = DispatchQueue(label: "NetworkManager")
    // 네트워크 연결 상태를 저장하는 published property
    @Published var isConnected = true

    init() {
        // MWPathMonitor에 네트워크 상태 변경 핸들러를 설정,
        // 네트워크 설정이 변경될 때마다 호출되어 변경된 상태를 저장함
        monitor.pathUpdateHandler = { path in
            // 메인 큐에서 실행되도록 설정
            DispatchQueue.main.async {
                // 네트워크 상태를 업데이트
                self.isConnected = path.status == .satisfied
            }
        }
        // 네트워크 모니터 시작
        monitor.start(queue: queue)
    }
}

/// NetworkManager를 테스트할 수 있는 뷰
struct NetworkManagerTestView: View {
    // NetworkManager Instantiation
    @StateObject private var networkManager = NetworkManager()
    
    var body: some View {
        Group {
            // 네트워크 연결이 필요한 뷰에서 아래처럼 사용할 수 있음
            if !networkManager.isConnected {
                // 네트워크 연결 유실 시
                Text("No Network Connection")
            } else {
                // 네트워크 연결 시
                Text("Connected")
            }
        }
    }
}

#Preview {
    NetworkManagerTestView()
}

