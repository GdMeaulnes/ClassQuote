//
//  BlurHashAsyncImage.swift
//  ClassQuote
//
//  Created by Richard DOUXAMI on 27/11/2025.
//

import SwiftUI

struct BlurHashAsyncImage: View {
    let picture : UnSplashPhoto

    @State private var loadedImage: UIImage? = nil

    var body: some View {
        ZStack {
            // on affiche le decode du hash
            if let placeholder = UIImage(blurHash: picture.blur_hash) {
                Image(uiImage: placeholder)
                    .resizable()
                    .scaledToFill()
                    .opacity(loadedImage == nil ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: loadedImage)
            }

            // veritable image
            if let img = loadedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            }
        }
        .onAppear { downloadImage() }
    }

    private func downloadImage() {
        // Si c'est déjà chargé, on ne fait rien
        if loadedImage != nil { return }

        URLSession.shared.dataTask(with: picture.urlsFull!) { data, _, _ in
            guard let data = data, let img = UIImage(data: data) else { return }
            
            // On lance dans la bonne queue le chargement (pause de 4 secondes histoire de voir...)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.loadedImage = img
                }
            }
        }.resume()
    }
}

#Preview {
    BlurHashAsyncImage(picture: samplePhoto)
}
