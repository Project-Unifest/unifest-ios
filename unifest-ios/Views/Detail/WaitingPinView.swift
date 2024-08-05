//
//  WaitingPinView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/4/24.
//

import SwiftUI

struct WaitingPinView: View {
    let boothId: Int
    @EnvironmentObject var waitingVM: WaitingViewModel
    @Environment(\.dismiss) var dismiss
    @State private var pin: String = ""
    @State private var isPinValid: Bool = false
    @Binding var isWaitingPinViewPresented: Bool
    @Binding var isWaitingRequestViewPresented: Bool
    @FocusState private var isPinTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
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
                            Text("컴공 주점")
                                .font(.pretendard(weight: .p6, size: 15))
                                .foregroundStyle(.grey900)
                            
                            Spacer()
                            
                            Button {
                                isWaitingPinViewPresented = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 11, height: 11)
                                    .foregroundColor(.grey600)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
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
                        
                        HStack {
                            Label("웨이팅 PIN은 부스 운영자에게 문의해주세요!", systemImage: "exclamationmark.circle.fill")
                                .font(.pretendard(weight: .p5, size: 12))
                                .foregroundStyle(.grey900)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 1)
                        
                        Spacer()
                        
                        Button {
                            if isPinValid {
                                isWaitingPinViewPresented = false
                                isWaitingRequestViewPresented = true
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(isPinValid ? Color.primary500 : Color.grey600)
                                .frame(width: 275, height: 45)
                                .overlay {
                                    Text("PIN 입력")
                                        .font(.pretendard(weight: .p6, size: 13))
                                        .foregroundStyle(.white)
                                }
                        }
                        .disabled(isPinValid == false)
                        .padding(.bottom, 14)
                    }
                }
        }
        .onAppear {
            isPinTextFieldFocused = true
        }
    }
    
    func checkPinValidity(_ pin: String) {
        let regexPattern = "^[0-9]{4}$"
        guard let _ = pin.range(of: regexPattern, options: .regularExpression) else {
            isPinValid = false
            return
        }
        
        isPinValid = true
    }
}

#Preview {
    WaitingPinView(boothId: 0, isWaitingPinViewPresented: .constant(true), isWaitingRequestViewPresented: .constant(false))
}
