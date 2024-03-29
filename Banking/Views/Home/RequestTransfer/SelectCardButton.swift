//
//  SelectCardButton.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import SwiftUI

enum CardSelectionType {
    case popup, button
}

struct SelectCardButton: View {
    let card: CardModel
    let buttonType: CardSelectionType
    let action: () -> ()

    var body: some View {
        
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    TextHelper(text: card.cardHolder, color: AppColors.darkBlue, fontName: Roboto.medium.rawValue, fontSize: 16)
                    TextHelper(text: card.cardPan, color: AppColors.gray, fontName: Roboto.medium.rawValue, fontSize: 12)

                }
                
                Spacer()
                
                if buttonType == .popup {
                    Image("drop_arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 10, height: 5)
                }
            }.padding(.vertical, 17)
                .padding(.horizontal, 20)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                }
        }
    }
}

struct SelectCardButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectCardButton(card: PreviewModels.masterCard, buttonType: .popup) {
            
        }
    }
}
