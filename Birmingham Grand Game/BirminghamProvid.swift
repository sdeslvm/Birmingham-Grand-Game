import SwiftUI
import WebKit

// MARK: - Протоколы и расширения

/// Протокол для создания градиентных представлений
protocol BirminghamGradientProviding {
    func createBirminghamGradientLayer() -> CAGradientLayer
}

// MARK: - Улучшенный контейнер с градиентом

/// Кастомный контейнер с градиентным фоном
final class BirminghamGradientContainerView: UIView, BirminghamGradientProviding {
    // MARK: - Приватные свойства
    
    private let birminghamGradientLayer = CAGradientLayer()
    
    // MARK: - Инициализаторы
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBirminghamView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBirminghamView()
    }
    
    // MARK: - Методы настройки
    
    private func setupBirminghamView() {
        layer.insertSublayer(createBirminghamGradientLayer(), at: 0)
    }
    
    /// Создание градиентного слоя
    func createBirminghamGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(birminghamHex: "#1BD8FD").cgColor,
            UIColor(birminghamHex: "#0FC9FA").cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }
    
    // MARK: - Обновление слоя
    
    override func layoutSubviews() {
        super.layoutSubviews()
        birminghamGradientLayer.frame = bounds
    }
}

// MARK: - Расширения для цветов

extension UIColor {
    /// Инициализатор цвета из HEX-строки с улучшенной обработкой
    convenience init(birminghamHex hexString: String) {
        let sanitizedHex = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var colorValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&colorValue)
        
        let redComponent = CGFloat((colorValue & 0xFF0000) >> 16) / 255.0
        let greenComponent = CGFloat((colorValue & 0x00FF00) >> 8) / 255.0
        let blueComponent = CGFloat(colorValue & 0x0000FF) / 255.0
        
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
}

// MARK: - Представление веб-вида

struct BirminghamWebViewBox: UIViewRepresentable {
    // MARK: - Свойства
    
    @ObservedObject var birminghamLoader: BirminghamWebLoader
    
    // MARK: - Координатор
    
    func makeCoordinator() -> BirminghamWebCoordinator {
        BirminghamWebCoordinator { [weak birminghamLoader] birminghamStatus in
            DispatchQueue.main.async {
                birminghamLoader?.birminghamState = birminghamStatus
            }
        }
    }
    
    // MARK: - Создание представления
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = createBirminghamWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        setupBirminghamWebViewAppearance(webView)
        setupBirminghamContainerView(with: webView)
        
        webView.navigationDelegate = context.coordinator
        birminghamLoader.attachBirminghamWebView { webView }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Here you can update the WKWebView as needed, e.g., reload content when the loader changes.
        // For now, this can be left empty or you can update it as per loader's state if needed.
    }
    
    // MARK: - Приватные методы настройки
    
    private func createBirminghamWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        return configuration
    }
    
    private func setupBirminghamWebViewAppearance(_ webView: WKWebView) {
        webView.backgroundColor = .clear
        webView.isOpaque = false
    }
    
    private func setupBirminghamContainerView(with webView: WKWebView) {
        let containerView = BirminghamGradientContainerView()
        containerView.addSubview(webView)
        
        webView.frame = containerView.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func clearBirminghamWebsiteData() {
        let dataTypes: Set<String> = [
            .diskCache,
            .memoryCache,
            .cookies,
            .localStorage
        ]
        
        WKWebsiteDataStore.default().removeData(
            ofTypes: dataTypes,
            modifiedSince: .distantPast
        ) {}
    }
}

// MARK: - Расширение для типов данных

extension String {
    static let diskCache = WKWebsiteDataTypeDiskCache
    static let memoryCache = WKWebsiteDataTypeMemoryCache
    static let cookies = WKWebsiteDataTypeCookies
    static let localStorage = WKWebsiteDataTypeLocalStorage
}

