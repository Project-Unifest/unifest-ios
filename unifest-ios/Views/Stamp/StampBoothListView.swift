////
////  StampBoothView.swift
////  unifest-ios
////
////  Created by 임지성 on 8/30/24.
////
//
//import SwiftUI
//
//struct StampBoothListView: View {
//    @ObservedObject var viewModel: RootViewModel
//    @EnvironmentObject var networkManager: NetworkManager
//    
//    var body: some View {
//        ZStack {
//            VStack(alignment: .leading) {
//                VStack(alignment: .leading) {
//                    Text("한국교통대학교")
//                        .font(.pretendard(weight: .p4, size: 14))
//                        .foregroundStyle(.grey500)
//                        .padding(.bottom, -1)
//                    
//                    Text("스탬프 가능 부스")
//                        .font(.pretendard(weight: .p6, size: 20))
//                        .foregroundStyle(.grey900)
//                        .padding(.bottom, 8)
//                    
//                    Text("총 12개")
//                        .font(.pretendard(weight: .p6, size: 13))
//                        .foregroundStyle(.grey600)
//                }
//                .padding(.horizontal, 22)
//                .padding(.top, 30)
//                
//                List {
//                    ForEach(0 ..< 12) { _ in
//                        StampBoothListItemView(viewModel: viewModel, boothID: 156, image: "", name: "컴공 주점 부스", description: "저희 주점은 일본 이자카야를 보티브로 만든 컴공인을 위한 주점입니다", location: "학생회관 옆")
//                            .listRowBackground(Color.ufBackground)
//                            .listRowSeparator(.hidden)
//                    }
//                }
//                .background(.ufBackground)
//                .listStyle(.plain)
//            }
//            .background(.ufBackground)
//            
//            if networkManager.isNetworkConnected == false {
//                NetworkErrorView(errorType: .network)
//                    .onAppear {
//                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
//                    }
//            }
//            
////            if networkManager.isServerError == true {
////                NetworkErrorView(errorType: .server)
////                    .onAppear {
////                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
////                    }
////            }
//        }
//        .dynamicTypeSize(.large)
//    }
//}
//
//#Preview {
//    StampBoothListView(viewModel: RootViewModel())
//        .environmentObject(NetworkManager())
//}
