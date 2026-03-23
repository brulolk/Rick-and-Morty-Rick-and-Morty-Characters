//
//  CharacterListView.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Characters")
                .navigationDestination(for: Character.self) { character in
                    CharacterDetailView(
                        viewModel: CharacterDetailViewModel(characterId: character.id)
                    )
                }
                .searchable(text: $viewModel.searchText, prompt: "Search characters...")
                .toolbar {
                    filterToolbarItem
                }
                .task {
                    await viewModel.fetchInitialCharacters()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.characters.isEmpty {
            ProgressView("Loading characters...")
                .accessibilityIdentifier("LoadingProgressView")
        } else if let errorMessage = viewModel.errorMessage, viewModel.characters.isEmpty {
            errorView(message: errorMessage)
        } else if viewModel.characters.isEmpty && !viewModel.isLoading {
            emptyStateView
        } else {
            characterList
        }
    }
    
    // MARK: - Subviews
    private var characterList: some View {
        List {
            ForEach(viewModel.characters) { character in
                // NavigationLink usando o valor para disparar o navigationDestination
                NavigationLink(value: character) {
                    CharacterRowView(character: character)
                        .onAppear {
                            viewModel.fetchNextPageIfNeeded(currentCharacter: character)
                        }
                }
            }
            
            if viewModel.isLoading && !viewModel.characters.isEmpty {
                paginationIndicator
            }
        }
        .listStyle(.plain)
    }
    
    private var paginationIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .listRowSeparator(.hidden)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
            Button("Try Again") {
                viewModel.resetAndFetch()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("No characters found.")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    // MARK: - Toolbar Item
    private var filterToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Picker("Status", selection: $viewModel.selectedStatus) {
                    Text("All").tag(CharacterStatus?(nil))
                    Text("Alive").tag(CharacterStatus?(CharacterStatus.alive))
                    Text("Dead").tag(CharacterStatus?(CharacterStatus.dead))
                    Text("Unknown").tag(CharacterStatus?(CharacterStatus.unknown))
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .accessibilityLabel("Filter by status")
            }
        }
    }
}
