import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol BirminghamProgressDisplayable {
    var birminghamProgressPercentage: Int { get }
}

protocol BirminghamBackgroundProviding {
    associatedtype BirminghamBackgroundContent: View
    func makeBirminghamBackground() -> BirminghamBackgroundContent
}

// MARK: - Новый современный экран загрузки

struct BirminghamLoadingOverlay<Background: View>: View, BirminghamProgressDisplayable {
    let birminghamProgress: Double
    let birminghamBackgroundView: Background
    
    var birminghamProgressPercentage: Int { Int(birminghamProgress * 100) }
    
    init(birminghamProgress: Double, @ViewBuilder birminghamBackground: () -> Background) {
        self.birminghamProgress = birminghamProgress
        self.birminghamBackgroundView = birminghamBackground()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                birminghamBackgroundView
                VStack(spacing: 32) {
                    Spacer()
                    Text("Birmingham Loading...")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 2)
                        .padding(.bottom, 12)
                    BirminghamProgressBar(birminghamValue: birminghamProgress)
                        .frame(width: min(geo.size.width * 0.7, 400), height: 16)
                        .padding(.bottom, 8)
                    Text("Загрузка: \(birminghamProgressPercentage)%")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.85))
                        .padding(.bottom, 40)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - Новый красивый градиентный фон

struct BirminghamGreenBackground: View, BirminghamBackgroundProviding {
    func makeBirminghamBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.09, green: 0.55, blue: 0.23),
                Color(red: 0.18, green: 0.80, blue: 0.44),
                Color(red: 0.13, green: 0.95, blue: 0.60)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var body: some View {
        makeBirminghamBackground()
    }
}

// MARK: - Новый прогресс-бар

struct BirminghamProgressBar: View {
    let birminghamValue: Double
    @State private var animatedValue: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: geometry.size.height)
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.18, green: 0.80, blue: 0.44),
                            Color(red: 0.09, green: 0.55, blue: 0.23)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: CGFloat(animatedValue) * geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut(duration: 0.5), value: animatedValue)
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: geometry.size.height * 1.2, height: geometry.size.height * 1.2)
                    .offset(x: max(0, CGFloat(animatedValue) * geometry.size.width - geometry.size.height * 0.6))
                    .shadow(color: Color.green.opacity(0.3), radius: 6, x: 0, y: 2)
                    .animation(.easeInOut(duration: 0.5), value: animatedValue)
            }
            .onAppear { animatedValue = birminghamValue }
            .onChange(of: birminghamValue) { newValue in
                withAnimation { animatedValue = newValue }
            }
        }
    }
}

// MARK: - Превью

#Preview("Green Modern") {
    BirminghamLoadingOverlay(birminghamProgress: 0.42) {
        BirminghamGreenBackground()
    }
}

