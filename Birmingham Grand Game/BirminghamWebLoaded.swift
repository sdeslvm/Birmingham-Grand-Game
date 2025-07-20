import SwiftUI
import Combine
import WebKit

// MARK: - Протоколы

/// Протокол для управления состоянием веб-загрузки
protocol BirminghamWebLoadable: AnyObject {
    var birminghamState: BirminghamWebStatus { get set }
    func setBirminghamConnectivity(_ birminghamAvailable: Bool)
}

/// Протокол для мониторинга прогресса загрузки
protocol BirminghamProgressMonitoring {
    func observeBirminghamProgression()
    func monitorBirmingham(_ birminghamWebView: WKWebView)
}

// MARK: - Основной загрузчик веб-представления

/// Класс для управления загрузкой и состоянием веб-представления
final class BirminghamWebLoader: NSObject, ObservableObject, BirminghamWebLoadable, BirminghamProgressMonitoring {
    // MARK: - Свойства
    
    @Published var birminghamState: BirminghamWebStatus = .standby
    
    let birminghamResource: URL
    private var birminghamCancellables = Set<AnyCancellable>()
    private var birminghamProgressPublisher = PassthroughSubject<Double, Never>()
    private var birminghamWebViewProvider: (() -> WKWebView)?
    
    // MARK: - Инициализация
    
    init(birminghamResourceURL: URL) {
        self.birminghamResource = birminghamResourceURL
        super.init()
        observeBirminghamProgression()
    }
    
    // MARK: - Публичные методы
    
    /// Привязка веб-представления к загрузчику
    func attachBirminghamWebView(factory: @escaping () -> WKWebView) {
        birminghamWebViewProvider = factory
        triggerBirminghamLoad()
    }
    
    /// Установка доступности подключения
    func setBirminghamConnectivity(_ birminghamAvailable: Bool) {
        switch (birminghamAvailable, birminghamState) {
        case (true, .noConnection):
            triggerBirminghamLoad()
        case (false, _):
            birminghamState = .noConnection
        default:
            break
        }
    }
    
    // MARK: - Приватные методы загрузки
    
    /// Запуск загрузки веб-представления
    private func triggerBirminghamLoad() {
        guard let birminghamWebView = birminghamWebViewProvider?() else { return }
        
        let birminghamRequest = URLRequest(url: birminghamResource, timeoutInterval: 12)
        birminghamState = .progressing(birminghamProgress: 0)
        
        birminghamWebView.navigationDelegate = self
        birminghamWebView.load(birminghamRequest)
        monitorBirmingham(birminghamWebView)
    }
    
    // MARK: - Методы мониторинга
    
    /// Наблюдение за прогрессом загрузки
    func observeBirminghamProgression() {
        birminghamProgressPublisher
            .removeDuplicates()
            .sink { [weak self] birminghamProgress in
                guard let self else { return }
                self.birminghamState = birminghamProgress < 1.0 ? .progressing(birminghamProgress: birminghamProgress) : .finished
            }
            .store(in: &birminghamCancellables)
    }
    
    /// Мониторинг прогресса веб-представления
    func monitorBirmingham(_ birminghamWebView: WKWebView) {
        birminghamWebView.publisher(for: \.estimatedProgress)
            .sink { [weak self] birminghamProgress in
                self?.birminghamProgressPublisher.send(birminghamProgress)
            }
            .store(in: &birminghamCancellables)
    }
}

// MARK: - Расширение для обработки навигации

extension BirminghamWebLoader: WKNavigationDelegate {
    /// Обработка ошибок при навигации
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleBirminghamNavigationError(error)
    }
    
    /// Обработка ошибок при provisional навигации
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleBirminghamNavigationError(error)
    }
    
    // MARK: - Приватные методы обработки ошибок
    
    /// Обобщенный метод обработки ошибок навигации
    private func handleBirminghamNavigationError(_ error: Error) {
        birminghamState = .failure(birminghamReason: error.localizedDescription)
    }
}

// MARK: - Расширения для улучшения функциональности

extension BirminghamWebLoader {
    /// Создание загрузчика с безопасным URL
    convenience init?(birminghamURLString: String) {
        guard let birminghamURL = URL(string: birminghamURLString) else { return nil }
        self.init(birminghamResourceURL: birminghamURL)
    }
}
