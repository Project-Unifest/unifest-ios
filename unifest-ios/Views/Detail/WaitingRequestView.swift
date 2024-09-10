//
//  WaitingRequestView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct WaitingRequestView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var partySize: Int = 2
    @State private var phoneNumber: String = ""
    @State private var formattedPhoneNumber: String = ""
    @State private var isPhoneNumberValid = false
    @State private var isCompleted = false // 웨이팅 완료 여부
    @State private var isPolicyAgreed = false
    @State private var phoneNumberFormatError: Toast? = nil
    @EnvironmentObject var waitingVM: WaitingViewModel
    let boothId: Int
    @Binding var pin: String
    @Binding var isWaitingRequestViewPresented: Bool
    @Binding var isWaitingCompleteViewPresented: Bool
    @FocusState private var isPhoneNumberTextFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Color.ufWhite
                .cornerRadius(10)
                .frame(width: 301, height: 290)
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
                            // Preview에는 selectedBooth가 체크 안돼서 텍스트 안보임
                                if let name = viewModel.boothModel.selectedBooth?.name {
                                    if !name.isEmpty {
                                        Text(name)
                                            .font(.pretendard(weight: .p6, size: 15))
                                            .foregroundStyle(.grey900)
                                    }
                                }
                            
                            Spacer()
                            
                            Button {
                                pin = ""
                                partySize = 2
                                phoneNumber = ""
                                formattedPhoneNumber = ""
                                isWaitingRequestViewPresented = false
                                isPhoneNumberValid = false
                                isCompleted = false
                                isPolicyAgreed = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 11, height: 11)
                                    .foregroundColor(.grey600)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("현재 내 앞 웨이팅")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .padding(.bottom, -5)
                            .padding(.top, 1)
                        
                        Text(String(waitingVM.waitingTeamCount) + "팀")
                            .font(.pretendard(weight: .p7, size: 28))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 1)
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Text("인원 수")
                                .font(.pretendard(weight: .p6, size: 14))
                                .foregroundStyle(.grey900)
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                Button {
                                    partySize -= 1
                                } label: {
                                    Image(.circleGrayButton)
                                        .overlay {
                                            Text("-")
                                                .font(.pretendard(weight: .p3, size: 20))
                                                .foregroundStyle(partySize == 1 ? .grey400 : .grey900)
                                        }
                                }
                                .disabled(partySize == 1)
                                
                                Text("\(partySize)")
                                    .font(.pretendard(weight: .p7, size: 15))
                                    .foregroundStyle(.grey900)
                                    .frame(width: 30)
                                
                                Button {
                                    partySize += 1
                                } label: {
                                    Image(.circleGrayButton)
                                        .overlay {
                                            Text("+")
                                                .font(.pretendard(weight: .p3, size: 20))
                                                .foregroundStyle(partySize == 100 ? .grey400 : .grey900)
                                        }
                                }
                                .disabled(partySize == 100)
                            }
                        }
                        .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.grey400, lineWidth: 1)
                            .frame(width: 272, height: 39)
                            .overlay {
                                TextField("전화번호를 입력해주세요", text: $formattedPhoneNumber)
                                    .font(.system(size: 13))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .keyboardType(.numberPad)
                                    .onChange(of: formattedPhoneNumber) { newValue in
                                        let digits = newValue.filter { $0.isNumber }
                                        
                                        let limitedDigits = String(digits.prefix(11))
                                        // 010123456789 이렇게 한자리 더 입력했을 때 phoneNumber에 잠깐 010123456789가 저장됐다가 01012345678이 되는데, 이거 방지
                                        
                                        formattedPhoneNumber = formatPhoneNumber(limitedDigits)
                                        phoneNumber = limitedDigits
                                        
                                        isValidPhoneNumber(phoneNumber)
                                        
                                        print("저장된 전화번호: \(phoneNumber)")
                                    }
                                    .focused($isPhoneNumberTextFieldFocused)
                            }
                            .padding(.bottom, 4)
                        
                        HStack {
                            Button {
                                isPolicyAgreed.toggle()
                            } label: {
                                Image(isPolicyAgreed ? .checkboxChecked : .checkbox)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Link(destination: URL(string: "https://beaded-alley-5ed.notion.site/0398cc021c9d4879bdfbcd031d56da5e?pvs=74")!) {
                                Text("개인정보 처리방침")
                                    .padding(.trailing, -8)
                                    .font(.pretendard(weight: .p5, size: 12))
                                    .foregroundStyle(.grey900)
                                    .underline()
                            }
                            Text("에 동의합니다")
                                .font(.pretendard(weight: .p5, size: 12))
                                .foregroundStyle(.grey400)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        
                        Button {
                            if checkPhoneNumberFormat(phoneNumber) == true {
                                waitingVM.addWaiting(
                                    boothId: boothId,
                                    phoneNumber: phoneNumber,
                                    deviceId: UIDevice.current.deviceToken,
                                    partySize: partySize,
                                    pinNumber: pin
                                )
                                pin = ""
                                partySize = 2
                                phoneNumber = ""
                                formattedPhoneNumber = ""
                                isWaitingRequestViewPresented = false
                                isPhoneNumberValid = false
                                isCompleted = false
                                isPolicyAgreed = false
                                phoneNumberFormatError = nil
                                isWaitingRequestViewPresented = false
                                isWaitingCompleteViewPresented = true
                            } else {
                                phoneNumberFormatError = Toast(style: .warning, message: "잘못된 전화번호 형식입니다. 다시 확인해 주세요")
                                phoneNumber = ""
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(isPhoneNumberValid == false || isPolicyAgreed == false ? Color.grey600 : Color.primary500)
                                .frame(width: 275, height: 45)
                                .overlay {
                                    Text("웨이팅 신청")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding(.top, 3)
                        .disabled(isPhoneNumberValid == false || isPolicyAgreed == false)
                    }
                }
        }
        .onAppear {
            isPhoneNumberTextFieldFocused = true
        }
        .task {
            await waitingVM.fetchWaitingTeamCount(boothId: boothId)
        }
        .toastView(toast: $phoneNumberFormatError)
    }
    
    func formatPhoneNumber(_ number: String) -> String {
            let length = number.count
            
            if length > 11 {
                return String(number.prefix(11))
                // .prefix(11): 문자열의 최대 길이를 11자로 제한
            }
            
            var formatted = ""
            
            if length > 3 {
                formatted += number.prefix(3) + "-"
                if length > 7 {
                    formatted += number[number.index(number.startIndex, offsetBy: 3) ..< number.index(number.startIndex, offsetBy: 7)] + "-"
                    formatted += number.suffix(length - 7)
                } else {
                    formatted += number.suffix(length - 3)
                }
            } else {
                formatted = number
            }
            
            return formatted
        }
    
    func isValidPhoneNumber(_ number: String) {
        let regexPattern = "^[0-9]{11}$"
        guard let _ = number.range(of: regexPattern, options: .regularExpression) else {
            isPhoneNumberValid = false
            return
        }
        isPhoneNumberValid = true
    }
    
    func checkPhoneNumberFormat(_ number: String) -> Bool {
        let regexPattern = "^010[0-9]{8}$"
        guard let _ = number.range(of: regexPattern, options: .regularExpression) else {
            return false
        }
        return true
    }
}

#Preview {
    WaitingRequestView(viewModel: RootViewModel(), boothId: 79, pin: .constant(""), isWaitingRequestViewPresented: .constant(false), isWaitingCompleteViewPresented: .constant(false))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        // Preview에도 @EnvironmentObject를 제공해야 Preview crash가 발생하지 않음
}

