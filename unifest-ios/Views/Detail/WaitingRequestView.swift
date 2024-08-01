//
//  WaitingRequestView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct WaitingRequestView: View {
    @State private var partySize: Int = 2
    @State private var phoneNumber: String = ""
    @State private var formattedPhoneNumber: String = ""
    @State private var isPhoneNumberValid = false
    @State private var isComplete = false // 웨이팅 완료 여부
    @State private var isPolicyAgreed = false
    @StateObject var waiting = WaitingViewModel()
    @Binding var isWaitingRequestViewPresented: Bool
    @Binding var isWaitingCompleteViewPresented: Bool
    let boothId: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Image(.waitingBackground)
                .resizable()
                .frame(width: 301, height: 290)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 15, height: 15)
                            
                            Spacer()
                            
                            Image(.marker)
                            Text("컴공 주점")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                isWaitingRequestViewPresented = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("현재 내 앞 웨이팅")
                            .font(.system(size: 13))
                            .foregroundStyle(.darkGray)
                        
                        Text(String(waiting.waitingTeamCount) + "팀")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .padding(.bottom, 1)
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Text("인원 수")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                Button {
                                    partySize -= 1
                                } label: {
                                    Image(.circleGrayButton)
                                        .overlay {
                                            Text("-")
                                                .font(.system(size: 20))
                                                .foregroundStyle(partySize == 1 ? .gray : .darkGray)
                                        }
                                }
                                .disabled(partySize == 1)
                                
                                Text("\(partySize)")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundStyle(.darkGray)
                                    .frame(width: 30)
                                
                                Button {
                                    partySize += 1
                                } label: {
                                    Image(.circleGrayButton)
                                        .overlay {
                                            Text("+")
                                                .font(.system(size: 20))
                                                .foregroundStyle(.darkGray)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Image(.waitingPopupTextFieldBackground)
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
                            }
                            .padding(.bottom, 4)
                        
                        HStack {
                            Button {
                                isPolicyAgreed.toggle()
                            } label: {
                                Image(isPolicyAgreed ? .checkboxChecked : .checkbox)
                            }
                            
                            Group {
                                Link(destination: URL(string: "https://abiding-hexagon-faa.notion.site/App-c351cc083bc1489e80e974df5136d5b4?pvs=4")!) {
                                    Text("개인정보 처리방침")
                                        .padding(.trailing, -8)
                                        .foregroundStyle(.defaultBlack)
                                        .underline()
                                        .fontWeight(.bold)
                                }
                                Text(" 및 ")
                                Link(destination: URL(string: "https://abiding-hexagon-faa.notion.site/App-c351cc083bc1489e80e974df5136d5b4?pvs=4")!) {
                                    Text("제 3자 제공방침")
                                        .padding(.horizontal, -8)
                                        .foregroundStyle(.defaultBlack)
                                        .underline()
                                        .fontWeight(.bold)
                                }
                                Text("에 동의합니다")
                            }
                            .font(.system(size: 12))
                        }
                        
                        Button {
                            isWaitingRequestViewPresented = false
                            isWaitingCompleteViewPresented = true
                        } label: {
                            Image(isPhoneNumberValid == false || isPolicyAgreed == false ? .waitingPopupButtonDisabled : .waitingPopupButton)
                                .overlay {
                                    Text("웨이팅 신청")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                }
                        }
                        .disabled(isPhoneNumberValid == false || isPolicyAgreed == false)
                    }
                }
        }
        .task {
            await waiting.fetchWaitingTeamCount(boothId: boothId)
        }
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
}

#Preview {
    WaitingRequestView(isWaitingRequestViewPresented: .constant(false), isWaitingCompleteViewPresented: .constant(false), boothId: 0)
}
