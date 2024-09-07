//
//  StampView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/30/24.
//

import CodeScanner
import SwiftUI

struct StampView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var rotationAmount = 0.0
    @State private var isStampBoothViewPresented = false
    @State private var isShowingScanner = false
    @State private var numberOfStamps = 5
    @State private var addStampToast: Toast? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            VStack {
                HStack {
                    Text("스탬프")
                        .font(.pretendard(weight: .p6, size: 21))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.ufBoxBackground)
                    .frame(width: screenWidth * 0.9, height: 530)
                    .overlay {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("한국교통대학교")
                                        .font(.pretendard(weight: .p6, size: 20))
                                        .foregroundStyle(.grey900)
                                        .padding(.bottom, 3)
                                    
                                    Text("지금까지 모은 스탬프")
                                        .font(.pretendard(weight: .p4, size: 14))
                                        .foregroundStyle(.grey500)
                                }
                                
                                Spacer()
                                
                                Button {
                                    isShowingScanner = true
                                } label: {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(stops: [
                                                    .init(color: Color(red: 1.0, green: 0.525, blue: 0.6), location: 0.0),
                                                    .init(color: Color(red: 1.0, green: 0.258, blue: 0.392), location: 1.0),
                                                    .init(color: Color(red: 0.937, green: 0.224, blue: 1.0), location: 1.0)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: 140, height: 52)
                                        .overlay {
                                            Text("스탬프 받기")
                                                .font(.pretendard(weight: .p6, size: 18))
                                                .foregroundStyle(.ufWhite)
                                        }
                                }
                            }
                            .padding(.top, 18)
                            .padding(.bottom, 20)
                            
                            HStack {
                                HStack {
                                    Text("\(numberOfStamps)")
                                        .foregroundStyle(.grey900)
                                    Text("/ 12개")
                                        .foregroundStyle(.grey500)
                                }
                                .font(.pretendard(weight: .p7, size: 24))
                                
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Label("새로고침", systemImage: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.grey600)
                                }
                                .padding(.trailing, 8)
                            }
                            .padding(.bottom, 20)
                            
                            StampGrid(numberOfStamps: numberOfStamps, screenWidth: screenWidth)
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color.ufBackground)
                                .frame(width: 305, height: 50)
                                .overlay {
                                    Button {
                                        isStampBoothViewPresented = true
                                    } label: {
                                        HStack {
                                            Text("스탬프 부스 찾아보기")
                                                .font(.pretendard(weight: .p6, size: 15))
                                                .foregroundStyle(.grey700)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.grey700)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.bottom, 5)
                        }
                        .padding()
                    }
                
                Spacer()
            }
            .padding()
            .background(.ufBackground)
            .sheet(isPresented: $isStampBoothViewPresented) {
                StampBoothListView(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], completion: handleScan)
                    .presentationDragIndicator(.visible)
                    .ignoresSafeArea()
            }
        .toastView(toast: $addStampToast)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        print("Scanning completed")
        switch result {
        case .success(let result):
            print("Scanning succeeded")
            print(result)
            addStampToast = Toast(style: .success, message: "QR코드 스캔 성공")
        case .failure(let error):
            print("Scannign failed: \(error.localizedDescription)")
            addStampToast = Toast(style: .success, message: "QR코드 스캔 실패")
        }
    }
}

struct StampGrid: View {
    let numberOfStamps: Int
    let screenWidth: CGFloat
    
    var body: some View {
        Grid {
            ForEach(0 ..< 3) { i in
                GridRow {
                    ForEach(0 ..< 4) { j in
                        let count = i * 4 + j + 1
                        
                        if numberOfStamps >= count {
                            Image(.appLogo)
                                .resizable()
                                .frame(width: 62, height: 62)
                                .clipShape(Circle())
                                .padding(.horizontal, screenWidth * 0.0215)
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    HapticManager.shared.hapticImpact(style: .light)
                                }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.grey300)
                                    .frame(width: 62, height: 62)
                                
                                Image(.noImagePlaceholder)
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .offset(x: 2, y: -2)
                            }
                            .padding(.horizontal, screenWidth * 0.0215)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StampView(viewModel: RootViewModel())
}
