//
//  AppDIConfiguration.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//


class AppDIConfiguration {
    
    static let shared = AppDIConfiguration()
    
    
    static func configure() {
        let container = DIContainer.shared
        
        //MARK: - Data Sources (Singletons)
        container.register(AuthRemoteDataSourceProtocol.self,scope: .singleton) { _ in
            AuthRemoteDataSource(auth: .auth())
        }
        container.register(DeliveryRemoteDataSourceProtocol.self, scope: .singleton) { container in
            DeliveryRemoteDataSource(firestore: .firestore())
        }
        container.register(UserRemoteDataSourceProtocol.self, scope: .singleton) { container in
            UserRemoteDataSource(db: .firestore())
        }
        container.register(ProductRemoteDataSourceProtocol.self, scope: .singleton) { container in
            ProductRemoteDataSource(db: .firestore())
        }
        
        
        //MARK: - Repositories (Singletons)
        container.register(AuthRepositoryProtocol.self, scope: .singleton) { container in
            AuthRepository(
                remoteDataSource:  container.resolve(AuthRemoteDataSourceProtocol.self)
            )
        }
        container.register(DeliveryRepositoryProtocol.self, scope: .singleton) { container in
            DeliveryRepository(
                remoteDataSource:  container.resolve(DeliveryRemoteDataSourceProtocol.self)
            )
        }
        container.register(UserRepositoryProtocol.self, scope: .singleton) { container in
            UserRepository(
                userRemoteDataSource: container.resolve(UserRemoteDataSourceProtocol.self),
                productRemoteDataSource: container.resolve(ProductRemoteDataSourceProtocol.self)
            )
        }
        container.register(ProductRepositoryProtocol.self, scope: .singleton) { container in
            ProductRepository(
                remoteDataSource: container.resolve(ProductRemoteDataSourceProtocol.self)
            )
        }
        
        
        //MARK: - UseCases (Singletons)
        container.register(CheckUserUseCaseProtocol.self, scope: .singleton) { container in
            CheckUserUseCase(
                repository: container.resolve(AuthRepositoryProtocol.self)
            )
        }
        container.register(SignInUseCaseProtocol.self, scope: .singleton) { container in
            SignInUseCase(
                repository: container.resolve(AuthRepositoryProtocol.self)
            )
        }
        
        //MARK: - User Classes
        container.register(ListenUserUseCaseProtocol.self, scope: .singleton) { container in
            ListenUserUseCase(
                repository: container.resolve(UserRepositoryProtocol.self)
            )
        }
        container.register(CreateDeliveryUseCaseProtocol.self, scope: .singleton) { container in
            CreateDeliveryUseCase(
                repository: container.resolve(DeliveryRepositoryProtocol.self)
            )
        }
        container.register(UpdateDefaultAddressUseCaseProtocol.self, scope: .singleton) { container in
            UpdateDefaultAddressUseCase(
                repository: container.resolve(UserRepositoryProtocol.self)
            )
        }
        container.register(AddToFavoritesUseCaseProtocol.self, scope: .singleton) { container in
            AddToFavoritesUseCase(
                repository: container.resolve(UserRepositoryProtocol.self)
            )
        }
        
        
        //MARK: Delivery Classes
        container.register(ListenDeliveriesUseCaseProtocol.self, scope: .singleton) { container in
            ListenDeliveriesUseCase(
                repository: container.resolve(DeliveryRepositoryProtocol.self)
            )
        }
        container.register(CreateDeliveryUseCaseProtocol.self, scope: .singleton) { container in
            CreateDeliveryUseCase(
                repository: container.resolve(DeliveryRepositoryProtocol.self)
            )
        }
        container.register(UpdateDeliveryStatusUseCaseProtocol.self, scope: .singleton) { container in
            UpdateDeliveryStatusUseCase(
                repository: container.resolve(DeliveryRepositoryProtocol.self)
            )
        }
        
        //MARK: - Product Classes
        container.register(ListenProductsUseCaseProtocol.self, scope: .singleton) { container in
            ListenProductsUseCase(
                repository: container.resolve(ProductRepositoryProtocol.self)
            )
        }
    }
    
    
    
}
