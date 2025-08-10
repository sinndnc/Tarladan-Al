//
//  DIContainer.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private var factories: [String: ServiceFactory] = [:]
    private var singletons: [String: Any] = [:]
    private var scopedInstances: [String: [String: Any]] = [:]
    
    private init() {}
    
    func register<T>(_ type: T.Type, 
                    scope: ServiceScope = .transient,
                    factory: @escaping (DIContainer) -> T) {
        let key = String(describing: type)
        factories[key] = ServiceFactory(scope: scope, factory: { container in
            return factory(container) as Any
        })
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        guard let serviceFactory = factories[key] else {
            fatalError("Service \(type) not registered")
        }
        
        switch serviceFactory.scope {
        case .singleton:
            if let instance = singletons[key] as? T {
                return instance
            }
            let newInstance = serviceFactory.factory(self) as! T
            singletons[key] = newInstance
            return newInstance
            
        case .transient:
            return serviceFactory.factory(self) as! T
            
        case .scoped(let scopeName):
            if scopedInstances[scopeName] == nil {
                scopedInstances[scopeName] = [:]
            }
            
            if let instance = scopedInstances[scopeName]?[key] as? T {
                return instance
            }
            
            let newInstance = serviceFactory.factory(self) as! T
            scopedInstances[scopeName]?[key] = newInstance
            return newInstance
        }
    }
    
    func clearScope(_ scopeName: String) {
        scopedInstances[scopeName] = nil
    }
}
