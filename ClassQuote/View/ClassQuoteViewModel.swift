//
//  ClassQuoteViewModel.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 10/12/2025.
//

import Foundation
import Combine

@MainActor
class ClassQuoteViewModel :ObservableObject {
    
    @Published var dataPayLoad: DataPayLoad? = nil
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    
    private let getAllDataUseCases = GetAllDataUsecases()
    
    @MainActor func loadData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let result = try await getAllDataUseCases.execute()
            print("dans loadData")
            self.dataPayLoad = result
        } catch {
            errorMessage = "Error : \(error.localizedDescription)"
        }
    }
}
