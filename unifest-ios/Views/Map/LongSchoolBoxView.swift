//
//  LongSchoolView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/2/24.
//

import SwiftUI

struct LongSchoolBoxView: View {
    let thumbnail: String
    let schoolName: String
    let festivalName: String
    let startDate: String
    let endDate: String
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: thumbnail)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 52, height: 52)
                            .scaledToFit()
                            .clipShape(.circle)
                            .padding(.trailing, 4)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 52, height: 52)
                            .scaledToFit()
                            .padding(.trailing, 4)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 52, height: 52)
                
                VStack(alignment: .leading) {
                    Text(schoolName)
                        .font(.pretendard(weight: .p4, size: 13))
                        .foregroundStyle(.grey900)
                    
                    Text(festivalName)
                        .font(.pretendard(weight: .p7, size: 12))
                        .foregroundStyle(.grey900)

                    Text(startDate + "-" + endDate)
                        .font(.pretendard(weight: .p4, size: 12))
                        .foregroundStyle(.grey600)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Capsule()
                        .strokeBorder(.primary500, lineWidth: 1)
                        .frame(width: 57, height: 29)
                        .overlay {
                            Text("추가")
                                .font(.pretendard(weight: .p5, size: 12))
                                .foregroundStyle(.primary500)
                        }
                }
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    LongSchoolBoxView(thumbnail: "", schoolName: "건국대학교", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08.")
}
