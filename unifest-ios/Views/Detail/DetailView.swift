//
//  DetailView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

struct DetailView: View {
    @State private var isMapViewPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ZStack {
                        Image(.tempBack)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
                        
                        Image(.blackGrad)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 260)
                        
//                        VStack {
//                            HStack {
//                                Button {
//                                    dismiss()
//                                } label: {
//                                    Image(.backArrow)
//                                }
//                                .frame(width: 40, height: 40)
//                                
//                                Spacer()
//                            }
//                            
//                            Spacer()
//                        }
//                        .frame(height: 260)
                    }
                    
                    HStack {
                        Text("컴공 주점")
                            .font(.system(size: 22))
                            .bold()
                        
                        VStack {
                            Spacer()
                            
                            Text("컴퓨터공학부 전용 부스")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)
                                .padding(.bottom, 4)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    Text("저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다. 100번째 방문자에게 깜짝 선물 증정 이벤트를 하고 있으니 많은 관심 부탁드려요~!")
                        .font(.system(size: 13))
                        .foregroundStyle(.darkGray)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    HStack {
                        Image(.greenMarker)
                        
                        Text("청심대 앞")
                            .font(.system(size: 13))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    Button {
                        isMapViewPresented = true
                    } label: {
                        Image(.longPinkButton)
                            .overlay {
                                Text("위치 확인하기")
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.accent)
                            }
                    }
                    .padding(.bottom)
                    
                    Image(.boldLine)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                    
                    HStack {
                        Text("메뉴")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 6)
                    
                    VStack(spacing: 10) {
                        MenuBar(imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Sashimi_combo_%2830122297838%29.jpg/300px-Sashimi_combo_%2830122297838%29.jpg", name: "모둠 사시미", price: 45000)
                        MenuBar(imageURL: "https://i.namu.wiki/i/b7y5ZQOQnUzuKlMA43u_gqzZKMPhUzr_gYoi6Wph-CsKhekz9u-J5u62XWteWksPD-mFPrgu_zsv_vB_1axmYw.webp", name: "난반 가라아게", price: 18000)
                        MenuBar(imageURL: "https://i.namu.wiki/i/b7y5ZQOQnUzuKlMA43u_gqzZKMPhUzr_gYoi6Wph-CsKhekz9u-J5u62XWteWksPD-mFPrgu_zsv_vB_1axmYw.webp", name: "난반 가라아게", price: 18000)
                        MenuBar(imageURL: "https://i.namu.wiki/i/b7y5ZQOQnUzuKlMA43u_gqzZKMPhUzr_gYoi6Wph-CsKhekz9u-J5u62XWteWksPD-mFPrgu_zsv_vB_1axmYw.webp", name: "난반 가라아게", price: 18000)
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Spacer()
                            .frame(height: 100)
                        
                        HStack {
                            Spacer()
                            Text("등록된 메뉴가 없어요")
                                .foregroundStyle(.gray)
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 100)
                        
                    }
                }
                
                Spacer()
                    .frame(height: 70)
            }
            .ignoresSafeArea(edges: .top)
            .background(.background)
            .fullScreenCover(isPresented: $isMapViewPresented, content: {
                OneMapView(mapViewModel: MapViewModel(), boothName: "컴공주점", boothLocation: "청심대 앞")
            })
            
            VStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        VStack {
                            Button {
                                
                            } label: {
                                Image(.bookmark)
                            }
                            .padding(.horizontal, 10)
                            
                            Text("68")
                                .font(.system(size: 10))
                                .foregroundStyle(.darkGray)
                        }
                        .padding(.top, 2)
                        
                        Button {
                            
                        } label: {
                            Image(.longFullPinkButton)
                                .overlay {
                                    Text("웨이팅 하기")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .bold()
                                }
                        }
                        .padding(.trailing, 10)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.background)
                .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
            }
        }
    }
}

#Preview {
    DetailView()
}

struct MenuBar: View {
    let imageURL: String
    let name: String
    let price: Int
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.lightGray)
                        .frame(width: 86, height: 86)
                    
                    ProgressView()
                }
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                
                Text("\(price)원")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        MenuBar(imageURL: "", name: "모둠 사시미", price: 45000)
        MenuBar(imageURL: "", name: "난반 가라아게", price: 18000)
    }
}
