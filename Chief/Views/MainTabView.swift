import SwiftUI

enum Tab: Int {
    case home = 0
    case addIngredient = 1
    case subscriptions = 2
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var transitionDirection: Edge = .trailing

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(Tab.home)
                    .environment(\.selectedTab, $selectedTab) // Pass selectedTab

                AddIngredientView()
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Add Ingredient")
                    }
                    .tag(Tab.addIngredient)
                    .environment(\.selectedTab, $selectedTab)

                SubscriptionView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Subscriptions")
                    }
                    .tag(Tab.subscriptions)
                    .environment(\.selectedTab, $selectedTab)
            }
            .transition(.move(edge: transitionDirection))
            .animation(.easeInOut(duration: 0.3), value: selectedTab)

            .gesture(
                DragGesture()
                    .onEnded { value in
                        let swipeThreshold: CGFloat = 50
                        if value.translation.width < -swipeThreshold {
                            if selectedTab.rawValue < 2 {
                                transitionDirection = .trailing
                                withAnimation {
                                    selectedTab = Tab(rawValue: selectedTab.rawValue + 1) ?? .subscriptions
                                }
                            }
                        } else if value.translation.width > swipeThreshold {
                            if selectedTab.rawValue > 0 {
                                transitionDirection = .leading
                                withAnimation {
                                    selectedTab = Tab(rawValue: selectedTab.rawValue - 1) ?? .home
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

// Custom environment key for selectedTab
private struct SelectedTabKey: EnvironmentKey {
    static let defaultValue: Binding<Tab> = .constant(.home)
}

extension EnvironmentValues {
    var selectedTab: Binding<Tab> {
        get { self[SelectedTabKey.self] }
        set { self[SelectedTabKey.self] = newValue }
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
