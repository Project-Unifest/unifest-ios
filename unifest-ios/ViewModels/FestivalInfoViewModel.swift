//
//  FestivalInfoViewModel.swift
//  unifest-ios
//
//  Created by 김영현 on 7/30/25.
//

import Combine

final class FestivalInfoViewModel: ObservableObject {
    
    private var homeModel = HomeModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var homeCardList: [HomeCard] = []
    @Published var homeTipList: [HomeTip] = []
    
    init() {
        bind()
    }
    
    private func bind() {
        homeModel.$homeCardList
            .sink { [weak self] homeCards in
                guard let self else { return }
                homeCardList = homeCards
            }
            .store(in: &cancellables)
        
        homeModel.$homeTipList
            .sink { [weak self] homeTip in
                guard let self else { return }
                homeTipList = homeTip
            }
            .store(in: &cancellables)
    }
}
