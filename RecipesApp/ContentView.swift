//
//  ContentView.swift
//  RecipesApp
//
//  Created by Pubudu Dilshan on 2024-12-30.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIngredients: String = ""
    @State private var recipes: [Recipe] = []
    @State private var filteredRecipes: [Recipe] = []
    @State private var isDarkMode: Bool = false
    @State private var userProfile: UserProfile = UserProfile(name: "Chef Alex", favoriteRecipes: [])
    
    var body: some View {
        NavigationView {
            ZStack {
                isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color(.systemGray6).edgesIgnoringSafeArea(.all)
                
                VStack {
                    // User Profile Header
                    HStack {
                        Text("👩‍🍳 Welcome, \(userProfile.name)!")
                            .font(.headline)
                            .padding()
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    
                    // Ingredient Input Field
                    TextField("Enter ingredients (e.g., Banana, Milk)", text: $selectedIngredients)
                        .padding()
                        .background(isDarkMode ? Color.gray : Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                    
                    // Search Button
                    Button(action: {
                        filterRecipes()
                    }) {
                        Text("Search Recipes")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                    
                    // Recipe List
                    ScrollView {
                        VStack(spacing: 20) {
                            if filteredRecipes.isEmpty {
                                Text("No recipes found! Try different ingredients.")
                                    .foregroundColor(isDarkMode ? .white : .gray)
                            } else {
                                ForEach(filteredRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe, userProfile: $userProfile)) {
                                        RecipeCard(recipe: recipe, isDarkMode: isDarkMode)
                                            .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Quick Recipes")
                            .font(.system(size: 28, weight: .bold)) // Larger and bold font
                            .foregroundColor(isDarkMode ? .white : .black) // Adapt to dark/light mode
                            .shadow(color: isDarkMode ? .gray : .clear, radius: 2, x: 1, y: 1) // Add a subtle shadow
                    }
                }
                                .navigationBarTitleDisplayMode(.inline)
                            }
        }
        .onAppear {
            fetchRecipes()
        }
    }
    
    private func filterRecipes() {
        filteredRecipes = recipes.filter { recipe in
            selectedIngredients.split(separator: ",").allSatisfy { ingredient in
                recipe.ingredients.lowercased().contains(ingredient.trimmingCharacters(in: .whitespaces).lowercased())
            }
        }
    }
    
    private func fetchRecipes() {
        // Simulated API Fetch with new recipes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            recipes = [
                // Existing Recipes
                Recipe(name: "Pasta Salad", ingredients: "Pasta, Tomato, Olive Oil", time: 10, calories: 300, rating: 4.5, imageName: "pasta", steps: [
                    "Boil pasta", "Chop vegetables", "Mix with dressing"
                ]),
                Recipe(name: "Smoothie", ingredients: "Banana, Milk, Honey", time: 5, calories: 150, rating: 5.0, imageName: "smoothie", steps: [
                    "Peel banana", "Blend all ingredients"
                ]),
                Recipe(name: "Grilled Cheese", ingredients: "Bread, Cheese, Butter", time: 7, calories: 250, rating: 4.0, imageName: "grilled_cheese", steps: [
                    "Butter bread", "Grill with cheese"
                ]),
                
                // New Recipes
                Recipe(name: "Veggie Stir-Fry", ingredients: "Carrot, Broccoli, Soy Sauce", time: 12, calories: 200, rating: 4.8, imageName: "veggie_stirfry", steps: [
                    "Chop vegetables", "Stir-fry in a pan", "Add soy sauce"
                ]),
                Recipe(name: "Fruit Salad", ingredients: "Apple, Orange, Grapes, Honey", time: 6, calories: 120, rating: 4.7, imageName: "fruit_salad", steps: [
                    "Chop fruits", "Mix with honey", "Serve chilled"
                ])
            ]
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let isDarkMode: Bool
    
    var body: some View {
        HStack {
            Image(recipe.imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)
                Text("⭐ \(String(format: "%.1f", recipe.rating)) | \(recipe.time) min | \(recipe.calories) cal")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? .gray : .blue)
            }
            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.gray : Color.white)
        .cornerRadius(12)
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    @Binding var userProfile: UserProfile
    @State private var currentStep: Int = 0
    
    var body: some View {
        VStack {
            Image(recipe.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
            
            Text(recipe.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Ingredients: \(recipe.ingredients)")
                .padding()
                .multilineTextAlignment(.center)
            
            Text("⭐ \(String(format: "%.1f", recipe.rating)) | \(recipe.calories) calories")
                .font(.headline)
            
            // Step-by-Step Instructions
            if currentStep < recipe.steps.count {
                Text(recipe.steps[currentStep])
                    .font(.title)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text("All steps completed! Enjoy your meal 🍽️")
                    .font(.title)
                    .padding()
            }
            
            // Step Navigation
            HStack {
                Button(action: {
                    if currentStep > 0 { currentStep -= 1 }
                }) {
                    Text("Previous Step")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(currentStep == 0)
                
                Button(action: {
                    if currentStep < recipe.steps.count - 1 { currentStep += 1 }
                }) {
                    Text("Next Step")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .disabled(currentStep >= recipe.steps.count - 1)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    userProfile.favoriteRecipes.append(recipe)
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// Models
struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let ingredients: String
    let time: Int
    let calories: Int
    let rating: Double
    let imageName: String
    let steps: [String]
}

struct UserProfile {
    let name: String
    var favoriteRecipes: [Recipe]
}
