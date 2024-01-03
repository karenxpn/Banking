//
//  ImageHelper.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct ImageHelper: View {
    let image: String
    let contentMode: ContentMode
    
    var body: some View {
        WebImage(url: URL(string: image))
            .placeholder(content: {
                ProgressView()
            })
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
