//
//  AdminLoginView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

struct AdminLoginView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    
    @State private var isPasswordShowing: Bool = false
    @State private var isAutoLoginChecked: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(.leftArrow)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .frame(width: 40, height: 24)
                
                Spacer()
                
                Text("운영자/학생회 로그인")
                
                Spacer()
                
                Spacer()
                    .frame(width: 40)
            }
            .frame(height: 68)
            .padding(.horizontal)
            
            VStack(spacing: 9) {
                Image(.textFieldBackgroundGray)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity)
                    .overlay {
                        HStack {
                            TextField("아이디를 입력해주세요", text: $id)
                                .font(.system(size: 16))
                            
                            if !id.isEmpty {
                                Button {
                                    id = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.lightGray)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                
                if !isPasswordShowing {
                    Image(.textFieldBackgroundGray)
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .overlay {
                            HStack {
                                SecureField("비밀번호를 입력해주세요", text: $password)
                                    .font(.system(size: 16))
                                
                                Button {
                                    withAnimation(.spring) {
                                        isPasswordShowing = true
                                    }
                                } label: {
                                    Text("SHOW")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.gray)
                                }
                                
                                if !password.isEmpty {
                                    Button {
                                        password = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.lightGray)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                } else {
                    Image(.textFieldBackgroundGray)
                        .resizable()
                        .scaledToFit()
                        .frame(width: .infinity)
                        .overlay {
                            HStack {
                                TextField("비밀번호를 입력해주세요", text: $password)
                                    .font(.system(size: 16))
                                
                                Button {
                                    withAnimation(.spring) {
                                        isPasswordShowing = false
                                    }
                                } label: {
                                    Text("HIDE")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.gray)
                                }
                                
                                if !password.isEmpty {
                                    Button {
                                        password = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.lightGray)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            HStack {
                Button {
                    withAnimation(.spring) {
                        isAutoLoginChecked.toggle()
                    }
                } label: {
                    Image(isAutoLoginChecked ? .checkboxChecked : .checkbox)
                }
                
                Text("자동 로그인")
                    .foregroundStyle(.darkGray)
                    .font(.system(size: 12))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Image(.longButtonDarkBlack)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
                .padding(.horizontal)
                .overlay {
                    Text("로그인")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .bold()
                }
                .padding(.bottom, 8)
            
            HStack {
                Button {
                    
                } label: {
                    Text("가입하기")
                        .font(.system(size: 12))
                        .foregroundStyle(.darkGray)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("아이디 찾기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                
                Text("|")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                
                Button {
                    
                } label: {
                    Text("비밀번호 찾기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("학생회 / 부스 운영자가 아닌 일반 사용자는 가입 없이 사용할 수 있습니다")
                .font(.system(size: 10))
                .foregroundStyle(.gray)
                .padding(.bottom, 3)
            
            Button {
                
            } label: {
                Text("운영자 부스 관련 문의")
                    .font(.system(size: 10))
                    .foregroundStyle(.darkGray)
                    .underline()
            }
            .padding(.bottom, 3)
        }
    }
}

#Preview {
    AdminLoginView()
}
