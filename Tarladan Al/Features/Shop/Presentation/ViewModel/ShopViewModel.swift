//
//  ShopViewModel.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/7/25.
//
import Foundation
import Combine

class ShopViewModel: ObservableObject {
    
    @Published var showScan = false
    @Published var showCart = false
    @Published var isLoading = false
    @Published var showFilters = false
    @Published var errorMessage: String?
    
    @Published var viewMode: ViewMode = .grid
    @Published var sortOption: SortOption = .popularity
    
    @Published var searchText = ""
    
    @Published var quickActions: [QuickAction] = []
    @Published var categories: [ProductCategory] = []
    @Published var selectedCategory: ProductCategory?
    
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    
    @Published var featuredTitle = "🌱 Yaz Sezonu Özel"
    @Published var featuredDescription = "Taze yaz sebzeleri ve meyvelerinde %30'a varan indirimler"
    @Published var showFeaturedBanner = true
    
    private var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    func setUser(_ user: User?) {
        self.currentUser = user
    }
    
    @Injected private var addToFavoritesUseCase: AddToFavoritesUseCaseProtocol
    @Injected private var listenProductsUseCase : ListenProductsUseCaseProtocol
    
    init() {
        self.loadProducts()
        self.quickActions = setupQuickActions()
        self.categories =  setupCategories()
    }
    
    var sortOptions: [SortOption] {
        SortOption.allCases
    }
    
    func toggleCart() {
        showCart.toggle()
    }
    
    func loadProducts() {
        listenProductsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log("✅ VIEW MODEL: Completed successfully")
                    case .failure(let error):
                        Logger.log("❌ VIEW MODEL: Error: \(error)")
                    }
                },
                receiveValue: { [weak self] products in
                    self?.products = products
                }
            )
            .store(in: &cancellables)
    }
    
    func filteredProducts(category: ProductCategory?, searchText: String) -> [Product] {
        var filtered = products
        
        // Kategori filtresi
        if let category = category {
            filtered = filtered.filter { $0.categoryName == category.name }
        }
        
        // Arama filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.farmerName.localizedCaseInsensitiveContains(searchText) ||
                product.locationName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return Array(filtered.prefix(10))
    }
    
    // Kategorilere göre ürün sayısı
    func productCount(for category: ProductCategory) -> Int {
        products.filter { $0.categoryName == category.name }.count
    }
    
    private func handleQuickAction(_ action: QuickActionType) {
        // Implement quick action logic
        switch action {
        case .popularity:
            // Navigate to popular products
            break
        case .discount:
            // Navigate to discounted products
            break
        case .newProducts:
            // Navigate to new products
            break
        case .fastDelivery:
            // Navigate to fast delivery products
            break
        }
    }
    
    func setViewMode(_ mode: ViewMode) {
        viewMode = mode
    }
    
    func addToFavorites(for productId: String){
        guard let currentUser = currentUser,
              let id = currentUser.id else {
            return
        }
        addToFavoritesUseCase.execute(id: id, productId: productId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        Logger.log("✅ VIEW MODEL: Completed successfully")
                    case .failure(let error):
                        Logger.log("❌ VIEW MODEL: Error: \(error)")
                    }
                },
                receiveValue: { _ in
                }
            )
            .store(in: &cancellables)
    }
}

extension ShopViewModel{
    
    static let shared = ShopViewModel()
    
    func getCategory(by id: String) -> ProductCategory? {
        return categories.first { category in
            category.subCategories.contains { $0.id.uuidString == id }
        }
    }
    
    func getSubCategory(by name: String) -> ProductSubCategory? {
        for category in categories {
            if let subCategory = category.subCategories.first(where: { $0.name == name }) {
                return subCategory
            }
        }
        return nil
    }
    
    
    func getCategoryAndSubCategory(by subCategoryId: String) -> (category: ProductCategory, subCategory: ProductSubCategory)? {
        for category in categories {
            if let subCategory = category.subCategories.first(where: { $0.id.uuidString == subCategoryId }) {
                return (category, subCategory)
            }
        }
        return nil
    }
    
