//
//  WaitingPinView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/4/24.
//

import SwiftUI

struct WaitingPinView: View {
    @ObservedObject var viewModel: RootViewModel
    let boothId: Int
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @Environment(\.dismiss) var dismiss
    @Binding var pin: String
    @State private var isPinFormatValid: Bool = false
    @Binding var isWaitingPinViewPresented: Bool
    @Binding var isWaitingRequestViewPresented: Bool
    @FocusState private var isPinTextFieldFocused: Bool
    @State private var isCheckingPin = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            ZStack {
                Color.ufWhite
                    .cornerRadius(10)
                    .frame(width: 301, height: 299)
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 15, height: 15)
                                
                                Spacer()
                                
                                Image(.marker)
                                    .resizable()
                                    .frame(width: 11, height: 15)
                                    .padding(.trailing, -1)
                                
                                if let name = viewModel.boothModel.selectedBooth?.name {
                                    if !name.isEmpty {
                                        Text(name)
                                            .font(.pretendard(weight: .p6, size: 15))
                                            .foregroundStyle(.grey900)
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    isWaitingPinViewPresented = false
                                    pin = ""
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 11, height: 11)
                                        .foregroundColor(.grey600)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                            
                            Text("부스 PIN 입력")
                                .font(.pretendard(weight: .p7, size: 28))
                                .foregroundStyle(.grey900)
                                .padding(.top, 10)
                            
                            RoundedRectangle(cornerRadius: 7)
                                .strokeBorder(Color.grey400, lineWidth: 1)
                                .frame(width: 272, height: 58)
                                .overlay {
                                    TextField("4자리 PIN을 입력해주세요", text: $pin)
                                        .font(.pretendard(weight: .p5, size: 20))
                                        .autocorrectionDisabled()
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.numberPad)
                                        .onChange(of: pin) { newValue in
                                            if newValue.count > 4 {
                                                pin = String(newValue.prefix(4))
                                            }
                                            
                                            checkPinValidity(newValue)
                                        }
                                        .focused($isPinTextFieldFocused)
                                        .foregroundStyle(.grey400)
                                        .padding(.leading, 10)
                                }
                                .padding(.top, 15)
                            
                            if waitingVM.isPinNumberValid == nil || waitingVM.isPinNumberValid == true {
                                HStack {
                                    Label("웨이팅 PIN은 부스 운영자에게 문의해주세요", systemImage: "exclamationmark.circle.fill")
                                        .font(.pretendard(weight: .p5, size: 12))
                                        .foregroundStyle(.grey900)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top, 1)
                            } else if waitingVM.isPinNumberValid == false {
                                HStack {
                                    Label("올바르지 않은 PIN이에요. 부스 운영자에게 문의해주세요", systemImage: "exclamationmark.triangle.fill")
                                        .font(.pretendard(weight: .p5, size: 12))
                                        .foregroundStyle(.ufRed)
                                        .kerning(-0.87)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top, 1)
                            }
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    isCheckingPin = true
                                    print("buttonTapped boothId: \(viewModel.boothModel.selectedBoothID)")
                                    await waitingVM.checkPinNumber(boothId: viewModel.boothModel.selectedBoothID, pinNumber: pin)
                                    
                                    if waitingVM.isPinNumberValid == true {
                                        isWaitingPinViewPresented = false
                                        isWaitingRequestViewPresented = true
                                    } else {
                                        pin = ""
                                    }
                                    isCheckingPin = false
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(isPinFormatValid ? Color.primary500 : Color.grey400)
                                    .frame(width: 275, height: 45)
                                    .overlay {
                                        Text("PIN 입력")
                                            .font(.pretendard(weight: .p6, size: 13))
                                            .foregroundStyle(.white)
                                    }
                            }
                            .disabled(isPinFormatValid == false)
                            .padding(.bottom, 14)
                        }
                    }
                
                if isCheckingPin {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .onAppear {
            waitingVM.isPinNumberValid = nil
            isPinTextFieldFocused = true
            pin = ""
        }
    }
    
    func checkPinValidity(_ pin: String) {
        let regexPattern = "^[0-9]{4}$"
        guard let _ = pin.range(of: regexPattern, options: .regularExpression) else {
            isPinFormatValid = false
            return
        }
        
        isPinFormatValid = true
    }
}

#Preview {
    WaitingPinView(viewModel: RootViewModel(), boothId: 0, pin: .constant(""), isWaitingPinViewPresented: .constant(true), isWaitingRequestViewPresented: .constant(false))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}


