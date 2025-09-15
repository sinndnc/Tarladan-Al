//
//  RecipeMockData.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 9/16/25.
//
import Foundation

// MARK: - Recipe Mock Data Generator
class RecipeMockData {
    
    // MARK: - Firebase-Ready Mock Recipes
    static let mockRecipes: [Recipe] = [
        Recipe(
            title: "Klasik Pankek",
            description: "Kahvaltı sofranızın vazgeçilmezi! Yumuşacık ve lezzetli pankek tarifi.",
            imageName: "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400",
            prepTime: 10,
            cookTime: 15,
            servings: 4,
            difficulty: .easy,
            category: .breakfast,
            ingredients: [
                Ingredient(name: "un", amount: "2", unit: "su bardağı"),
                Ingredient(name: "şeker", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "kabartma tozu", amount: "2", unit: "tatlı kaşığı"),
                Ingredient(name: "tuz", amount: "1", unit: "çay kaşığı"),
                Ingredient(name: "süt", amount: "1.5", unit: "su bardağı"),
                Ingredient(name: "yumurta", amount: "2", unit: "adet"),
                Ingredient(name: "tereyağı (eritilmiş)", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "vanilya özütü", amount: "1", unit: "tatlı kaşığı")
            ],
            instructions: [
                "Kuru malzemeleri (un, şeker, kabartma tozu, tuz) büyük bir kasede karıştırın.",
                "Başka bir kasede süt, yumurta, eritilmiş tereyağı ve vanilya özütünü çırpın.",
                "Yaş karışımı kuru malzemelerin üzerine dökün ve pürüzsüz bir hamur elde edene kadar karıştırın.",
                "Tavayı orta ateşte ısıtın ve az miktarda yağ sürün.",
                "Her pankek için 1/4 su bardağı hamur kullanarak tavaya dökün.",
                "Kenarları pişene ve yüzeyinde kabarcıklar oluşana kadar bekleyin (yaklaşık 2-3 dakika).",
                "Pankekleri çevirin ve diğer tarafını da 1-2 dakika pişirin.",
                "Sıcak servis yapın, üzerine bal, akçaağaç şurubu veya meyve ekleyebilirsiniz."
            ],
            nutritionInfo: NutritionInfo(
                calories: 285,
                protein: 12.8,
                carbs: 38.5,
                fat: 9.2,
                fiber: 1.8
            ),
            tags: ["Kolay", "Kahvaltı", "Tatlı", "Çocuk Dostu"]
        ),
        
        Recipe(
            title: "Mercimek Çorbası",
            description: "Geleneksel Türk mutfağının en sevilen çorbalarından biri. Besleyici ve doyurucu.",
            imageName: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400",
            prepTime: 15,
            cookTime: 30,
            servings: 6,
            difficulty: .easy,
            category: .soup,
            ingredients: [
                Ingredient(name: "kırmızı mercimek", amount: "1.5", unit: "su bardağı"),
                Ingredient(name: "soğan", amount: "1", unit: "orta boy"),
                Ingredient(name: "havuç", amount: "1", unit: "adet"),
                Ingredient(name: "patates", amount: "1", unit: "orta boy"),
                Ingredient(name: "tereyağı", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "un", amount: "1", unit: "yemek kaşığı"),
                Ingredient(name: "domates salçası", amount: "1", unit: "yemek kaşığı"),
                Ingredient(name: "tavuk suyu", amount: "6", unit: "su bardağı"),
                Ingredient(name: "tuz", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "karabiber", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "limon suyu", amount: "1", unit: "yemek kaşığı")
            ],
            instructions: [
                "Soğan, havuç ve patatesi küçük küçük doğrayın.",
                "Tereyağını derin bir tencerede eritin, soğanları pembeleşene kadar kavurun.",
                "Havuç ve patates ekleyip 5 dakika kavurun.",
                "Un ve domates salçasını ekleyip karıştırın.",
                "Yıkanmış mercimek ve tavuk suyunu ekleyin.",
                "Kaynadıktan sonra kısık ateşte 25 dakika pişirin.",
                "Blender ile pürüzleştirin veya tel çırpıcı ile ezin.",
                "Tuz, karabiber ve limon suyu ile tatlandırın.",
                "Sıcak servis yapın, üzerine tereyağı damlatabilirsiniz."
            ],
            nutritionInfo: NutritionInfo(
                calories: 195,
                protein: 11.2,
                carbs: 28.5,
                fat: 4.8,
                fiber: 6.2
            ),
            tags: ["Sağlıklı", "Vejeteryan", "Geleneksel", "Doyurucu"]
        ),
        
        Recipe(
            title: "Izgara Tavuk Salatası",
            description: "Protein deposu, renkli ve besleyici salata. Diyet yapanlar için ideal.",
            imageName: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400",
            prepTime: 20,
            cookTime: 15,
            servings: 2,
            difficulty: .medium,
            category: .salad,
            ingredients: [
                Ingredient(name: "tavuk göğsü", amount: "2", unit: "parça"),
                Ingredient(name: "marul", amount: "1", unit: "kafa"),
                Ingredient(name: "cherry domates", amount: "200", unit: "gram"),
                Ingredient(name: "salatalık", amount: "1", unit: "adet"),
                Ingredient(name: "avokado", amount: "1", unit: "adet"),
                Ingredient(name: "kırmızı soğan", amount: "1/2", unit: "adet"),
                Ingredient(name: "ceviz", amount: "1/4", unit: "su bardağı"),
                Ingredient(name: "beyaz peynir", amount: "100", unit: "gram"),
                Ingredient(name: "zeytinyağı", amount: "3", unit: "yemek kaşığı"),
                Ingredient(name: "limon suyu", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "tuz", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "karabiber", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "kekik", amount: "1", unit: "tatlı kaşığı")
            ],
            instructions: [
                "Tavuk göğsünü tuz, karabiber ve kekikle marine edin.",
                "Tavukları ızgarada veya tavada 6-8 dakika pişirin, dinlendirin.",
                "Marulu yıkayıp doğrayın, salatanın tabanına yerleştirin.",
                "Cherry domatesleri ikiye kesin, salatalığı dilimleyin.",
                "Avokadoyu soyup dilimleyin, kırmızı soğanı ince doğrayın.",
                "Tavukları dilimleyip salata üzerine yerleştirin.",
                "Tüm sebzeleri düzenleyin ve cevizleri serpin.",
                "Beyaz peyniri küçük parçalar halinde ekleyin.",
                "Zeytinyağı ve limon suyunu karıştırarak üzerine gezdirin.",
                "Tuz ve karabiber ile tatlandırıp servis yapın."
            ],
            nutritionInfo: NutritionInfo(
                calories: 385,
                protein: 32.8,
                carbs: 12.5,
                fat: 24.2,
                fiber: 8.5
            ),
            tags: ["Protein", "Sağlıklı", "Diyet", "Glutensiz"]
        ),
        
        Recipe(
            title: "Fırında Somon",
            description: "Omega-3 deposu somon balığı, fırında mükemmel baharatlarla pişirilmiş.",
            imageName: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400",
            prepTime: 15,
            cookTime: 20,
            servings: 4,
            difficulty: .medium,
            category: .dinner,
            ingredients: [
                Ingredient(name: "somon fileto", amount: "4", unit: "parça"),
                Ingredient(name: "limon", amount: "2", unit: "adet"),
                Ingredient(name: "zeytinyağı", amount: "3", unit: "yemek kaşığı"),
                Ingredient(name: "sarımsak", amount: "3", unit: "diş"),
                Ingredient(name: "taze dereotu", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "tuz", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "karabiber", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "paprika", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "asparagus", amount: "500", unit: "gram"),
                Ingredient(name: "cherry domates", amount: "200", unit: "gram")
            ],
            instructions: [
                "Fırını 200°C'ye ısıtın.",
                "Somon filetolarını yıkayıp kağıt havlu ile kurulayın.",
                "Zeytinyağı, ezilmiş sarımsak, limon suyu ve baharatları karıştırın.",
                "Bu karışımı somon üzerine sürün, 15 dakika marine edin.",
                "Asparagusları temizleyin, cherry domatesleri ikiye kesin.",
                "Fırın tepsisine yağlı kağıt serip sebzeleri yerleştirin.",
                "Somon filetolarını sebzelerin üzerine yerleştirin.",
                "Limon dilimlerini balıkların üzerine dizin.",
                "20-25 dakika fırında pişirin.",
                "Taze dereotu ile süsleyerek servis yapın."
            ],
            nutritionInfo: NutritionInfo(
                calories: 295,
                protein: 28.5,
                carbs: 8.2,
                fat: 16.8,
                fiber: 3.5
            ),
            tags: ["Omega-3", "Sağlıklı", "Glutensiz", "Balık"]
        ),
        
        Recipe(
            title: "Çikolatalı Brownie",
            description: "Yoğun çikolata lezzeti ve yumuşacık dokusuyla vazgeçilmez bir tatlı.",
            imageName: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400",
            prepTime: 20,
            cookTime: 35,
            servings: 12,
            difficulty: .hard,
            category: .dessert,
            ingredients: [
                Ingredient(name: "bitter çikolata", amount: "200", unit: "gram"),
                Ingredient(name: "tereyağı", amount: "150", unit: "gram"),
                Ingredient(name: "şeker", amount: "200", unit: "gram"),
                Ingredient(name: "yumurta", amount: "3", unit: "adet"),
                Ingredient(name: "un", amount: "100", unit: "gram"),
                Ingredient(name: "kakao", amount: "30", unit: "gram"),
                Ingredient(name: "vanilya özütü", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "tuz", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "ceviz", amount: "100", unit: "gram")
            ],
            instructions: [
                "Fırını 180°C'ye ısıtın. 20x20 cm kare kalıbı yağlayın.",
                "Çikolatayı tereyağı ile benmari usulü eritin.",
                "Karışımı soğumaya bırakın.",
                "Yumurtaları şekerle beyazlaşana kadar çırpın.",
                "Çikolatalı karışımı yumurtaya ekleyip karıştırın.",
                "Un, kakao, tuz ve vanilya özütünü ayrı bir kapta karıştırın.",
                "Kuru karışımı çikolatalı hamura ekleyip ovmadan karıştırın.",
                "Cevizleri kırıp hamura ekleyin.",
                "Hamuru kalıba dökün ve düzeltin.",
                "30-35 dakika pişirin. Ortası hafif nemli kalmalı.",
                "Soğuduktan sonra dilimleyip servis yapın."
            ],
            nutritionInfo: NutritionInfo(
                calories: 285,
                protein: 5.2,
                carbs: 32.5,
                fat: 16.8,
                fiber: 2.8
            ),
            tags: ["Tatlı", "Çikolata", "Özel Gün", "Zor"]
        ),
        
        Recipe(
            title: "Avokadolu Smoothie",
            description: "Kremalı ve besleyici. Kahvaltı veya ara öğün için mükemmel bir seçim.",
            imageName: "https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400",
            prepTime: 5,
            cookTime: 0,
            servings: 2,
            difficulty: .easy,
            category: .snack,
            ingredients: [
                Ingredient(name: "avokado", amount: "1", unit: "adet"),
                Ingredient(name: "muz", amount: "1", unit: "adet"),
                Ingredient(name: "süt", amount: "1", unit: "su bardağı"),
                Ingredient(name: "bal", amount: "1", unit: "yemek kaşığı"),
                Ingredient(name: "limon suyu", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "vanilya özütü", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "buz", amount: "4-5", unit: "küp")
            ],
            instructions: [
                "Avokadoyu soyup çekirdekten ayırın.",
                "Muzu soyup parçalayın.",
                "Tüm malzemeleri blender'a atın.",
                "2-3 dakika pürüzsüz bir kıvam alana kadar çırpın.",
                "Kıvamı kontrol edin, gerekirse süt ekleyin.",
                "Soğuk bardaklarda servis yapın.",
                "İsteğe bağlı chia tohumu veya granola ile süsleyin."
            ],
            nutritionInfo: NutritionInfo(
                calories: 185,
                protein: 5.8,
                carbs: 25.2,
                fat: 8.5,
                fiber: 6.8
            ),
            tags: ["Sağlıklı", "Vegan", "Hızlı", "İçecek"]
        ),
        
        Recipe(
            title: "Mantı",
            description: "Türk mutfağının en özel yemeklerinden biri. Evde yapılmış hamur ile nefis.",
            imageName: "https://images.unsplash.com/photo-1541696108-0ac4e6f0d7b5?w=400",
            prepTime: 120,
            cookTime: 45,
            servings: 6,
            difficulty: .hard,
            category: .lunch,
            ingredients: [
                Ingredient(name: "un", amount: "3", unit: "su bardağı"),
                Ingredient(name: "yumurta", amount: "1", unit: "adet"),
                Ingredient(name: "su", amount: "1/2", unit: "su bardağı"),
                Ingredient(name: "tuz", amount: "1", unit: "tatlı kaşığı"),
                Ingredient(name: "kıyma", amount: "300", unit: "gram"),
                Ingredient(name: "soğan", amount: "1", unit: "orta boy"),
                Ingredient(name: "maydanoz", amount: "1/2", unit: "demet"),
                Ingredient(name: "karabiber", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "yoğurt", amount: "2", unit: "su bardağı"),
                Ingredient(name: "sarımsak", amount: "3", unit: "diş"),
                Ingredient(name: "tereyağı", amount: "3", unit: "yemek kaşığı"),
                Ingredient(name: "pul biber", amount: "1", unit: "tatlı kaşığı")
            ],
            instructions: [
                "Un, yumurta, su ve tuz ile hamur yoğurun. 30 dakika dinlendirin.",
                "Soğan ve maydanozu ince kıyın, kıyma ile karıştırın.",
                "İç harcı tuz ve karabiber ile baharatlayın.",
                "Hamuru ince açın ve küçük kareler kesin.",
                "Her kareye az miktarda iç harç koyup kapatın.",
                "Mantıları kaynar tuzlu suda 15-20 dakika haşlayın.",
                "Yoğurdu sarımsak ile karıştırın.",
                "Tereyağını eritip pul biber ekleyin.",
                "Mantıları tabağa alın, üzerine yoğurt dökün.",
                "Tereyağlı pul biber ile servis yapın."
            ],
            nutritionInfo: NutritionInfo(
                calories: 385,
                protein: 18.5,
                carbs: 45.2,
                fat: 14.8,
                fiber: 2.5
            ),
            tags: ["Geleneksel", "Ana Yemek", "Özel Gün", "Zor"]
        ),
        
        Recipe(
            title: "Quinoa Salatası",
            description: "Süper besin quinoa ile hazırlanan renkli ve besleyici salata.",
            imageName: "https://images.unsplash.com/photo-1505253213348-cd54c92b37ed?w=400",
            prepTime: 15,
            cookTime: 15,
            servings: 4,
            difficulty: .easy,
            category: .salad,
            ingredients: [
                Ingredient(name: "quinoa", amount: "1", unit: "su bardağı"),
                Ingredient(name: "su", amount: "2", unit: "su bardağı"),
                Ingredient(name: "roket", amount: "2", unit: "avuç"),
                Ingredient(name: "cherry domates", amount: "150", unit: "gram"),
                Ingredient(name: "salatalık", amount: "1", unit: "adet"),
                Ingredient(name: "kırmızı biber", amount: "1/2", unit: "adet"),
                Ingredient(name: "kırmızı soğan", amount: "1/4", unit: "adet"),
                Ingredient(name: "feta peyniri", amount: "100", unit: "gram"),
                Ingredient(name: "zeytinyağı", amount: "3", unit: "yemek kaşığı"),
                Ingredient(name: "limon suyu", amount: "2", unit: "yemek kaşığı"),
                Ingredient(name: "tuz", amount: "1/2", unit: "tatlı kaşığı"),
                Ingredient(name: "nane", amount: "1", unit: "yemek kaşığı")
            ],
            instructions: [
                "Quinoa'yı soğuk suyla durulayın.",
                "2 su bardağı suda kaynatın, 15 dakika pişirin.",
                "Pişen quinoa'yı süzün ve soğutun.",
                "Cherry domatesleri ikiye, salatalığı küp şeklinde kesin.",
                "Kırmızı biberi ve soğanı ince doğrayın.",
                "Tüm sebzeleri quinoa ile karıştırın.",
                "Zeytinyağı ve limon suyunu karıştırın.",
                "Salata üzerine sos gezdirin.",
                "Tuz ile tatlandırıp karıştırın.",
                "Feta peyniri ve nane ile süsleyip servis yapın."
            ],
            nutritionInfo: NutritionInfo(
                calories: 245,
                protein: 9.5,
                carbs: 28.8,
                fat: 11.2,
                fiber: 4.8
            ),
            tags: ["Süper Besin", "Vejeteryan", "Glutensiz", "Protein"]
        )
    ]
    
