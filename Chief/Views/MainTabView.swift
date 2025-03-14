import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0 // Track current tab
    @State private var transitionDirection: Edge = .trailing // Track swipe direction

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                AddIngredientView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Add Ingredient")
                    }
                SubscriptionView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "star")
                        Text("Subscriptions")
                    }
            }
            .transition(.move(edge: transitionDirection)) // Apply slide transition
            .animation(.easeInOut(duration: 0.3), value: selectedTab) // Smooth animation
            
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let swipeThreshold: CGFloat = 50
                        if value.translation.width < -swipeThreshold {
                            if selectedTab < 2 {
                                transitionDirection = .trailing // Slide left
                                withAnimation {
                                    selectedTab += 1
                                }
                            }
                        } else if value.translation.width > swipeThreshold {
                            if selectedTab > 0 {
                                transitionDirection = .leading // Slide right
                                withAnimation {
                                    selectedTab -= 1
                                }
                            }
                        }
                    }
            )
        }
        .accentColor(.white)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = UIColor.gray
            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
            itemAppearance.selected.iconColor = UIColor.white
            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance = itemAppearance
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}



//import SwiftUI
//
//struct MainTabView: View {
//    var body: some View {
//        TabView {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//            AddIngredientView()
//                .tabItem {
//                    Image(systemName: "plus")
//                    Text("Add Ingredient")
//                }
//            SubscriptionView()
//                .tabItem {
//                    Image(systemName: "star")
//                    Text("Subscriptions")
//                }
//        }
//        .accentColor(.white)
//        .onAppear {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = UIColor.black
//            let itemAppearance = UITabBarItemAppearance()
//            itemAppearance.normal.iconColor = UIColor.gray
//            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
//            itemAppearance.selected.iconColor = UIColor.white
//            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            appearance.stackedLayoutAppearance = itemAppearance
//            UITabBar.appearance().standardAppearance = appearance
//            if #available(iOS 15.0, *) {
//                UITabBar.appearance().scrollEdgeAppearance = appearance
//            }
//        }
//    }
//}
