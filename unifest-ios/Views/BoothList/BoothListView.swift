//
//  BoothListView.swift
//  unifest-ios
//
//  Created by Yune gim on 7/28/25.
//

import SwiftUI

struct BoothListView: View {
    @ObservedObject private var viewModel: BoothListViewModel
    @ObservedObject private var rootViewModel: RootViewModel
    @ObservedObject private var mapViewModel: MapViewModel
    
    @State private var selectedBooth: BoothItem?

    init(_ rootViewModel: RootViewModel,
         _ mapViewModel: MapViewModel,
         _ viewModel: BoothListViewModel
    ) {
        self.viewModel = viewModel
        self.rootViewModel = rootViewModel
        self.mapViewModel = mapViewModel
    }
    
    var body: some View {
        VStack {
            header
            boothList
        }
        .padding(.top, 32)
        .background(.ufBackground)
        .sheet(item: $selectedBooth) { booth in
            BoothDetailView(viewModel: rootViewModel,
                            mapViewModel: mapViewModel,
                            currentBoothId: booth.id)
            .presentationDragIndicator(.visible)
        }
    }
    
    var boothList: some View {
        List($viewModel.boothList) { booth in
            LikedBoothBoxView(viewModel: rootViewModel,
                              boothID: booth.id,
                              image: booth.wrappedValue.thumbnail,
                              name: booth.wrappedValue.name,
                              description: booth.wrappedValue.description,
                              location: booth.wrappedValue.location)
            .onTapGesture {
                    viewModel.selectBooth(booth.wrappedValue)
                    selectedBooth = booth.wrappedValue
            }
            .listRowBackground(Color.ufBackground)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal, 20)
        }
        .listRowSpacing(20)
        .listStyle(.plain)
        .padding(.top, 24)
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text(viewModel.campusName)
                .font(.pretendard(weight: .p5, size: 15))
            
            Spacer().frame(height: 18)
            
            Text("부스 목록")
                .font(.pretendard(weight: .p6, size: 20))
            
            Spacer().frame(height: 21)
            
            HStack {
                Text("총 \(viewModel.boothList.count)개")
                    .font(.pretendard(weight: .p4, size: 13))
                
                Spacer()
                
                toggleView
            }
        }
        .padding([.leading, .trailing], 20)
    }
    
    var toggleView: some View {
        HStack {
            checkBox
            
            Spacer().frame(width: 6)
            
            Text("웨이팅 가능 여부")
                .font(.pretendard(weight: .p4, size: 14))
        }
        .onTapGesture {
            withAnimation {
                viewModel.shouldShowAvailableBoothOnly(!viewModel.showAvailableBoothOnly)
            }
        }
    }
    
    @ViewBuilder
    private var checkBox: some View {
        if viewModel.showAvailableBoothOnly {
            Image(.accentCheckboxChecked)
                .resizable()
                .frame(width: 20, height: 20)
        } else {
            Image(.checkbox)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20)
        }
    }
}
