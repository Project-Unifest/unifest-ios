//
//  TestView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/29/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        Image(.homeIcon)
            .resizable()
            .scaledToFit()
            .frame(width: 200)
    }
}

#Preview {
    TestView()
}
