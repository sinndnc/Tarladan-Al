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
        
        
        //MARK: - Auth Configuration
        container.register(AuthRemoteDataSourceProtocol.self,scope: .singleton) { _ in
            AuthRemoteDataSource(auth: .auth())
        }
        container.register(AuthRepositoryProtocol.self, scope: .singleton) { container in
            AuthRepository(
                remoteDataSource:  container.resolve(AuthRemoteDataSourceProtocol.self)
            )
        }
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
        
        
        //MARK: - User Configuration
        container.register(UserRemoteDataSourceProtocol.self, scope: .singleton) { container in
            UserRemoteDataSource(db: .firestore())
        }
        container.register(UserRepositoryProtocol.self, scope: .singleton) { container in
            UserRepository(
                userRemoteDataSource: container.resolve(UserRemoteDataSourceProtocol.self),
                productRemoteDataSource: container.resolve(ProductRemoteDataSourceProtocol.self)
            )
        }
        container.register(ListenUserUseCaseProtocol.self, scope: .singleton) { container in
            ListenUserUseCase(
                repository: container.resolve(UserRepositoryProtocol.self)
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
        
        
        //MARK: - Delivery Configuration
        container.register(DeliveryRemoteDataSourceProtocol.self, scope: .singleton) { container in
            DeliveryRemoteDataSource(firestore: .firestore())
        }
        container.register(DeliveryRepositoryProtocol.self, scope: .singleton) { container in
            DeliveryRepository(
                remoteDataSource:  container.resolve(DeliveryRemoteDataSourceProtocol.self)
            )
        }
        container.register(CreateDeliveryUseCaseProtocol.self, scope: .singleton) { container in
            CreateDeliveryUseCase(
                repository: container.resolve(DeliveryRepositoryProtocol.self)
            )
        }
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
        
        //MARK: - Recipe Configuration
        container.register(RecipeRemoteDataSourceProtocol.self, scope: .singleton) { container in
            RecipeRemoteDataSource(db: .firestore())
        }
        container.register(RecipeRepositoryProtocol.self, scope: .singleton) { container in
            RecipeRepository(
                remoteDataSource: container.resolve(RecipeRemoteDataSourceProtocol.self)
            )
        }
        container.register(ListenRecipesUseCaseProtocol.self, scope: .singleton) { container in
            ListenRecipesUseCase(
                repository: container.resolve(RecipeRepositoryProtocol.self)
            )
        }
        
        
        //MARK: - Product Configuration
        container.register(ProductRemoteDataSourceProtocol.self, scope: .singleton) { container in
            ProductRemoteDataSource(db: .firestore())
        }
        container.register(ProductRepositoryProtocol.self, scope: .singleton) { container in
            ProductRepository(
                remoteDataSource: container.resolve(ProductRemoteDataSourceProtocol.self)
            )
        }
        container.register(ListenProductsUseCaseProtocol.self, scope: .singleton) { container in
            ListenProductsUseCase(
                repository: container.resolve(ProductRepositoryProtocol.self)
            )
        }
        
        
        //MARK: - Order Configuration
        container.register(OrderRemoteDataSourceProtocol.self, scope: .singleton) { container in
            OrderRemoteDataSource(db: .firestore())
        }
        container.register(OrderRepositoryProtocol.self, scope: .singleton) { container in
            OrderRepository(
                remoteDataSource: container.resolve(OrderRemoteDataSourceProtocol.self)
            )
        }
        container.register(CreateOrderUseCaseProtocol.self, scope: .singleton) { container in
            CreateOrderUseCase(
                repository: container.resolve(OrderRepositoryProtocol.self)
            )
        }
        container.register(ListenOrdersOfUserUseCaseProtocol.self, scope: .singleton) { container in
            ListenOrdersOfUserUseCase(
                repository: container.resolve(OrderRepositoryProtocol.self)
            )
        }
        
    }
    
}
