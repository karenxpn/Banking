//
//  FAQDetail.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct FAQDetail: View {
    let faq: FAQModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                TextHelper(text: faq.question, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                    .lineLimit(nil)
                TextHelper(text: faq.answer, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                    .lineLimit(nil)
            }.padding(24)
        }
    }
}

struct FAQDetail_Previews: PreviewProvider {
    static var previews: some View {
        FAQDetail(faq: PreviewModels.faqList[0])
    }
}
