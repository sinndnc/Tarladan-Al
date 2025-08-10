//
//  FirebaseServiceError.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//

import Foundation

enum ErrorSeverity: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
    
    var emoji: String {
        switch self {
        case .low: return "ℹ️"
        case .medium: return "⚠️"
        case .high: return "❌"
        case .critical: return "🚨"
        }
    }
}

// MARK: - Dynamic Error Protocol
protocol DynamicServiceError: Error, LocalizedError, CustomStringConvertible {
    var serviceType: String { get }
    var code: String { get }
    var userMessage: String { get }
    var operation: String { get }
    var underlyingError: Error? { get }
    var severity: ErrorSeverity { get }
    var metadata: [String: Any]? { get }
    var timestamp: Date { get }
}

// MARK: - Base Dynamic Error
struct BaseServiceError<ServiceType>: DynamicServiceError {
    let serviceType: String
    let code: String
    let userMessage: String
    let operation: String
    let underlyingError: Error?
    let severity: ErrorSeverity
    let metadata: [String: Any]?
    let timestamp: Date
    
    init(
        serviceType: ServiceType.Type,
        code: String,
        userMessage: String,
        operation: String,
        severity: ErrorSeverity = .medium,
        underlyingError: Error? = nil,
        metadata: [String: Any]? = nil
    ) {
        self.serviceType = String(describing: serviceType)
        self.code = code
        self.userMessage = userMessage
        self.operation = operation
        self.severity = severity
        self.underlyingError = underlyingError
        self.metadata = metadata
        self.timestamp = Date()
    }
    
    // MARK: - LocalizedError
    var errorDescription: String? {
        return userMessage
    }
    
    var localizedDescription: String {
        return "\(severity.emoji) [\(serviceType)] \(userMessage)"
    }
    
    var failureReason: String? {
        return "Service '\(serviceType)' operation '\(operation)' failed with code: \(code)"
    }
    
    var recoverySuggestion: String? {
        return ErrorRecoveryProvider.getSuggestion(for: code, serviceType: serviceType)
    }
    
    // MARK: - CustomStringConvertible
    var description: String {
        var desc = "\(serviceType)Error(code: \(code), operation: \(operation), severity: \(severity.rawValue), timestamp: \(timestamp))"
        if let metadata = metadata {
            desc += ", metadata: \(metadata)"
        }
        if let underlyingError = underlyingError {
            desc += " -> \(underlyingError.localizedDescription)"
        }
        return desc
    }
}

// MARK: - Error Recovery Provider
struct ErrorRecoveryProvider {
    static func getSuggestion(for code: String, serviceType: String) -> String {
        let baseService = serviceType.lowercased()
        
        switch code {
        case "MISSING_DOCUMENT_ID":
            return "\(baseService) için geçerli bir ID sağlayın."
        case "DOCUMENT_NOT_FOUND":
            return "\(baseService) verilerini yenileyin veya varlığını kontrol edin."
        case "NETWORK_ERROR":
            return "İnternet bağlantınızı kontrol edin ve \(baseService) işlemini tekrar deneyin."
        case "PERMISSION_DENIED":
            return "\(baseService) erişimi için yeniden giriş yapın."
        case "SERIALIZATION_FAILED":
            return "\(baseService) veri formatını kontrol edin."
        case "VALIDATION_FAILED":
            return "\(baseService) için girilen bilgileri kontrol edin."
        case "RATE_LIMIT_EXCEEDED":
            return "\(baseService) için çok fazla istek gönderildi, lütfen bekleyin."
        case "SERVICE_UNAVAILABLE":
            return "\(baseService) servisi geçici olarak kullanılamıyor."
        default:
            return "\(baseService) işlemini tekrar deneyin veya destek ile iletişime geçin."
        }
    }
}

