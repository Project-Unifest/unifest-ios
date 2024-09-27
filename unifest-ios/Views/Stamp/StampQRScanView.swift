//
//  StampQRScanView.swift
//  unifest-ios
//
//  Created by 임지성 on 9/9/24.
//

import CodeScanner
import SwiftUI

struct StampQRScanView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var addStampToast: Toast?
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.grey600)
                }
                
                Text("스탬프 QR 스캔")
                    .font(.pretendard(weight: .p6, size: 20))
                    .foregroundStyle(.grey900)
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 25)
            
            ZStack {
                CodeScannerView(codeTypes: [.qr], completion: handleScan)
                    .frame(height: 510)
                
                Image(systemName: "plus.viewfinder")
                    .font(.pretendard(weight: .p1, size: 45))
                    .foregroundStyle(.yellow)
            }
            
            VStack {
                Spacer()
                
                Text("카메라를 조준선에 맞춰주세요!")
                    .font(.pretendard(weight: .p6, size: 22))
                    .foregroundStyle(.grey900)
                Text("※ 하나의 부스에서는 하나의 스탬프만 받을 수 있습니다")
                    .font(.pretendard(weight: .p3, size: 13))
                    .foregroundStyle(.grey900)
                
                Spacer()
            }
        }
        .dynamicTypeSize(.large)
        .background(Color.ufBackground)
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        dismiss()
        
        print("Scanning completed")
        switch result {
        case .success(let result):
            print("Scanning succeeded")
            print(result)
            addStampToast = Toast(style: .success, message: "QR코드 스캔 성공")
        case .failure(let error):
            print("Scannign failed: \(error.localizedDescription)")
            addStampToast = Toast(style: .warning, message: "QR코드 스캔 실패")
        }
    }
}

#Preview {
    StampQRScanView(addStampToast: .constant(nil))
}
