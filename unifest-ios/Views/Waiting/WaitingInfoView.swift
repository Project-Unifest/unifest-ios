import SwiftUI

struct WaitingInfoView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    let reservedWaitingListItem: ReservedWaitingResult
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @State private var isBoothDetailViewPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack { // GeometryReader의 자식 뷰들을 VStack으로 감싸 중앙에 배치되도록 함
                RoundedRectangle(cornerRadius: 10)
                    .fill(reservedWaitingListItem.status == "NOSHOW" ? Color.primary50 : Color.ufWhite)
                    .shadow(color: Color.black.opacity(0.12), radius: 7, y: 3)
                    .frame(width: geometry.size.width * 0.9, height: 160) // 화면의 90% 너비
                    .overlay {
                        VStack(spacing: 10) {
                            HStack {
                                Text("현재 내 순서")
                                    .font(.pretendard(weight: .p4, size: 14))
                                    .foregroundStyle(.grey900)
                                
                                Spacer()
                                
                                Image(.marker)
                                    .resizable()
                                    .frame(width: 10.66, height: 14.38)
                                Text(reservedWaitingListItem.boothName)
                                    .font(.pretendard(weight: .p6, size: 15))
                                    .foregroundStyle(.grey900)
                            }
                            
                            HStack(alignment: .bottom) {
                                HStack(alignment: .bottom, spacing: 2) {
                                    if reservedWaitingListItem.status == "CALLED" {
                                        Text("입장해주세요")
                                            .font(.pretendard(weight: .p7, size: 30))
                                            .foregroundStyle(.primary500)
                                            .baselineOffset(4)
                                    } else if reservedWaitingListItem.status == "NOSHOW" {
                                        Text("부재 처리")
                                            .font(.pretendard(weight: .p7, size: 30))
                                            .foregroundStyle(.primary700)
                                            .baselineOffset(4)
                                    } else if reservedWaitingListItem.status == "COMPLETED" {
                                        Text("입장 완료")
                                            .font(.pretendard(weight: .p7, size: 30))
                                            .foregroundStyle(.primary500)
                                            .baselineOffset(4)
                                    } else {
                                        if let waitingOrder = reservedWaitingListItem.waitingOrder {
                                            Text(String(waitingOrder))
                                                .font(.pretendard(weight: .p6, size: 45))
                                                .foregroundStyle(.primary500)
                                            
                                            Text("번째")
                                                .font(.pretendard(weight: .p5, size: 16))
                                                .foregroundStyle(.grey900)
                                                .baselineOffset(9)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Spacer()
                                    HStack(spacing: 5) {
                                        Text("웨이팅 번호")
                                            .font(.pretendard(weight: .p4, size: 14))
                                        Text(String(reservedWaitingListItem.waitingId))
                                            .font(.pretendard(weight: .p7, size: 14))
                                        
                                        Spacer()
                                            .frame(width: 0)
                                        
                                        Text("인원")
                                            .font(.pretendard(weight: .p4, size: 14))
                                        Text(String(reservedWaitingListItem.partySize))
                                            .font(.pretendard(weight: .p7, size: 14))
                                    }
                                    .foregroundStyle(.grey900)
                                    .baselineOffset(9)
                                }
                            }
                            
                            HStack {
                                Button {
                                    waitingVM.waitingIdToCancel = reservedWaitingListItem.waitingId
                                    waitingVM.waitingStatus = reservedWaitingListItem.status
                                    withAnimation {
                                        waitingVM.cancelWaiting = true
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.grey100)
                                        .frame(width: geometry.size.width * 0.4, height: 44)
                                        .overlay {
                                            Text(reservedWaitingListItem.status == "NOSHOW" ? "부재 웨이팅 지우기" : "웨이팅 취소")
                                                .font(.pretendard(weight: .p7, size: 14))
                                                .foregroundStyle(.ufRed)
                                        }
                                }
                                
                                Button {
                                    viewModel.boothModel.loadBoothDetail(reservedWaitingListItem.boothId)
                                    isBoothDetailViewPresented = true
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.grey100)
                                        .frame(width: geometry.size.width * 0.4, height: 44)
                                        .overlay {
                                            Text("부스 확인하기")
                                                .font(.pretendard(weight: .p7, size: 14))
                                                .foregroundStyle(.grey700)
                                        }
                                }
                            }
                        }
                        .padding() // RoundedRectangle() 안쪽 padding
                    }
                    .sheet(isPresented: $isBoothDetailViewPresented) {
                        BoothDetailView(viewModel: viewModel, mapViewModel: mapViewModel, currentBoothId: viewModel.boothModel.selectedBoothID)
                            .presentationDragIndicator(.visible)
                    }
                    .frame(width: geometry.size.width * 0.9) // 중앙 정렬을 위해 frame을 명시적으로 지정
            }
            .frame(width: geometry.size.width, height: 160) // GeometryReader에 맞춘 외부 레이아웃 조정
        }
        .frame(height: 160)
    }
}

#Preview {
    WaitingInfoView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()), reservedWaitingListItem: .empty)
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
