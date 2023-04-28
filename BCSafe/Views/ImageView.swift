//
//  ImageView.swift
//  BCSafe
//
//  Created by mike on 4/27/23.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.dismiss) var dismiss
    @State var photoURL: String
    
    var body: some View {
        NavigationStack {
            AsyncImage(url: URL(string: photoURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }

                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageView(photoURL: "")
        }
    }
}
