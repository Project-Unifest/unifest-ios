//
//  WaitingPopupView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct WaitingPopupView: View {
    @State private var number: Int = 1
    @State private var phoneNumber: String = "010-1234-5678"
    @State var isComplete: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Image(.waitingBackground)
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
                                
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        if !isComplete {
                            Text("현재 내 앞 웨이팅")
                                .font(.system(size: 13))
                                .foregroundStyle(.darkGray)
                        }
                        
                        Text(isComplete ? "웨이팅 등록 완료!" : "\(28)팀")
                            .font(.system(size: isComplete ? 20 : 28))
                            .fontWeight(isComplete ? .semibold : .bold)
                            .padding(.bottom, 1)
                        
                        if isComplete {
                            Text("입장 순서가 되면 안내 해드릴게요.")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        if !isComplete {
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
                                .padding(.vertical, 4)
                        } else {
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Text("웨이팅 번호")
                                        .font(.system(size: 13))
                                        .fontWeight(.medium)
                                    Text("112번")
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                
                                Spacer()
                                Text("∙")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("인원 수")
                                        .font(.system(size: 13))
                                        .fontWeight(.medium)
                                    Text("3명")
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                
                                Spacer()
                                Text("∙")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.gray)
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("내 앞 웨이팅")
                                        .font(.system(size: 13))
                                        .fontWeight(.medium)
                                    Text("35팀")
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                Spacer()
                            }
                            .padding()
                        }
                            
                        if !isComplete {
                            Button {
                                
                            } label: {
                                Image(phoneNumber.isEmpty ? .waitingPopupButtonDisabled : .waitingPopupButton)
                                    .overlay {
                                        Text("웨이팅 신청")
                                            .font(.system(size: 13))
                                            .foregroundStyle(.white)
                                            .fontWeight(.semibold)
                                    }
                            }
                            .disabled(phoneNumber.isEmpty)
                        } else {
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(.shortGrayButton)
                                        .overlay {
                                            Text("웨이팅 취소")
                                                .font(.system(size: 13))
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.darkGray)
                                        }
                                }
                                
                                Button {
                                    
                                } label: {
                                    Image(.shortPinkButton)
                                        .overlay {
                                            Text("순서 확인하기")
                                                .font(.system(size: 13))
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    WaitingPopupView(isComplete: false)
}

#Preview {
    WaitingPopupView(isComplete: true)
}
