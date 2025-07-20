import Foundation
import SwiftUI
import WebKit

// MARK: - Протоколы

/// Протокол для состояний загрузки с расширенной функциональностью
protocol BirminghamWebLoadStateRepresentable {
    var birminghamType: BirminghamWebLoadState.BirminghamStateType { get }
    var birminghamPercent: Double? { get }
    var birminghamError: String? { get }
    
    func isBirminghamEqual(to other: Self) -> Bool
}

// MARK: - Улучшенная структура состояния загрузки

/// Структура для представления состояний веб-загрузки
struct BirminghamWebLoadState: Equatable, BirminghamWebLoadStateRepresentable {
    // MARK: - Перечисление типов состояний
    
    /// Типы состояний загрузки с порядковым номером
    enum BirminghamStateType: Int, CaseIterable {
        case idle = 0
        case progress
        case success
        case error
        case offline
        
        /// Человекочитаемое описание состояния
        var birminghamDescription: String {
            switch self {
            case .idle: return "Ожидание"
            case .progress: return "Загрузка"
            case .success: return "Успешно"
            case .error: return "Ошибка"
            case .offline: return "Нет подключения"
            }
        }
    }
    
    // MARK: - Свойства
    
    let birminghamType: BirminghamStateType
    let birminghamPercent: Double?
    let birminghamError: String?
    
    // MARK: - Статические конструкторы
    
    /// Создание состояния простоя
    static func idle() -> BirminghamWebLoadState {
        BirminghamWebLoadState(birminghamType: .idle, birminghamPercent: nil, birminghamError: nil)
    }
    
    /// Создание состояния прогресса
    static func progress(_ birminghamPercent: Double) -> BirminghamWebLoadState {
        BirminghamWebLoadState(birminghamType: .progress, birminghamPercent: birminghamPercent, birminghamError: nil)
    }
    
    /// Создание состояния успеха
    static func success() -> BirminghamWebLoadState {
        BirminghamWebLoadState(birminghamType: .success, birminghamPercent: nil, birminghamError: nil)
    }
    
    /// Создание состояния ошибки
    static func error(_ birminghamErr: String) -> BirminghamWebLoadState {
        BirminghamWebLoadState(birminghamType: .error, birminghamPercent: nil, birminghamError: birminghamErr)
    }
    
    /// Создание состояния отсутствия подключения
    static func offline() -> BirminghamWebLoadState {
        BirminghamWebLoadState(birminghamType: .offline, birminghamPercent: nil, birminghamError: nil)
    }
    
    // MARK: - Методы сравнения
    
    /// Пользовательская реализация сравнения
    func isBirminghamEqual(to other: BirminghamWebLoadState) -> Bool {
        guard birminghamType == other.birminghamType else { return false }
        
        switch birminghamType {
        case .progress:
            return birminghamPercent == other.birminghamPercent
        case .error:
            return birminghamError == other.birminghamError
        default:
            return true
        }
    }
    
    // MARK: - Реализация Equatable
    
    static func == (lhs: BirminghamWebLoadState, rhs: BirminghamWebLoadState) -> Bool {
        lhs.isBirminghamEqual(to: rhs)
    }
}

// MARK: - Расширения для улучшения функциональности

extension BirminghamWebLoadState {
    /// Проверка текущего состояния
    var isBirminghamLoading: Bool {
        birminghamType == .progress
    }
    
    /// Проверка успешного состояния
    var isBirminghamSuccessful: Bool {
        birminghamType == .success
    }
    
    /// Проверка состояния ошибки
    var hasBirminghamError: Bool {
        birminghamType == .error
    }
}

// MARK: - Расширение для отладки

extension BirminghamWebLoadState: CustomStringConvertible {
    /// Строковое представление состояния
    var description: String {
        switch birminghamType {
        case .idle: return "Состояние: Ожидание"
        case .progress: return "Состояние: Загрузка (\(birminghamPercent?.formatted() ?? "0")%)"
        case .success: return "Состояние: Успешно"
        case .error: return "Состояние: Ошибка (\(birminghamError ?? "Неизвестная ошибка"))"
        case .offline: return "Состояние: Нет подключения"
        }
    }
}

