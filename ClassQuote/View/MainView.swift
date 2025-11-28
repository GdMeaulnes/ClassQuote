//
//  ContentView.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 24/11/2025.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    let blurHash: String = "LF8zMrE20f^kS$jYV@xtE2kC-oM{"
    
    var body: some View {
        VStack {
            if let img = UIImage(blurHash: blurHash, size: CGSize(width: 32, height: 32)) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.gray
            }
            
            /*
            AsyncImage(url: URL(string: "https://example.com/icon.png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            AsyncImage(url: URL(string: "https://example.com/icon.png")) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                } else if phase.error != nil {
                    Color.red // Indicates an error.
                } else {
                    Color.blue // Acts as a placeholder.
                }
            }
             */

            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    MainView()
}

