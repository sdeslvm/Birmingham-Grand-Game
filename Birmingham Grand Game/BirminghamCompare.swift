import Foundation

// MARK: - Протоколы и расширения

/// Протокол для статусов с возможностью сравнения
protocol BirminghamWebStatusComparable {
    func isEquivalent(to other: Self) -> Bool
}

// MARK: - Улучшенное перечисление статусов

/// Перечисление статусов веб-соединения с расширенной функциональностью
enum BirminghamWebStatus: Equatable, BirminghamWebStatusComparable {
    case standby
    case progressing(birminghamProgress: Double)
    case finished
    case failure(birminghamReason: String)
    case noConnection
    // MARK: - Пользовательские методы сравнения
    /// Проверка эквивалентности статусов с точным сравнением
    func isEquivalent(to other: BirminghamWebStatus) -> Bool {
        switch (self, other) {
        case (.standby, .standby), 
             (.finished, .finished), 
             (.noConnection, .noConnection):
            return true
        case let (.progressing(a), .progressing(b)):
            return abs(a - b) < 0.0001
        case let (.failure(birminghamReasonA), .failure(birminghamReasonB)):
            return birminghamReasonA == birminghamReasonB
        default:
            return false
        }
    }
    // MARK: - Вычисляемые свойства
    /// Текущий прогресс подключения
    var birminghamProgress: Double? {
        guard case let .progressing(value) = self else { return nil }
        return value
    }
    /// Индикатор успешного завершения
    var isBirminghamSuccessful: Bool {
        switch self {
        case .finished: return true
        default: return false
        }
    }
    /// Индикатор наличия ошибки
    var hasBirminghamError: Bool {
        switch self {
        case .failure, .noConnection: return true
        default: return false
        }
    }
}
// MARK: - Расширения для улучшения функциональности
extension BirminghamWebStatus {
    /// Безопасное извлечение причины ошибки
    var birminghamErrorReason: String? {
        guard case let .failure(birminghamReason) = self else { return nil }
        return birminghamReason
    }
}
// MARK: - Кастомная реализация Equatable
extension BirminghamWebStatus {
    static func == (lhs: BirminghamWebStatus, rhs: BirminghamWebStatus) -> Bool {
        lhs.isEquivalent(to: rhs)
    }
}