// MARK: - Dynamic Error Factory
struct ServiceErrorFactory {
    // MARK: - Generic Error Creation Methods
    static func create<T>(
        for serviceType: T.Type,
        code: String,
        userMessage: String,
        operation: String,
        severity: ErrorSeverity = .medium,
        underlyingError: Error? = nil,
        metadata: [String: Any]? = nil
    ) -> BaseServiceError<T> {
        return BaseServiceError<T>(
            serviceType: serviceType,
            code: code,
            userMessage: userMessage,
            operation: operation,
            severity: severity,
            underlyingError: underlyingError,
            metadata: metadata
        )
    }
    
    // MARK: - Common Firebase Errors
    static func missingDocumentId<T>(for serviceType: T.Type, operation: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "MISSING_DOCUMENT_ID",
            userMessage: "Belge kimliği gerekli",
            operation: operation,
            severity: .high
        )
    }
    
    static func documentNotFound<T>(for serviceType: T.Type, id: String, operation: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "DOCUMENT_NOT_FOUND",
            userMessage: "Aranan veri bulunamadı",
            operation: operation,
            severity: .medium,
            metadata: ["documentId": id]
        )
    }
    
    static func networkError<T>(for serviceType: T.Type, operation: String, underlyingError: Error) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "NETWORK_ERROR",
            userMessage: "İnternet bağlantısı sorunu",
            operation: operation,
            severity: .medium,
            underlyingError: underlyingError
        )
    }
    
    static func serializationFailed<T>(for serviceType: T.Type, operation: String, underlyingError: Error) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "SERIALIZATION_FAILED",
            userMessage: "Veri işleme hatası",
            operation: operation,
            severity: .high,
            underlyingError: underlyingError
        )
    }
    
    static func permissionDenied<T>(for serviceType: T.Type, operation: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "PERMISSION_DENIED",
            userMessage: "Bu işlem için yetkiniz bulunmuyor",
            operation: operation,
            severity: .high
        )
    }
    
    static func validationFailed<T>(for serviceType: T.Type, operation: String, reason: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "VALIDATION_FAILED",
            userMessage: "Girilen bilgiler geçersiz",
            operation: operation,
            severity: .medium,
            metadata: ["reason": reason]
        )
    }
    
    static func rateLimitExceeded<T>(for serviceType: T.Type, operation: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "RATE_LIMIT_EXCEEDED",
            userMessage: "Çok fazla istek gönderildi",
            operation: operation,
            severity: .medium
        )
    }
    
    static func serviceUnavailable<T>(for serviceType: T.Type, operation: String) -> BaseServiceError<T> {
        return create(
            for: serviceType,
            code: "SERVICE_UNAVAILABLE",
            userMessage: "Servis geçici olarak kullanılamıyor",
            operation: operation,
            severity: .high
        )
    }
}

// MARK: - Firebase Error Handler
struct FirebaseErrorHandler {
    static func mapFirebaseError<T>(
        _ error: Error,
        for serviceType: T.Type,
        operation: String
    ) -> BaseServiceError<T> {
        if let nsError = error as NSError? {
            switch nsError.code {
            case 7: // Permission denied
                return ServiceErrorFactory.permissionDenied(for: serviceType, operation: operation)
            case 5: // Document not found
                return ServiceErrorFactory.documentNotFound(for: serviceType, id: "unknown", operation: operation)
            case 14: // Unavailable (network)
                return ServiceErrorFactory.networkError(for: serviceType, operation: operation, underlyingError: error)
            case 8: // Resource exhausted
                return ServiceErrorFactory.rateLimitExceeded(for: serviceType, operation: operation)
            case 13: // Internal error
                return ServiceErrorFactory.serviceUnavailable(for: serviceType, operation: operation)
            default:
                return ServiceErrorFactory.networkError(for: serviceType, operation: operation, underlyingError: error)
            }
        } else {
            return ServiceErrorFactory.networkError(for: serviceType, operation: operation, underlyingError: error)
        }
    }
}
