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
        GeometryReader { geometry in
            ZStack {
                birminghamBackgroundView
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Иконка загрузки
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .shadow(color: Color.green.opacity(0.3), radius: 12, x: 0, y: 4)
                    
                    // Заголовок
                    VStack(spacing: 8) {
                        Text("Loading")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Please wait...")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Прогресс-бар
                    BirminghamProgressBar(birminghamValue: birminghamProgress)
                        .frame(width: min(geometry.size.width * 0.8, 350), height: 12)
                    
                    // Проценты
                    Text("\(birminghamProgressPercentage)%")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// MARK: - Новый красивый градиентный фон

struct BirminghamGreenBackground: View, BirminghamBackgroundProviding {
    func makeBirminghamBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.07, green: 0.45, blue: 0.20),
                Color(red: 0.12, green: 0.65, blue: 0.35),
                Color(red: 0.18, green: 0.80, blue: 0.44)
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
                // Фоновая полоса
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: geometry.size.height)
                
                // Заполнение прогресса с градиентом
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.25, green: 0.85, blue: 0.50),
                            Color(red: 0.15, green: 0.70, blue: 0.35)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: max(0, CGFloat(animatedValue) * geometry.size.width), height: geometry.size.height)
                    .animation(.easeOut(duration: 0.6), value: animatedValue)
                
                // Анимированный индикатор
                Circle()
                    .fill(Color.white)
                    .frame(width: geometry.size.height + 6, height: geometry.size.height + 6)
                    .offset(x: max(0, CGFloat(animatedValue) * geometry.size.width - (geometry.size.height + 6) / 2))
                    .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 2)
                    .scaleEffect(animatedValue > 0 ? 1.0 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animatedValue)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animatedValue = birminghamValue
                }
            }
            .onChange(of: birminghamValue) { newValue in
                withAnimation {
                    animatedValue = newValue
                }
            }
        }
    }
}

// MARK: - Превью

#Preview("Modern Green Loading") {
    BirminghamLoadingOverlay(birminghamProgress: 0.65) {
        BirminghamGreenBackground()
    }
}
