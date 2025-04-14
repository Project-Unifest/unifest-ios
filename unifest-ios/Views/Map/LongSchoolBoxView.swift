//
//  LongSchoolView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/2/24.
//

import SwiftUI

struct LongSchoolBoxView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    let festivalId: Int
    //    let isFavoriteFestival: Bool
    let thumbnail: String
    let schoolName: String
    let festivalName: String
    let startDate: String
    let endDate: String
    @Binding var isUpdatingFavoriteFestival: Bool
    @EnvironmentObject var favoriteFestivalVM: FavoriteFestivalViewModel
    @State private var throttleManager = ThrottleManager(throttleInterval: 1.5)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: thumbnail)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 52, height: 52)
                            .scaledToFit()
                            .clipShape(.circle)
                            .padding(.trailing, 4)
                    case .failure:
                        Circle()
                            .fill(.grey500)
                            .frame(width: 35, height: 35)
                            .padding(.bottom, 4)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 52, height: 52)
                .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                .onTapGesture {
                    print("썸네일 누른 상태에서의 festivalId: \(festivalId)")
                    mapViewModel.mapSelectedFestivalId = festivalId
                    HapticManager.shared.hapticImpact(style: .light)
                    if let index = festivalMapDataList.firstIndex(where: { $0.festivalId == festivalId }) {
                        mapViewModel.festivalMapDataIndex = index
                    }
                    
                    mapViewModel.forceRefreshMapPageView = UUID()
                    
                    dismiss()
                }
                
                VStack(alignment: .leading) {
                    Text(schoolName)
                        .font(.pretendard(weight: .p4, size: 13))
                        .foregroundStyle(.grey900)
                    
                    Text(festivalName)
                        .font(.pretendard(weight: .p7, size: 12))
                        .foregroundStyle(.grey900)
                    
                    Text(startDate + "-" + endDate)
                        .font(.pretendard(weight: .p4, size: 12))
                        .foregroundStyle(.grey600)
                }
                
                Spacer()
                
                Button {
                    Task {
                        isUpdatingFavoriteFestival = true
                        let deviceId = DeviceUUIDManager.shared.getDeviceToken()
                        let isFavoriteFestival = favoriteFestivalVM.favoriteFestivalList.contains(festivalId)
                        
                        if isFavoriteFestival {
                            await throttleManager.throttle {
                                await favoriteFestivalVM.deleteFavoriteFestival(festivalId: festivalId, deviceId: deviceId)
                                await favoriteFestivalVM.getFavoriteFestivalList(deviceId: DeviceUUIDManager.shared.getDeviceToken())
                                favoriteFestivalVM.updateSucceededToast = Toast(style: .success, message: "'\(festivalName)'을/를 관심축제에서 삭제했어요")
                            }
                        } else {
                            await throttleManager.throttle {
                                await favoriteFestivalVM.addFavoriteFestival(festivalId: festivalId, deviceId: deviceId)
                                await favoriteFestivalVM.getFavoriteFestivalList(deviceId: DeviceUUIDManager.shared.getDeviceToken())
                                favoriteFestivalVM.updateSucceededToast = Toast(style: .success, message: "'\(festivalName)'을/를 관심축제에 추가했어요")
                            }
                        }
                        isUpdatingFavoriteFestival = false
                    }
                } label: {
                    Capsule()
                        .strokeBorder(.primary500, lineWidth: 1)
                        .frame(width: 57, height: 29)
                        .background(
                            favoriteFestivalVM.favoriteFestivalList.contains(festivalId)
                            ? Capsule().fill(.primary500)
                            : Capsule().fill(.ufBackground)
                        )
                        .overlay {
                            if favoriteFestivalVM.favoriteFestivalList.contains(festivalId) {
                                Image(.check)
                                    .resizable()
                                    .frame(width: 15, height: 10)
                            } else {
                                Text("추가")
                                    .font(.pretendard(weight: .p5, size: 12))
                                    .foregroundStyle(favoriteFestivalVM.favoriteFestivalList.contains(festivalId) ? .white : .primary500)
                            }
                        }
                }
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    LongSchoolBoxView(viewModel: RootViewModel(), mapViewModel:  MapViewModel(viewModel: RootViewModel()), festivalId: 1, thumbnail: "", schoolName: "건국대학교", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08.", isUpdatingFavoriteFestival: .constant(false))
        .environmentObject(FavoriteFestivalViewModel(networkManager: NetworkManager()))
}