    // MARK: - Firebase Collection Converter
    static func convertToFirebaseData() -> [[String: Any]] {
        return mockRecipes.map { recipe in
            [
                "title": recipe.title,
                "description": recipe.description,
                "imageName": recipe.imageName,
                "prepTime": recipe.prepTime,
                "cookTime": recipe.cookTime,
                "servings": recipe.servings,
                "difficulty": recipe.difficulty.rawValue,
                "category": recipe.category.rawValue,
                "ingredients": recipe.ingredients.map { ingredient in
                    [
                        "id": ingredient.id.uuidString,
                        "name": ingredient.name,
                        "amount": ingredient.amount,
                        "unit": ingredient.unit
                    ]
                },
                "instructions": recipe.instructions,
                "nutritionInfo": recipe.nutritionInfo.map { nutrition in
                    [
                        "calories": nutrition.calories,
                        "protein": nutrition.protein,
                        "carbs": nutrition.carbs,
                        "fat": nutrition.fat,
                        "fiber": nutrition.fiber ?? 0
                    ]
                } ?? [:],
                "tags": recipe.tags,
            ]
        }
    }
    
    // MARK: - JSON Export for Firebase Import
    static func generateFirebaseJSON() -> String {
        let firebaseData = convertToFirebaseData()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: firebaseData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8) ?? "JSON serialization failed"
        } catch {
            return "Error generating JSON: \(error.localizedDescription)"
        }
    }
}