    private func setupQuickActions() -> [QuickAction] {
        return [
            QuickAction(
                icon: "star.fill",
                title: "En Popüler",
                subtitle: "150+ ürün",
                color: .yellow
            ) { [weak self] in
                self?.handleQuickAction(.popularity)
            },
            QuickAction(
                icon: "tag.fill",
                title: "İndirimli",
                subtitle: "45 ürün",
                color: .red
            ) { [weak self] in
                self?.handleQuickAction(.discount)
            },
            QuickAction(
                icon: "leaf.fill",
                title: "Yeni Ürünler",
                subtitle: "28 ürün",
                color: .green
            ) { [weak self] in
                self?.handleQuickAction(.newProducts)
            },
            QuickAction(
                icon: "clock.fill",
                title: "Hızlı Teslimat",
                subtitle: "2 saat içinde",
                color: .blue
            ) { [weak self] in
                self?.handleQuickAction(.fastDelivery)
            }
        ]
    }
    
    func setupCategories() -> [ProductCategory] {
        return [
            ProductCategory(
                name: "Meyveler",
                icon: "🍎",
                colorHex: "#FF6B6B",
                subCategories: [
                    ProductSubCategory(
                        name: "Elma",
                        icon: "🍎",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [9, 10, 11],
                        storageType: .refrigerated,
                        shelfLife: 60,
                        variants: ["Amasya", "Granny Smith", "Golden", "Starking", "Gala"],
                        keywords: ["elma", "apple", "kırmızı elma", "yeşil elma"]
                    ),
                    ProductSubCategory(
                        name: "Armut",
                        icon: "🍐",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [8, 9, 10],
                        storageType: .refrigerated,
                        shelfLife: 45,
                        variants: ["Ankara", "Williams", "Deveci", "Santa Maria"],
                        keywords: ["armut", "pear"]
                    ),
                    ProductSubCategory(
                        name: "Üzüm",
                        icon: "🍇",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .box, .basket],
                        seasonalityMonths: [8, 9, 10],
                        storageType: .refrigerated,
                        shelfLife: 14,
                        variants: ["Sultani", "Cardinal", "Alphonse", "Razakı"],
                        keywords: ["üzüm", "grape", "asma"]
                    ),
                    ProductSubCategory(
                        name: "Portakal",
                        icon: "🍊",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [11, 12, 1, 2, 3],
                        storageType: .roomTemperature,
                        shelfLife: 21,
                        variants: ["Valencia", "Jaffa", "Washington Navel"],
                        keywords: ["portakal", "orange", "turuncu"]
                    ),
                    ProductSubCategory(
                        name: "Limon",
                        icon: "🍋",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box],
                        seasonalityMonths: [10, 11, 12, 1, 2, 3, 4],
                        storageType: .roomTemperature,
                        shelfLife: 30,
                        variants: ["Enterdonat", "Lamas", "Meyer"],
                        keywords: ["limon", "lemon", "sarı"]
                    ),
                    ProductSubCategory(
                        name: "Muz",
                        icon: "🍌",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .bunch],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .roomTemperature,
                        shelfLife: 7,
                        variants: ["Cavendish", "Grand Nain"],
                        keywords: ["muz", "banana"]
                    ),
                    ProductSubCategory(
                        name: "Çilek",
                        icon: "🍓",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.basket, .package],
                        seasonalityMonths: [4, 5, 6],
                        storageType: .refrigerated,
                        shelfLife: 5,
                        variants: ["Festival", "Albion", "Camarosa"],
                        keywords: ["çilek", "strawberry"]
                    ),
                    ProductSubCategory(
                        name: "Şeftali",
                        icon: "🍑",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [6, 7, 8],
                        storageType: .refrigerated,
                        shelfLife: 10,
                        variants: ["J.H. Hale", "Elberta", "Redhaven"],
                        keywords: ["şeftali", "peach"]
                    ),
                    ProductSubCategory(
                        name: "Kayısı",
                        icon: "🧡",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [6, 7],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Hacıhaliloğlu", "Şalak", "Kabaaşı"],
                        keywords: ["kayısı", "apricot"]
                    ),
                    ProductSubCategory(
                        name: "Kiraz",
                        icon: "🍒",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.basket, .box],
                        seasonalityMonths: [5, 6, 7],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Napoleon", "Van", "Ziraat 0900"],
                        keywords: ["kiraz", "cherry"]
                    )
                ],
                description: "Taze meyveler ve meyve ürünleri"
            ),
            
            // SEBZE KATEGORİSİ
            ProductCategory(
                name: "Sebzeler",
                icon: "🥕",
                colorHex: "#4ECDC4",
                subCategories: [
                    ProductSubCategory(
                        name: "Domates",
                        icon: "🍅",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box, .basket],
                        seasonalityMonths: [5, 6, 7, 8, 9],
                        storageType: .roomTemperature,
                        shelfLife: 10,
                        variants: ["Beef", "Cherry", "San Marzano", "Roma"],
                        keywords: ["domates", "tomato", "kırmızı"]
                    ),
                    ProductSubCategory(
                        name: "Salatalık",
                        icon: "🥒",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .box],
                        seasonalityMonths: [5, 6, 7, 8, 9],
                        storageType: .refrigerated,
                        shelfLife: 14,
                        variants: ["Sera", "Açık Alan", "Kornişon"],
                        keywords: ["salatalık", "cucumber", "hıyar"]
                    ),
                    ProductSubCategory(
                        name: "Biber",
                        icon: "🌶️",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece],
                        seasonalityMonths: [6, 7, 8, 9],
                        storageType: .refrigerated,
                        shelfLife: 10,
                        variants: ["Tatlı Biber", "Acı Biber", "Kapya", "Charleston"],
                        keywords: ["biber", "pepper", "acı", "tatlı"]
                    ),
                    ProductSubCategory(
                        name: "Soğan",
                        icon: "🧅",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .bag],
                        seasonalityMonths: [7, 8, 9],
                        storageType: .dryPlace,
                        shelfLife: 120,
                        variants: ["Kırmızı", "Beyaz", "Yalova"],
                        keywords: ["soğan", "onion"]
                    ),
                    ProductSubCategory(
                        name: "Patates",
                        icon: "🥔",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag],
                        seasonalityMonths: [8, 9, 10],
                        storageType: .dryPlace,
                        shelfLife: 90,
                        variants: ["Agria", "Granola", "Marabel"],
                        keywords: ["patates", "potato"]
                    ),
                    ProductSubCategory(
                        name: "Havuç",
                        icon: "🥕",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .bag],
                        seasonalityMonths: [9, 10, 11],
                        storageType: .refrigerated,
                        shelfLife: 30,
                        variants: ["Nantes", "Chantenay", "Baby Havuç"],
                        keywords: ["havuç", "carrot", "turp"]
                    ),
                    ProductSubCategory(
                        name: "Marul",
                        icon: "🥬",
                        defaultUnit: .piece,
                        alternativeUnits: [.kilogram, .bunch],
                        seasonalityMonths: [4, 5, 9, 10, 11],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Kıvırcık", "Iceberg", "Romen"],
                        keywords: ["marul", "lettuce", "salata"]
                    ),
                    ProductSubCategory(
                        name: "Ispanak",
                        icon: "🥬",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [10, 11, 12, 1, 2, 3, 4],
                        storageType: .refrigerated,
                        shelfLife: 5,
                        variants: ["Kış", "Yaz"],
                        keywords: ["ıspanak", "spinach"]
                    ),
                    ProductSubCategory(
                        name: "Kabak",
                        icon: "🥒",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece],
                        seasonalityMonths: [6, 7, 8, 9],
                        storageType: .roomTemperature,
                        shelfLife: 14,
                        variants: ["Sakız", "Bal", "Acorn"],
                        keywords: ["kabak", "zucchini", "squash"]
                    ),
                    ProductSubCategory(
                        name: "Patlıcan",
                        icon: "🍆",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece],
                        seasonalityMonths: [6, 7, 8, 9],
                        storageType: .roomTemperature,
                        shelfLife: 7,
                        variants: ["Kemer", "Bostan", "Japonya"],
                        keywords: ["patlıcan", "eggplant", "aubergine"]
                    )
                ],
                description: "Taze sebzeler ve yapraklı yeşillikler"
            ),
            
            // TAHILİLER KATEGORİSİ
            ProductCategory(
                name: "Tahıllar & Baklagiller",
                icon: "🌾",
                colorHex: "#F7DC6F",
                subCategories: [
                    ProductSubCategory(
                        name: "Buğday",
                        icon: "🌾",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag, .ton],
                        seasonalityMonths: [7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Ekmeklik", "Makarnalık", "Durum"],
                        keywords: ["buğday", "wheat", "tahıl"]
                    ),
                    ProductSubCategory(
                        name: "Arpa",
                        icon: "🌾",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag, .ton],
                        seasonalityMonths: [6, 7],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Yem", "Malt", "İnsan"],
                        keywords: ["arpa", "barley"]
                    ),
                    ProductSubCategory(
                        name: "Mısır",
                        icon: "🌽",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .bag, .ton],
                        seasonalityMonths: [8, 9, 10],
                        storageType: .dryPlace,
                        shelfLife: 300,
                        variants: ["At Dişi", "Şeker Mısırı", "Pop Corn"],
                        keywords: ["mısır", "corn", "koçan"]
                    ),
                    ProductSubCategory(
                        name: "Pirinç",
                        icon: "🍚",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag],
                        seasonalityMonths: [9, 10],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Baldo", "Osmancık", "Kırmızı"],
                        keywords: ["pirinç", "rice", "çeltik"]
                    ),
                    ProductSubCategory(
                        name: "Nohut",
                        icon: "🟡",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag],
                        seasonalityMonths: [7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["İri", "Orta", "Ufak"],
                        keywords: ["nohut", "chickpea", "garbanzo"]
                    ),
                    ProductSubCategory(
                        name: "Mercimek",
                        icon: "🔴",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag],
                        seasonalityMonths: [7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kırmızı", "Yeşil", "Siyah"],
                        keywords: ["mercimek", "lentil"]
                    ),
                    ProductSubCategory(
                        name: "Fasulye",
                        icon: "⚪",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag],
                        seasonalityMonths: [8, 9],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Dermason", "Horoz", "Barbunya"],
                        keywords: ["fasulye", "bean", "börülce"]
                    )
                ],
                description: "Tahıllar, baklagiller ve hububat ürünleri"
            ),
            
            // SÜT ÜRÜNLERİ KATEGORİSİ
            ProductCategory(
                name: "Süt Ürünleri",
                icon: "🥛",
                colorHex: "#AED6F1",
                subCategories: [
                    ProductSubCategory(
                        name: "İnek Sütü",
                        icon: "🥛",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 3,
                        variants: ["Tam Yağlı", "Yarım Yağlı", "Yağsız"],
                        keywords: ["süt", "milk", "inek"]
                    ),
                    ProductSubCategory(
                        name: "Keçi Sütü",
                        icon: "🐐",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 3,
                        variants: ["Çiğ", "Pastörize"],
                        keywords: ["keçi sütü", "goat milk"]
                    ),
                    ProductSubCategory(
                        name: "Yoğurt",
                        icon: "🥛",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Süzme", "Krem", "Meyveli"],
                        keywords: ["yoğurt", "yogurt"]
                    ),
                    ProductSubCategory(
                        name: "Peynir",
                        icon: "🧀",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 30,
                        variants: ["Beyaz", "Kaşar", "Tulum", "Lor"],
                        keywords: ["peynir", "cheese"]
                    ),
                    ProductSubCategory(
                        name: "Tereyağı",
                        icon: "🧈",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 45,
                        variants: ["Tuzsuz", "Tuzlu", "Çiftlik"],
                        keywords: ["tereyağı", "butter"]
                    ),
                    ProductSubCategory(
                        name: "Kaymak",
                        icon: "🍯",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 10,
                        variants: ["Köy", "Fabrika"],
                        keywords: ["kaymak", "cream", "krema"]
                    ),
                    ProductSubCategory(
                        name: "Yumurta",
                        icon: "🥚",
                        defaultUnit: .piece,
                        alternativeUnits: [.dozen, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 28,
                        variants: ["Tavuk", "Köy", "Organik"],
                        keywords: ["yumurta", "egg"]
                    )
                ],
                description: "Süt ve süt ürünleri, yumurta"
            ),
            
            // ET VE SU ÜRÜNLERİ KATEGORİSİ
            ProductCategory(
                name: "Et & Su Ürünleri",
                icon: "🍖",
                colorHex: "#E8B4CB",
                subCategories: [
                    ProductSubCategory(
                        name: "Dana Eti",
                        icon: "🥩",
                        defaultUnit: .kilogram,
                        alternativeUnits: [],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .frozen,
                        shelfLife: 180,
                        variants: ["Kuşbaşı", "Kıyma", "Biftek", "But"],
                        keywords: ["dana", "beef", "et"]
                    ),
                    ProductSubCategory(
                        name: "Kuzu Eti",
                        icon: "🍖",
                        defaultUnit: .kilogram,
                        alternativeUnits: [],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .frozen,
                        shelfLife: 180,
                        variants: ["Kuşbaşı", "Kıyma", "Pirzola", "But"],
                        keywords: ["kuzu", "lamb", "et"]
                    ),
                    ProductSubCategory(
                        name: "Tavuk Eti",
                        icon: "🍗",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .frozen,
                        shelfLife: 90,
                        variants: ["Bütün", "Parça", "Göğüs", "But"],
                        keywords: ["tavuk", "chicken", "piliç"]
                    ),
                    ProductSubCategory(
                        name: "Balık",
                        icon: "🐟",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.piece],
                        seasonalityMonths: [10, 11, 12, 1, 2, 3],
                        storageType: .frozen,
                        shelfLife: 90,
                        variants: ["Çipura", "Levrek", "Hamsi", "Alabalık"],
                        keywords: ["balık", "fish"]
                    )
                ],
                description: "Taze et ve su ürünleri"
            ),
            
            // BAL VE ARICILIK ÜRÜNLERİ KATEGORİSİ
            ProductCategory(
                name: "Bal & Arıcılık",
                icon: "🍯",
                colorHex: "#F4D03F",
                subCategories: [
                    ProductSubCategory(
                        name: "Çiçek Balı",
                        icon: "🍯",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .bottle],
                        seasonalityMonths: [5, 6, 7, 8],
                        storageType: .roomTemperature,
                        shelfLife: 730,
                        variants: ["Akasya", "Kestane", "Çam", "Lavanta"],
                        keywords: ["bal", "honey", "çiçek"]
                    ),
                    ProductSubCategory(
                        name: "Polen",
                        icon: "🌼",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .package],
                        seasonalityMonths: [4, 5, 6],
                        storageType: .refrigerated,
                        shelfLife: 365,
                        variants: ["Ham", "Kurutulmuş"],
                        keywords: ["polen", "pollen", "arı"]
                    ),
                    ProductSubCategory(
                        name: "Arı Sütü",
                        icon: "🥛",
                        defaultUnit: .gram,
                        alternativeUnits: [.jar],
                        seasonalityMonths: [5, 6, 7],
                        storageType: .frozen,
                        shelfLife: 365,
                        variants: ["Taze", "Dondurulmuş"],
                        keywords: ["arı sütü", "royal jelly"]
                    ),
                    ProductSubCategory(
                        name: "Propolis",
                        icon: "🍯",
                        defaultUnit: .gram,
                        alternativeUnits: [.bottle, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .roomTemperature,
                        shelfLife: 1095,
                        variants: ["Ham", "Ekstrakt", "Kapsül"],
                        keywords: ["propolis", "arı tutkalı"]
                    )
                ],
                description: "Bal ve arıcılık ürünleri"
            ),
            
            // BAHARATLAR VE ÇEŞNİLER KATEGORİSİ
            ProductCategory(
                name: "Baharat & Çeşniler",
                icon: "🌶️",
                colorHex: "#DC7633",
                subCategories: [
                    ProductSubCategory(
                        name: "Kırmızı Biber",
                        icon: "🌶️",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [9, 10],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Toz", "Pul", "İsot"],
                        keywords: ["kırmızı biber", "paprika", "baharat"]
                    ),
                    ProductSubCategory(
                        name: "Sumak",
                        icon: "🔴",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [8, 9],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Toz", "Kırma"],
                        keywords: ["sumak", "sumac"]
                    ),
                    ProductSubCategory(
                        name: "Kekik",
                        icon: "🌿",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [6, 7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş", "Taze"],
                        keywords: ["kekik", "thyme", "oregano"]
                    ),
                    ProductSubCategory(
                        name: "Nane",
                        icon: "🌿",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [5, 6, 7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş", "Taze"],
                        keywords: ["nane", "mint"]
                    )
                ],
                description: "Baharatlar, otlar ve çeşniler"
            ),
            
            // KURU MEYVE VE KURUYEMIŞ KATEGORİSİ
            ProductCategory(
                name: "Kuru Meyve & Kuruyemiş",
                icon: "🥜",
                colorHex: "#8E44AD",
                subCategories: [
                    ProductSubCategory(
                        name: "Ceviz",
                        icon: "🥜",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag, .package],
                        seasonalityMonths: [10, 11],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["İç", "Kabuklu", "Parça"],
                        keywords: ["ceviz", "walnut"]
                    ),
                    ProductSubCategory(
                        name: "Fındık",
                        icon: "🌰",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag, .package],
                        seasonalityMonths: [8, 9],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["İç", "Kabuklu", "Kavrulmuş"],
                        keywords: ["fındık", "hazelnut"]
                    ),
                    ProductSubCategory(
                        name: "Badem",
                        icon: "🥜",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bag, .package],
                        seasonalityMonths: [8, 9],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["İç", "Kabuklu", "Dilimli"],
                        keywords: ["badem", "almond"]
                    ),
                    ProductSubCategory(
                        name: "Antep Fıstığı",
                        icon: "🥜",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [9, 10],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["İç", "Kabuklu", "Tuzlu"],
                        keywords: ["antep fıstığı", "pistachio"]
                    ),
                    ProductSubCategory(
                        name: "Kuru Kayısı",
                        icon: "🧡",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Çekirdekli", "Çekirdeksiz", "Organik"],
                        keywords: ["kuru kayısı", "dried apricot"]
                    ),
                    ProductSubCategory(
                        name: "Kuru İncir",
                        icon: "🟤",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [8, 9],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Sarılop", "Bursa Siyahı"],
                        keywords: ["kuru incir", "dried fig"]
                    ),
                    ProductSubCategory(
                        name: "Kuru Üzüm",
                        icon: "🍇",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [9, 10],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Sultani", "Çekirdekli", "Çekirdeksiz"],
                        keywords: ["kuru üzüm", "raisin", "üzüm"]
                    )
                ],
                description: "Kuru meyveler ve kuruyemişler"
            ),
            
            // ZEYTİN VE ZEYTİNYAĞI KATEGORİSİ
            ProductCategory(
                name: "Zeytin & Zeytinyağı",
                icon: "🫒",
                colorHex: "#27AE60",
                subCategories: [
                    ProductSubCategory(
                        name: "Siyah Zeytin",
                        icon: "⚫",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .package],
                        seasonalityMonths: [11, 12, 1],
                        storageType: .roomTemperature,
                        shelfLife: 180,
                        variants: ["Gemlik", "Ayvalık", "Edremit"],
                        keywords: ["siyah zeytin", "black olive"]
                    ),
                    ProductSubCategory(
                        name: "Yeşil Zeytin",
                        icon: "🫒",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar, .package],
                        seasonalityMonths: [9, 10, 11],
                        storageType: .roomTemperature,
                        shelfLife: 180,
                        variants: ["Kırma", "Bütün", "Dolma"],
                        keywords: ["yeşil zeytin", "green olive"]
                    ),
                    ProductSubCategory(
                        name: "Zeytinyağı",
                        icon: "🛢️",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [11, 12, 1],
                        storageType: .roomTemperature,
                        shelfLife: 730,
                        variants: ["Soğuk Sıkım", "Birinci", "Riviera"],
                        keywords: ["zeytinyağı", "olive oil", "yağ"]
                    ),
                    ProductSubCategory(
                        name: "Zeytin Ezmesi",
                        icon: "🫒",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.jar],
                        seasonalityMonths: [11, 12, 1],
                        storageType: .refrigerated,
                        shelfLife: 90,
                        variants: ["Siyah", "Yeşil", "Karışık"],
                        keywords: ["zeytin ezmesi", "olive paste", "tapenade"]
                    )
                ],
                description: "Zeytin ve zeytinyağı ürünleri"
            ),
            
            // ŞARAPCILIK VE İÇECEKLER KATEGORİSİ
            ProductCategory(
                name: "İçecekler & Şıra",
                icon: "🧃",
                colorHex: "#9B59B6",
                subCategories: [
                    ProductSubCategory(
                        name: "Elma Şırası",
                        icon: "🧃",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [9, 10, 11],
                        storageType: .refrigerated,
                        shelfLife: 30,
                        variants: ["Doğal", "Şekersiz", "Organik"],
                        keywords: ["elma şırası", "apple juice"]
                    ),
                    ProductSubCategory(
                        name: "Üzüm Şırası",
                        icon: "🍇",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [8, 9, 10],
                        storageType: .refrigerated,
                        shelfLife: 30,
                        variants: ["Kırmızı", "Beyaz", "Pembe"],
                        keywords: ["üzüm şırası", "grape juice"]
                    ),
                    ProductSubCategory(
                        name: "Nar Ekşisi",
                        icon: "🍷",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [10, 11],
                        storageType: .roomTemperature,
                        shelfLife: 365,
                        variants: ["Konsantre", "Doğal"],
                        keywords: ["nar ekşisi", "pomegranate molasses"]
                    ),
                    ProductSubCategory(
                        name: "Şalgam Suyu",
                        icon: "🥤",
                        defaultUnit: .liter,
                        alternativeUnits: [.bottle],
                        seasonalityMonths: [10, 11, 12, 1, 2],
                        storageType: .refrigerated,
                        shelfLife: 60,
                        variants: ["Acı", "Acısız", "Turp"],
                        keywords: ["şalgam", "turnip juice"]
                    )
                ],
                description: "Doğal meyve suları ve geleneksel içecekler"
            ),
            
            // MANTAR KATEGORİSİ
            ProductCategory(
                name: "Mantarlar",
                icon: "🍄",
                colorHex: "#795548",
                subCategories: [
                    ProductSubCategory(
                        name: "Kültür Mantarı",
                        icon: "🍄‍🟫",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Beyaz", "Kahverengi"],
                        keywords: ["mantar", "mushroom", "kültür"]
                    ),
                    ProductSubCategory(
                        name: "İstiridye Mantarı",
                        icon: "🍄",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 5,
                        variants: ["Beyaz", "Sarı", "Pembe"],
                        keywords: ["istiridye mantarı", "oyster mushroom"]
                    ),
                    ProductSubCategory(
                        name: "Shiitake Mantarı",
                        icon: "🍄‍🟫",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .refrigerated,
                        shelfLife: 10,
                        variants: ["Taze", "Kurutulmuş"],
                        keywords: ["shiitake", "japanese mushroom"]
                    ),
                    ProductSubCategory(
                        name: "Yabani Mantar",
                        icon: "🍄",
                        defaultUnit: .kilogram,
                        alternativeUnits: [],
                        seasonalityMonths: [4, 5, 10, 11],
                        storageType: .refrigerated,
                        shelfLife: 3,
                        variants: ["Çam", "Meşe", "Karışık"],
                        keywords: ["yabani mantar", "wild mushroom"]
                    )
                ],
                description: "Taze ve kurutulmuş mantarlar"
            ),
            
            // ÇİÇEK VE SÜS BİTKİLERİ KATEGORİSİ
            ProductCategory(
                name: "Çiçek & Süs Bitkileri",
                icon: "🌸",
                colorHex: "#E91E63",
                subCategories: [
                    ProductSubCategory(
                        name: "Kesme Çiçek",
                        icon: "🌹",
                        defaultUnit: .piece,
                        alternativeUnits: [.bunch],
                        seasonalityMonths: [3, 4, 5, 6, 7, 8, 9, 10],
                        storageType: .refrigerated,
                        shelfLife: 7,
                        variants: ["Gül", "Karanfil", "Lale", "Papatya"],
                        keywords: ["çiçek", "flower", "gül", "kesme"]
                    ),
                    ProductSubCategory(
                        name: "Saksı Çiçeği",
                        icon: "🌺",
                        defaultUnit: .piece,
                        alternativeUnits: [],
                        seasonalityMonths: [3, 4, 5, 6, 7, 8, 9],
                        storageType: .roomTemperature,
                        shelfLife: 30,
                        variants: ["Begonva", "Petunya", "Ateş Çiçeği"],
                        keywords: ["saksı", "pot", "çiçek"]
                    ),
                    ProductSubCategory(
                        name: "Süs Bitkisi",
                        icon: "🌿",
                        defaultUnit: .piece,
                        alternativeUnits: [],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .roomTemperature,
                        shelfLife: 365,
                        variants: ["Ficus", "Pothos", "Kauçuk Ağacı"],
                        keywords: ["süs bitkisi", "houseplant", "dekoratif"]
                    ),
                    ProductSubCategory(
                        name: "Çiçek Soğanı",
                        icon: "🧅",
                        defaultUnit: .piece,
                        alternativeUnits: [.package],
                        seasonalityMonths: [9, 10, 11],
                        storageType: .dryPlace,
                        shelfLife: 180,
                        variants: ["Lale", "Sümbül", "Nergis"],
                        keywords: ["soğan", "bulb", "çiçek"]
                    )
                ],
                description: "Çiçekler ve süs bitkileri"
            ),
            
            // TIBBİ VE AROMATİK BİTKİLER KATEGORİSİ
            ProductCategory(
                name: "Tıbbi & Aromatik Bitkiler",
                icon: "🌿",
                colorHex: "#4CAF50",
                subCategories: [
                    ProductSubCategory(
                        name: "Lavanta",
                        icon: "💜",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [6, 7],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş", "Taze", "Yağı"],
                        keywords: ["lavanta", "lavender"]
                    ),
                    ProductSubCategory(
                        name: "Biberiye",
                        icon: "🌿",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş", "Taze"],
                        keywords: ["biberiye", "rosemary"]
                    ),
                    ProductSubCategory(
                        name: "Adaçayı",
                        icon: "🌿",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.bunch, .package],
                        seasonalityMonths: [5, 6, 7, 8],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş", "Taze"],
                        keywords: ["adaçayı", "sage"]
                    ),
                    ProductSubCategory(
                        name: "Papatya",
                        icon: "🌼",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [5, 6, 7],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Kurutulmuş Çiçek", "Yaprak"],
                        keywords: ["papatya", "chamomile"]
                    ),
                    ProductSubCategory(
                        name: "Ihlamur",
                        icon: "🌿",
                        defaultUnit: .kilogram,
                        alternativeUnits: [.package],
                        seasonalityMonths: [6, 7],
                        storageType: .dryPlace,
                        shelfLife: 365,
                        variants: ["Çiçek", "Yaprak"],
                        keywords: ["ıhlamur", "linden"]
                    )
                ],
                description: "Şifalı ve aromatik bitkiler"
            )
        ]
    }
    
}
