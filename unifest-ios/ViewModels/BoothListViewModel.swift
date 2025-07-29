//
//  File.swift
//  unifest-ios
//
//  Created by Yune gim on 7/29/25.
//

import Combine

class BoothListViewModel: ObservableObject {
    private var boothModel: BoothModel
    private let festivalMapDataIndex = FestivalIdManager.festivalMapDataIndex
    private var cancellables = Set<AnyCancellable>()
    
    @Published var boothList: [BoothItem] = []
    var showAvailableBoothOnly: Bool = false
    var campusName: String {
        let festivalMapDataIndex = FestivalIdManager.festivalMapDataIndex
        return festivalMapDataList[festivalMapDataIndex].schoolName
    }
    
    init(_ boothModel: BoothModel) {
        self.boothModel = boothModel
        boothList = boothModel.booths
        bind()
    }
}

// MARK: 내부 구현 메서드
private extension BoothListViewModel {
    private func bind() {
        boothModel.$booths
            .sink { [weak self] boothDatas in
                guard let self else { return }
                if showAvailableBoothOnly {
                    boothList = boothDatas
                        .filter { $0.enabled}
                        .filter { $0.waitingEnabled }
                } else {
                    boothList = boothDatas
                        .filter { $0.enabled}
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: 뷰모델 상태 변경 메서드
extension BoothListViewModel {
    func shouldShowAvailableBoothOnly(_ isShowEnabledBooth: Bool) {
        if isShowEnabledBooth {
            boothList = boothModel.booths
                .filter { $0.enabled}
                .filter { $0.waitingEnabled }
        } else {
            boothList = boothModel.booths
                .filter { $0.enabled}
        }
        showAvailableBoothOnly = isShowEnabledBooth
    }
    
    func selectBooth(_ booth: BoothItem) {
        boothModel.loadBoothDetail(booth.id)
    }
}
