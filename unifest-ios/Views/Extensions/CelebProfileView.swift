//
//  CelebProfileView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/24/24.
//

import SwiftUI

struct CelebProfileView: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://cdn.mediatoday.co.kr/news/photo/202311/313885_438531_4716.jpg"))
            .clipShape(Circle())
            .frame(width: 53, height: 53)
    }
}

#Preview {
    CelebProfileView()
}
