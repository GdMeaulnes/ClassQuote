//
//  GetAllDataUsecases.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 10/12/2025.
//

import Foundation

class GetAllDataUsecases {
    
    let forismaticAPIDataSource = ForismaticAPIDataSource()
    let unSplashAPIDataSource = UnSplashAPIDataSource()
    
    func execute() async throws -> DataPayLoad {
        
        let quote = try await forismaticAPIDataSource.getQuote()
        let photo = try await unSplashAPIDataSource.getInfoPhoto()
        
        return DataPayLoad(quote: quote, photo: photo)
        
    }
}

