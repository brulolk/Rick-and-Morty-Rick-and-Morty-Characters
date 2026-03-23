//
//  CharacterDetailView.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
            } else if let character = viewModel.character {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView().frame(width: 250, height: 250)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Group {
                        Text(character.name).font(.largeTitle).bold()
                        
                        DetailRow(label: "Status", value: character.status.rawValue)
                        DetailRow(label: "Species", value: character.species)
                        DetailRow(label: "Gender", value: character.gender)
                        DetailRow(label: "Origin", value: character.origin.name)
                        DetailRow(label: "Location", value: character.location.name)
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Episodes Appearances (\(character.episode.count))")
                        .font(.headline)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(character.episode, id: \.self) { url in
                                let episodeId = url.components(separatedBy: "/").last ?? ""
                                Text("Ep \(episodeId)")
                                    .font(.caption)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .navigationTitle("Details")
        .task {
            await viewModel.fetchDetails()
        }
    }
}

// Componente auxiliar para manter a View limpa
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(label):").bold()
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
    }
}
