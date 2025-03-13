import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AddIngredientView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Ingredient")
                }
            SubscriptionView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Subscriptions")
                }
        }
    }
}
