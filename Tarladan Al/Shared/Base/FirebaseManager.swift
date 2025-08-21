//
//  FirebaseModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/10/25.
//
import Foundation
import FirebaseFirestore
import Combine

// MARK: - Dynamic Firebase Base Service
@available(iOS 13.0, *)
class FirebaseManager<T: FirebaseModel> {
    
    // MARK: - Type Definitions
    typealias ServiceError = BaseServiceError<FirebaseManager<T>>
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    private let collectionName: String
    private var cancellables = Set<AnyCancellable>()
    
    private var listeners: [String: ListenerRegistration] = [:]
    private var subjects: [String: PassthroughSubject<[T], ServiceError>] = [:]
    
    //MARK: - Error handling configuration
    var enableErrorLogging: Bool = true
    var errorLogger: ((DynamicServiceError) -> Void)?
    
    // MARK: - Initialization
    init(collectionName: String, errorLogger: ((DynamicServiceError) -> Void)? = nil) {
        self.collectionName = collectionName
        self.errorLogger = errorLogger
    }
    
    // MARK: - Create Operations
    func create(_ model: T) -> AnyPublisher<String, ServiceError> {
        return Future<String, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager.self,
                    operation: "CREATE"
                )
                promise(.failure(error))
                return
            }
            
            var model = model
            let docRef = self.db.collection(self.collectionName).document()
            model.id = docRef.documentID
            
            do {
                try docRef.setData(from: model) { error in
                    if let error = error {
                        let serviceError = self.handleError(error, operation: "CREATE")
                        promise(.failure(serviceError))
                    } else {
                        promise(.success(docRef.documentID))
                    }
                }
            } catch {
                let serviceError = ServiceErrorFactory.serializationFailed(
                    for: FirebaseManager<T>.self,
                    operation: "CREATE",
                    underlyingError: error
                )
                self.logError(serviceError)
                promise(.failure(serviceError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func create(_ model: T, withId id: String) -> AnyPublisher<Void, ServiceError> {
        return Future<Void, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "CREATE_WITH_ID"
                )
                promise(.failure(error))
                return
            }
            
            var model = model
            model.id = id
            
            do {
                try self.db.collection(self.collectionName).document(id).setData(from: model) { error in
                    if let error = error {
                        let serviceError = self.handleError(error, operation: "CREATE_WITH_ID")
                        promise(.failure(serviceError))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                let serviceError = ServiceErrorFactory.serializationFailed(
                    for: FirebaseManager<T>.self,
                    operation: "CREATE_WITH_ID",
                    underlyingError: error
                )
                self.logError(serviceError)
                promise(.failure(serviceError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Read Operations
    func get(id: String) -> AnyPublisher<T?, ServiceError> {
        return Future<T?, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "GET"
                )
                promise(.failure(error))
                return
            }
            
            self.db.collection(self.collectionName).document(id).getDocument { snapshot, error in
                if let error = error {
                    let serviceError = self.handleError(error, operation: "GET")
                    promise(.failure(serviceError))
                    return
                }
                
                guard let document = snapshot else {
                    let serviceError = ServiceErrorFactory.documentNotFound(
                        for: FirebaseManager<T>.self,
                        id: id,
                        operation: "GET"
                    )
                    self.logError(serviceError)
                    promise(.failure(serviceError))
                    return
                }
                
                if document.exists {
                    do {
                        let model = try document.data(as: T.self)
                        promise(.success(model))
                    } catch {
                        let serviceError = ServiceErrorFactory.serializationFailed(
                            for: FirebaseManager<T>.self,
                            operation: "GET",
                            underlyingError: error
                        )
                        self.logError(serviceError)
                        promise(.failure(serviceError))
                    }
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAll() -> AnyPublisher<[T], ServiceError> {
        return Future<[T], ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "GET_ALL"
                )
                promise(.failure(error))
                return
            }
            
            self.db.collection(self.collectionName).getDocuments { snapshot, error in
                if let error = error {
                    let serviceError = self.handleError(error, operation: "GET_ALL")
                    promise(.failure(serviceError))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    promise(.success([]))
                    return
                }
                
                do {
                    let models = try documents.compactMap { document -> T? in
                        try document.data(as: T.self)
                    }
                    promise(.success(models))
                } catch {
                    let serviceError = ServiceErrorFactory.serializationFailed(
                        for: FirebaseManager<T>.self,
                        operation: "GET_ALL",
                        underlyingError: error
                    )
                    self.logError(serviceError)
                    promise(.failure(serviceError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Update Operations
    func update(id: String, data: [String: Any]) -> AnyPublisher<Void, ServiceError> {
        return Future<Void, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "UPDATE"
                )
                promise(.failure(error))
                return
            }
            
            self.db.collection(self.collectionName).document(id).updateData(data) { error in
                if let error = error {
                    let serviceError = self.handleError(error, operation: "UPDATE")
                    promise(.failure(serviceError))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateArray(id: String, data: [String: Any]) -> AnyPublisher<Void, ServiceError> {
        return Future<Void, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "UPDATE"
                )
                promise(.failure(error))
                return
            }
            
            self.db.collection(self.collectionName).document(id)
                .updateData(data){ error in
                    if let error = error {
                        let serviceError = self.handleError(error, operation: "UPDATE")
                        promise(.failure(serviceError))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
   
    func update(_ model: T) -> AnyPublisher<Void, ServiceError> {
        return Future<Void, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "UPDATE_MODEL"
                )
                promise(.failure(error))
                return
            }
            
            guard let id = model.id else {
                let error = ServiceErrorFactory.missingDocumentId(
                    for: FirebaseManager<T>.self,
                    operation: "UPDATE_MODEL"
                )
                self.logError(error)
                promise(.failure(error))
                return
            }
            
            do {
                try self.db.collection(self.collectionName).document(id).setData(from: model, merge: true) { error in
                    if let error = error {
                        let serviceError = self.handleError(error, operation: "UPDATE_MODEL")
                        promise(.failure(serviceError))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                let serviceError = ServiceErrorFactory.serializationFailed(
                    for: FirebaseManager<T>.self,
                    operation: "UPDATE_MODEL",
                    underlyingError: error
                )
                self.logError(serviceError)
                promise(.failure(serviceError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Delete Operations
    func delete(id: String) -> AnyPublisher<Void, ServiceError> {
        return Future<Void, ServiceError> { [weak self] promise in
            guard let self = self else {
                let error = ServiceErrorFactory.serviceUnavailable(
                    for: FirebaseManager<T>.self,
                    operation: "DELETE"
                )
                promise(.failure(error))
                return
            }
            
            self.db.collection(self.collectionName).document(id).delete { error in
                if let error = error {
                    let serviceError = self.handleError(error, operation: "DELETE")
                    promise(.failure(serviceError))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(_ model: T) -> AnyPublisher<Void, ServiceError> {
        guard let id = model.id else {
            let error = ServiceErrorFactory.missingDocumentId(
                for: FirebaseManager<T>.self,
                operation: "DELETE_MODEL"
            )
            logError(error)
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return delete(id: id)
    }
    
    // MARK: - Listen Operations
    func listen() -> AnyPublisher<[T], ServiceError> {
        let listenerKey = collectionName // veya unique bir identifier
        
        // Eğer bu collection için zaten aktif listener varsa, mevcut subject'i döndür
        if let existingSubject = subjects[listenerKey] {
            Logger.log("📡 EXISTING LISTENER: Using existing listener for \(listenerKey)")
            return existingSubject.eraseToAnyPublisher()
        }
        
        // Yeni subject oluştur
        let subject = PassthroughSubject<[T], ServiceError>()
        subjects[listenerKey] = subject
        
        // Firebase listener oluştur
        let listener = db.collection(collectionName).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                let serviceError = self.handleError(error, operation: "LISTEN_COLLECTION")
                Logger.log("❌ FIREBASE ERROR (\(listenerKey)): \(serviceError)")
                subject.send(completion: .failure(serviceError))
                
                // Cleanup
                self.cleanupListener(for: listenerKey)
                return
            }
            
            guard let documents = snapshot?.documents else {
                Logger.log("📝 EMPTY DOCUMENTS (\(listenerKey))")
                subject.send([])
                return
            }
            
            do {
                let models = try documents.compactMap { document -> T? in
                    try document.data(as: T.self)
                }
                Logger.log("✅ MODELS (\(listenerKey)): \(models.count) items")
                subject.send(models)
            } catch {
                let serviceError = ServiceErrorFactory.serializationFailed(
                    for: FirebaseManager<T>.self,
                    operation: "LISTEN_COLLECTION",
                    underlyingError: error
                )
                Logger.log("❌ SERIALIZATION ERROR (\(listenerKey)): \(serviceError)")
                self.logError(serviceError)
                subject.send(completion: .failure(serviceError))
                
                // Cleanup
                self.cleanupListener(for: listenerKey)
            }
        }
        
        // Listener'ı dictionary'de sakla
        listeners[listenerKey] = listener
        Logger.log("🚀 NEW LISTENER: Created listener for \(listenerKey)")
        
        return subject
            .handleEvents(
                receiveCancel: { [weak self] in
                    Logger.log("🔴 LISTENER CANCELLED: \(listenerKey)")
                    self?.cleanupListener(for: listenerKey)
                }
            )
            .eraseToAnyPublisher()
    }
    
    func listen(id: String) -> AnyPublisher<T, ServiceError> {
        let subject = PassthroughSubject<T, ServiceError>()
        
        let listener = db.collection(collectionName).document(id).addSnapshotListener { [weak self, weak subject] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                let serviceError = self.handleError(error, operation: "LISTEN_DOCUMENT")
                subject?.send(completion: .failure(serviceError))
                return
            }
            
            guard let document = snapshot else {
                let serviceError = ServiceError(
                    serviceType: FirebaseManager<T>.self,
                    code: "NO_SNAPSHOT",
                    userMessage: "No snapshot received",
                    operation: "LISTEN_DOCUMENT"
                )
                subject?.send(completion: .failure(serviceError))
                return
            }
            
            if document.exists {
                do {
                    let model = try document.data(as: T.self)
                    subject?.send(model)
                } catch {
                    let serviceError = ServiceErrorFactory.serializationFailed(
                        for: FirebaseManager<T>.self,
                        operation: "LISTEN_DOCUMENT",
                        underlyingError: error
                    )
                    self.logError(serviceError)
                    subject?.send(completion: .failure(serviceError))
                }
            } else {
                let serviceError = ServiceError(
                    serviceType: FirebaseManager<T>.self,
                    code: "DOCUMENT_NOT_EXISTS",
                    userMessage: "Document does not exist",
                    operation: "LISTEN_DOCUMENT"
                )
                subject?.send(completion: .failure(serviceError))
            }
        }
        
        // Listener'ı sakla
        listeners[id] = listener
        
        return subject
            .handleEvents(receiveCancel: { [weak self] in
                // Cancel edildiğinde listener'ı temizle
                self?.listeners[id]?.remove()
                self?.listeners.removeValue(forKey: id)
            })
            .eraseToAnyPublisher()
    }
    
    
    func listen(where field: String, isEqualTo value: Any) -> AnyPublisher<[T], ServiceError> {
        return PassthroughSubject<[T], ServiceError>()
            .handleEvents(receiveSubscription: { [weak self] subscription in
                guard let self = self else { return }
                
                let listener = self.db.collection(self.collectionName)
                    .whereField(field, isEqualTo: value)
                    .addSnapshotListener { snapshot, error in
                        let subject = subscription as? PassthroughSubject<[T], ServiceError>
                        
                        if let error = error {
                            let serviceError = self.handleError(error, operation: "LISTEN_WHERE")
                            subject?.send(completion: .failure(serviceError))
                            return
                        }
                        
                        guard let documents = snapshot?.documents else {
                            subject?.send([])
                            return
                        }
                        
                        do {
                            let models = try documents.compactMap { document -> T? in
                                try document.data(as: T.self)
                            }
                            subject?.send(models)
                        } catch {
                            let serviceError = ServiceErrorFactory.serializationFailed(
                                for: FirebaseManager<T>.self,
                                operation: "LISTEN_WHERE",
                                underlyingError: error
                            )
                            self.logError(serviceError)
                            subject?.send(completion: .failure(serviceError))
                        }
                    }
                
                // Store listener for cleanup if needed
            })
            .eraseToAnyPublisher()
    }
    
    func listen(where field: String, isEqualTo value: Any, limit: Int) -> AnyPublisher<[T], ServiceError> {
        return PassthroughSubject<[T], ServiceError>()
            .handleEvents(receiveSubscription: { [weak self] subscription in
                guard let self = self else { return }
                
                self.db.collection(self.collectionName)
                    .whereField(field, isEqualTo: value)
                    .limit(to: limit)
                    .addSnapshotListener { snapshot, error in
                        let subject = subscription as? PassthroughSubject<[T], ServiceError>
                        
                        if let error = error {
                            let serviceError = self.handleError(error, operation: "LISTEN_WHERE_LIMIT")
                            subject?.send(completion: .failure(serviceError))
                            return
                        }
                        
                        guard let documents = snapshot?.documents else {
                            subject?.send([])
                            return
                        }
                        
                        do {
                            let models = try documents.compactMap { document -> T? in
                                try document.data(as: T.self)
                            }
                            subject?.send(models)
                        } catch {
                            let serviceError = ServiceErrorFactory.serializationFailed(
                                for: FirebaseManager<T>.self,
                                operation: "LISTEN_WHERE_LIMIT",
                                underlyingError: error
                            )
                            self.logError(serviceError)
                            subject?.send(completion: .failure(serviceError))
                        }
                    }
                
                // Store listener for cleanup if needed
            })
            .eraseToAnyPublisher()
    }
    
    private func handleError(_ error: Error, operation: String) -> ServiceError {
        // Error handling implementation
        return ServiceError(serviceType: FirebaseManager<T>.self, code: "FIREBASE_ERROR", userMessage: error.localizedDescription, operation: operation)
    }
    
    private func logError(_ error: ServiceError) {
        Logger.log("ERROR: \(error)")
    }
    
    // Cleanup helper
    private func cleanupListener(for key: String) {
        listeners[key]?.remove()
        listeners.removeValue(forKey: key)
        subjects.removeValue(forKey: key)
        Logger.log("🧹 CLEANUP: Removed listener for \(key)")
    }
    
    // Tüm listener'ları durdur
    func stopAllListeners() {
        Logger.log("🛑 STOPPING ALL LISTENERS: \(listeners.count) listeners")
        
        listeners.forEach { key, listener in
            listener.remove()
            Logger.log("🛑 STOPPED: \(key)")
        }
        
        listeners.removeAll()
        subjects.removeAll()
    }
    
    // Belirli bir listener'ı durdur
    func stopListener(for key: String) {
        if let listener = listeners[key] {
            listener.remove()
            listeners.removeValue(forKey: key)
            subjects.removeValue(forKey: key)
            Logger.log("🛑 STOPPED SPECIFIC LISTENER: \(key)")
        } else {
            Logger.log("⚠️ LISTENER NOT FOUND: \(key)")
        }
    }
    
    // Aktif listener'ları listele
    func getActiveListeners() -> [String] {
        let activeKeys = Array(listeners.keys)
        Logger.log("📋 ACTIVE LISTENERS: \(activeKeys)")
        return activeKeys
    }
    
    // Deinit'te cleanup
    deinit {
        stopAllListeners()
        Logger.log("💀 DEINIT: FirebaseManager cleaned up")
    }
    
}
