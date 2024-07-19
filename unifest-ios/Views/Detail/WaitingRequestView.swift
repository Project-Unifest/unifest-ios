//
//  WaitingRequestView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct WaitingRequestView: View {
    @State private var number: Int = 2
    @State private var phoneNumber: String = "010-1234-5678"
    @State var isComplete = false // 웨이팅 완료 여부
    @State private var isPolicyAgreed = false
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
                                dismiss()
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
                        
                        Text("28팀")
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
                                    number -= 1
                                } label: {
                                    Image(.circleGrayButton)
                                        .overlay {
                                            Text("-")
                                                .font(.system(size: 20))
                                                .foregroundStyle(number == 1 ? .gray : .darkGray)
                                        }
                                }
                                .disabled(number == 1)
                                
                                Text("\(number)")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundStyle(.darkGray)
                                    .frame(width: 30)
                                
                                Button {
                                    number += 1
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
                                TextField("전화번호를 입력해주세요", text: $phoneNumber)
                                    .font(.system(size: 13))
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .keyboardType(.numberPad)
                                    .onChange(of: phoneNumber) { newValue in
                                        phoneNumber = String(newValue.filter { "0123456789".contains($0) }.prefix(11))
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
                                Text("개인정보 처리방침")
                                    .underline()
                                    .bold() +
                                Text(" 및 ") +
                                Text("제 3자 제공방침")
                                    .underline()
                                    .bold() +
                                Text("에 동의합니다")
                            }
                            .font(.system(size: 12))
                        }
                        
                        Button {
                            
                        } label: {
                            Image(phoneNumber.isEmpty || isPolicyAgreed == false ? .waitingPopupButtonDisabled : .waitingPopupButton)
                                .overlay {
                                    Text("웨이팅 신청")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                }
                        }
                        .disabled(phoneNumber.isEmpty || isPolicyAgreed == false)
                    }
                }
        }
    }
}

#Preview {
    WaitingRequestView()
}
