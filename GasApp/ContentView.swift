//
//  ContentView.swift
//  GasApp
//
//  Created by Shawn Tucker on 6/9/24.
//

import SwiftUI

struct Restaurant: Identifiable, Hashable {
    let id: String
    let title: String
    let cuisine: CuisineOption
}

enum CuisineOption: String {
    case exxon, bp, shell, marathon
}

final class RestaurantManager {
    
    func getAllRestaurants() async throws -> [Restaurant] {
        [
            Restaurant(id: "1", title: "Exxon One", cuisine: .exxon),
            Restaurant(id: "2", title: "Corner Pantry 102", cuisine: .shell),
            Restaurant(id: "3", title: "Corner Pantry 132", cuisine: .bp),
            Restaurant(id: "4", title: "Circle K", cuisine: .marathon)
        
        ]
    }
}

@MainActor
final class SearchableViewModel: ObservableObject {
    
    @Published private(set) var allRestaurants: [Restaurant] = []
    let manager = RestaurantManager()
    
    func loadRestaurants() async {
        do {
            allRestaurants = try await manager.getAllRestaurants()
        } catch {
            print(error)
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = SearchableViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.allRestaurants) { restaurant in
                        restaurantRow(restaurant: restaurant)
                    }
                }
                .padding()
            }
        }
        
        .navigationTitle("Gas Stations")
        .task {
            await viewModel.loadRestaurants()
        }
    }
    
    private func restaurantRow(restaurant: Restaurant) -> some View {
       
            VStack(alignment: .leading, spacing: 10) {
                Text(restaurant.title)
                    .font(.headline)
                Text(restaurant.cuisine.rawValue.capitalized)
                    .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.05))
            
        
    }
}

#Preview {
    ContentView()
}
