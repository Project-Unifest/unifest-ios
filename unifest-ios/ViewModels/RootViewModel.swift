//
//  RootViewModel.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import Foundation
import SwiftUI
import Combine

final class RootViewModel: ObservableObject {
    @Published var viewState: ViewState = .home
    @Published var isLoading: Bool = false
    @ObservedObject var boothModel: BoothModel
    @ObservedObject var festivalModel: FestivalModel
    private var cancellables = Set<AnyCancellable>()

    init(boothModel: BoothModel = BoothModel(), festivalModel: FestivalModel = FestivalModel()) {
        self.boothModel = boothModel
        self.festivalModel = festivalModel
        
        // 앱이 실행될 때 디바이스의 고유 UUID 생성, 이미 존재한다면 UUID값 print
        let uuidManager = DeviceUUIDManager.shared // DeviceUUIDManager의 init() 실행
        let uuid = uuidManager.getDeviceToken()
        print("Device UUID: \(uuid)")
        
        setupBindings()
    }
    
    enum ViewState {
//        case intro // 가천대 특화 UI에서 제외되는 화면
        case home
        case map
        case waiting
        case menu
    }
    
    private func setupBindings() {
        boothModel.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        festivalModel.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func transition(to: ViewState) {
        withAnimation(.spring(duration: 0.2, bounce: 0.3)) {
            viewState = to
        }
    }
}
