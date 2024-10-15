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
    @EnvironmentObject var stampVM: StampViewModel
    @State private var isScanning = false
    
    var body: some View {
        ZStack {
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
                    
                    Image(systemName: "plus")
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
            
            if isScanning {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView()
                    .tint(Color.white)
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        print("Scanning completed")
        // dismiss() // 스캔이 완료되면 성공 실패 여부와 관계없이 StampView로 돌아감
        
        switch result {
        case .success(let result): // 스캔 성공
            print("Scanning succeeded")
            print(result)
            // 적절한 QR코드인 경우(축제 부스 qr인 경우) -> 스탬프 추가 api 호출
            // 1. QR코드의 string데이터 가져오기
            let scannedString = result.string // QR코드 스캔이 성공했을 때 string 속성은 항상 포함되므로 string 파라미터가 없는 경우는 고려하지 않아도 됨
            
            // 2. string이 비어있는지 확인
            if scannedString.isEmpty {
                stampVM.qrScanToastMsg = Toast(style: .warning, message: "올바르지 않은 QR코드입니다")
                return
            }
            
            // 3. string: "boothId: __" 형식으로 전달되는 경우
            //            if scannedString.hasPrefix("boothId") {
            //                let boothIdString = scannedString.replacingOccurrences(of: "boothId:", with: "").trimmingCharacters(in: .whitespaces)
            //
            //                if let boothId = Int(boothIdString) {
            //                    Task {
            //                        print("boothId: \(boothId)")
            //                        await stampVM.addStamp(boothId: boothId, token: UIDevice.current.deviceToken)
            //                    }
            //                } else {
            //                    print("QR코드의 boothId 형식이 잘못되었습니다")
            //                }
            //            }
            
            // 3. string: "__" 형식으로 전달되는 경우
            if let boothId = Int(scannedString) {
                Task {
                    print("boothId: \(boothId)")
                    isScanning = true
                     await stampVM.addStamp(boothId: boothId, token: UIDevice.current.deviceToken)
                    isScanning = false
                    dismiss()
                }
            } else {
                dismiss()
                stampVM.qrScanToastMsg = Toast(style: .warning, message: "올바르지 않은 QR코드입니다")
            }
        case .failure(let error): // 스캔 실패
            // 카메라 접근 권한 X, QR코드 인식 자체에 실패, CodeScanner init 실패, 카메라 접근 권한 거부되는 경우
            print("Scanning failed: \(error.localizedDescription)")
            dismiss()
            stampVM.qrScanToastMsg = Toast(style: .warning, message: "QR코드 인식에 실패했습니다")
        }
    }
}

#Preview {
    StampQRScanView()
        .environmentObject(StampViewModel(networkManager: NetworkManager()))
}
