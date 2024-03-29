//
//  CardValidationTF.swift
//  Banking
//
//  Created by Karen Mirakyan on 20.03.23.
//

import Foundation
import SwiftUI

public struct CardValidationTF: View {
    
    @Binding private var text: String
    @Binding private var isValid: Bool
    @Binding private var bankCardType: CreditCardType
    private let tfType: CardTextField
    private let tfFont: Font
    private let tfColor: Color
    private let subtitle: String
    
    public init(
        text: Binding<String>,
        isValid: Binding<Bool>,
        bankCardType: Binding<CreditCardType>,
        tfType: CardTextField,
        tfFont: Font = Font.title,
        tfColor: Color = .black.opacity(0.9),
        subtitle: String = ""
    ) {
        self._text = text
        self._isValid = isValid
        self._bankCardType = bankCardType
        self.tfType = tfType
        self.tfFont = tfFont
        self.tfColor = tfColor
        self.subtitle = subtitle
    }
    
    public var body: some View {
        switch tfType {
        case .cardNumber:
            cardNumberView()
        case .cvv:
            cvvView()
        case .cardHolder:
            cardHolderView()
        case .dateExpiration:
            dateExpirationView()
        }
    }
    
    @ViewBuilder
    private func cardNumberView() -> some View {
        TextField(subtitle, text: $text)
            .keyboardType(.numberPad)
            .font(tfFont)
            .foregroundColor(tfColor)
            .valueChanged(value: text) { number in
                self.text = number.formattedCreditCard
                self.isValid = CreditCardValidator(number).isValid
                self.bankCardType = CreditCardValidator(number).type ?? CreditCardType.nonIdentified
            }
    }
    
    @ViewBuilder
    private func cvvView() -> some View {
        TextField(subtitle, text: $text)
            .keyboardType(.numberPad)
            .font(tfFont)
            .foregroundColor(tfColor)
            .valueChanged(value: text) { cvv in
                self.text = cvv.formattedCvv
                withAnimation(.linear) {
                    self.isValid = CardValidationTF.isCvvValid(text)
                }
            }
    }
    
    @ViewBuilder
    private func dateExpirationView() -> some View {
        TextField(subtitle, text: $text)
            .keyboardType(.numberPad)
            .font(tfFont)
            .foregroundColor(tfColor)
            .valueChanged(value: text) { date in
                self.text = date.formattedExpiredDate
                withAnimation(.linear) {
                    self.isValid = CardValidationTF.isExpDateValid(text)
                }
            }
    }
    
    @ViewBuilder
    private func cardHolderView() -> some View {
        TextField(subtitle, text: $text)
            .font(tfFont)
            .foregroundColor(tfColor)
            .valueChanged(value: text) { name in
                withAnimation(.linear) {
                    self.isValid = CardValidationTF.isCardHolderNameValid(text)
                }
            }
    }
}
