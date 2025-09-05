//
//  ScalableImageView.swift
//  unifest-ios
//
//  Created by 김영현 on 7/29/25.
//

import SwiftUI

struct ScalableImageView: View {
    
    let imageName: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var imageSize: CGSize = .zero
    
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 4.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                zoomableImageView(geometry)
                
                dismissNavigationView
            }
        }
        .statusBarHidden()
        .onAppear {
            scale = minScale
            offset = .zero
            lastOffset = .zero
        }
    }
}

// MARK: - Components

private extension ScalableImageView {
    
    func zoomableImageView(_ geometry: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: imageName)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(
                    GeometryReader { imageGeometry in
                        Color.clear
                            .onAppear {
                                imageSize = imageGeometry.size
                            }
                    }
                )
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        zoomGesture(geometry),
                        dragGesture(geometry)
                    )
                )
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if scale > minScale {
                            scale = minScale
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 2.0
                            let correctedOffset = limitOffset(
                                offset: offset,
                                scale: 2.0,
                                imageSize: imageSize,
                                screenSize: geometry.size
                            )
                            offset = correctedOffset
                            lastOffset = correctedOffset
                        }
                    }
                }
        } placeholder: {
            ProgressView()
                .tint(.white)
                .scaleEffect(1.5)
        }
    }
    
    var dismissNavigationView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 20)
                .padding(.top, 8)
            }
            Spacer()
        }
    }
    
    func zoomGesture(_ geometry: GeometryProxy) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let delta = value.magnification / lastScale
                lastScale = value.magnification
                let newScale = scale * delta
                scale = min(max(newScale, minScale), maxScale)
            }
            .onEnded { _ in
                lastScale = 1.0
                if scale < minScale {
                    withAnimation(.easeOut(duration: 0.3)) {
                        scale = minScale
                        offset = .zero
                        lastOffset = .zero
                    }
                } else {
                    let correctedOffset = limitOffset(
                        offset: offset,
                        scale: scale,
                        imageSize: imageSize,
                        screenSize: geometry.size
                    )
                    if correctedOffset != offset {
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = correctedOffset
                            lastOffset = correctedOffset
                        }
                    }
                }
            }
    }
    
    func dragGesture(_ geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let newOffset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
                offset = limitOffset(
                    offset: newOffset,
                    scale: scale,
                    imageSize: imageSize,
                    screenSize: geometry.size
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
    
    func limitOffset(offset: CGSize, scale: CGFloat, imageSize: CGSize, screenSize: CGSize) -> CGSize {
        // 1배율일 때는 중앙 고정
        guard scale > 1.0 else {
            return .zero
        }
        
        // 확대된 이미지의 실제 크기 계산
        let scaledImageSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
        
        // 이동 가능한 최대 거리 계산
        let maxOffsetX = max(0, (scaledImageSize.width - screenSize.width) / 2)
        let maxOffsetY = max(0, (scaledImageSize.height - screenSize.height) / 2)
        
        // 오프셋 제한
        let limitedX = min(max(offset.width, -maxOffsetX), maxOffsetX)
        let limitedY = min(max(offset.height, -maxOffsetY), maxOffsetY)
        
        return CGSize(width: limitedX, height: limitedY)
    }
}

#Preview {
    ScalableImageView(imageName: "https://content.foodspring.co.kr/vendor/1781/images/101_4100052181_r.png")
}
