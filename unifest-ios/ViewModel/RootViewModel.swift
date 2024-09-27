//
//  RootViewModel.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import Foundation
import SwiftUI
import Combine

class RootViewModel: ObservableObject {
    @Published var viewState: ViewState = .home
    @Published var isLoading: Bool = false
    @ObservedObject var boothModel: BoothModel
    @ObservedObject var festivalModel: FestivalModel
    private var cancellables = Set<AnyCancellable>()

    init(boothModel: BoothModel = BoothModel(), festivalModel: FestivalModel = FestivalModel()) {
        self.boothModel = boothModel
        self.festivalModel = festivalModel
        
        setupBindings()
    }
    
    enum ViewState {
        case intro
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
    
    // 사용 안됨
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            self.transition(to: .intro)
        } else {
            self.transition(to: .home)
        }
    }
}
