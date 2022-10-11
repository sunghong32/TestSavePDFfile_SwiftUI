//
//  ContentView.swift
//  TestSavePDF
//
//  Created by 민성홍 on 2022/10/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .padding(.bottom)

            Button {
                savePDf()
            } label: {
                Text("Save PDF")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.red)

        }
        .padding()
    }

    func savePDf() {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("SwiftUIPDF.pdf")

        // A4사이즈
        let pageSize = CGSize(width: 595.2, height: 841.8)

        // PDF로 만들 뷰
        let myUIHostingController = UIHostingController(rootView: ContentView())
        myUIHostingController.view.frame = CGRect(origin: .zero, size: pageSize)


        // 뒤에 있는 다른 모든 뷰도 렌더링
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let rootVC = windowScene?.windows.first?.rootViewController else {
            print("ERROR: Could not find root ViewController.")
            return
        }
        rootVC.addChild(myUIHostingController)
        // at: 0 -> draws behind all other views
        // at: UIApplication.shared.windows.count -> draw in front
        rootVC.view.insertSubview(myUIHostingController.view, at: 0)


        // PDF파일로 렌더링
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        DispatchQueue.main.async {
            do {
                try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                    context.beginPage()
                    myUIHostingController.view.layer.render(in: context.cgContext)
                })
                print("저장된 PDF 파일 경로: \(outputFileURL.path)")
            } catch {
                print("PDF파일 저장 실패: \(error.localizedDescription)")
            }

            // 렌더링 완료된 뷰 제거
            myUIHostingController.removeFromParent()
            myUIHostingController.view.removeFromSuperview()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
