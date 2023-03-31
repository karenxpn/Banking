//
//  ViewInDevelopmentMode.swift
//  Banking
//
//  Created by Karen Mirakyan on 31.03.23.
//

import SwiftUI

struct ViewInDevelopmentMode: View {
    var body: some View {
        
        VStack(spacing: 40) {
            
            Image("request-transfer-success")
            VStack(spacing: 12) {
                TextHelper(text: NSLocalizedString("sorryForInconvenience", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    .multilineTextAlignment(.center)

                TextHelper(text: NSLocalizedString("thisPageIsInDevelopmentMode", comment: ""), color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 14)
                    .multilineTextAlignment(.center)
            }
            
        }.padding(24)
    }
}

struct ViewInDevelopmentMode_Previews: PreviewProvider {
    static var previews: some View {
        ViewInDevelopmentMode()
    }
}
