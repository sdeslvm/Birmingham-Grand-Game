import SwiftUI
import Foundation

struct BirminghamEntryScreen: View {
    @StateObject private var birminghamLoader: BirminghamWebLoader

    init(birminghamLoader: BirminghamWebLoader) {
        _birminghamLoader = StateObject(wrappedValue: birminghamLoader)
    }

    var body: some View {
        ZStack {
            BirminghamWebViewBox(birminghamLoader: birminghamLoader)
                .opacity(birminghamLoader.birminghamState == .finished ? 1 : 0.5)
            switch birminghamLoader.birminghamState {
            case .progressing(let birminghamPercent):
                BirminghamProgressIndicator(birminghamValue: birminghamPercent)
            case .failure(let birminghamErr):
                BirminghamErrorIndicator(birminghamErr: birminghamErr) // err теперь String
            case .noConnection:
                BirminghamOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct BirminghamProgressIndicator: View {
    let birminghamValue: Double
    var body: some View {
        GeometryReader { geo in
            BirminghamLoadingOverlay(birminghamProgress: birminghamValue) {
                BirminghamGreenBackground()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.black)
        }
    }
}

private struct BirminghamErrorIndicator: View {
    let birminghamErr: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(birminghamErr)").foregroundColor(.red)
    }
}

private struct BirminghamOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
