//
//  SchoolBoxView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 6/30/24.
//

import SwiftUI

struct SchoolBoxView: View {
    @Binding var isSelected: Bool
    let festivalId: Int
    let schoolImageURL: String
    let schoolName: String
    let festivalName: String
    let startDate: String
    let endDate: String
    @Binding var isUpdatingFavoriteFestival: Bool
    @State private var throttleManager = ThrottleManager(throttleInterval: 1.5)
    @EnvironmentObject var favoriteFestivalVM: FavoriteFestivalViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
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
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(favoriteFestivalVM.favoriteFestivalList.contains(festivalId) ? .primary500 : .grey300)
                .frame(minWidth: 113)
                .frame(height: 120)
                .overlay {
                    VStack {
                        AsyncImage(url: URL(string: schoolImageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .scaledToFit()
                                    .clipShape(.circle)
                                    .padding(.bottom, 4)
                            case .failure:
                                Circle()
                                    .fill(.grey500)
                                    .frame(width: 35, height: 35)
                                    .padding(.bottom, 4)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 35, height: 35)
                        
                        Text(schoolName)
                            .font(.pretendard(weight: .p4, size: 13))
                            .foregroundStyle(.grey900)
                        
                        Text(festivalName)
                            .font(.pretendard(weight: .p7, size: 12))
                            .foregroundStyle(.grey900)
                        
                        Text(formattedDate(from: startDate) + "-" + formattedDate(from: endDate))
                            .font(.pretendard(weight: .p4, size: 12))
                            .foregroundStyle(.grey600)
                    }
                }
//                .overlay {
//                    VStack {
//                        HStack {
//                            Spacer()
//                            
//                            if favoriteFestivalVM.isEditingFavoriteFestival {
//                                Button {
//                                    Task {
//                                        isUpdatingFavoriteFestival = true
//                                        let deviceId = DeviceUUIDManager.shared.getDeviceToken()
//                                        let isFavoriteFestival = favoriteFestivalVM.favoriteFestivalList.contains(festivalId)
//                                        
//                                        if isFavoriteFestival {
//                                            await throttleManager.throttle {
//                                                await favoriteFestivalVM.deleteFavoriteFestival(festivalId: festivalId, deviceId: deviceId)
//                                                await favoriteFestivalVM.getFavoriteFestivalList(deviceId: DeviceUUIDManager.shared.getDeviceToken())
//                                                favoriteFestivalVM.updateSucceededToast = Toast(style: .success, message: "'\(festivalName)'을/를 관심축제에서 삭제했어요")
//                                            }
//                                        } else {
//                                            await throttleManager.throttle {
//                                                await favoriteFestivalVM.addFavoriteFestival(festivalId: festivalId, deviceId: deviceId)
//                                                await favoriteFestivalVM.getFavoriteFestivalList(deviceId: DeviceUUIDManager.shared.getDeviceToken())
//                                                favoriteFestivalVM.updateSucceededToast = Toast(style: .success, message: "'\(festivalName)'을/를 관심축제에 추가했어요")
//                                            }
//                                        }
//                                        isUpdatingFavoriteFestival = false
//                                    }
//                                } label: {
//                                    Image(systemName: "xmark.circle.fill")
//                                        .resizable()
//                                        .frame(width: 12, height: 12)
//                                        .foregroundColor(.primary500)
//                                }
//                                .padding(.top, 12)
//                                .padding(.trailing, 12)
//                            }
//                        }
//                        
//                        Spacer()
//                    }
//                }
        }
    }
    
    func formattedDate(from dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM.dd"
        
        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "Error formatting date"
        }
    }
}

#Preview {
    SchoolBoxView(isSelected: .constant(false), festivalId: 1, schoolImageURL: "https://i.namu.wiki/i/frJ2JwLkp_Ts8Le-AVmISJdC2wkhYUte4N5YZ0j-nB_aT_CagQLTOjNDeXMW_kFBeXIe5-pAXDE4CGNVGJ5FMGuS1HUqUTYGfL3AUVJBzum3Ppq5wIUej0v10WuSuOWDT2KIEQwKqA4qiWm3EzS123Uj1gyShvzqaaScOgNsnPg.svg", schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "2024-06-24", endDate: "2024-06-27", isUpdatingFavoriteFestival: .constant(false))
        .frame(width: 120)
        .environmentObject(FavoriteFestivalViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
