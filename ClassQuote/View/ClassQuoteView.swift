//
//  ClassQuoteView.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 11/12/2025.
//

import SwiftUI

struct ClassQuoteView: View {
    
    @StateObject var viewModel = ClassQuoteViewModel()
    
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack {
                    if let payload = viewModel.dataPayLoad {
                        Text("\(payload.quote.quoteText)")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("- \(payload.quote.quoteAuthor)")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        Text("Aucune citation disponible")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
        }
        .task { @MainActor in
            await viewModel.loadData()
        }
    }
}

#Preview {
    ClassQuoteView()
}
