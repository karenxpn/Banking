//
//  RequestTransferViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 30.03.23.
//

import Foundation
import SwiftUI

class RequestTransferViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var loadingRequest: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    @Published var amount: String = ""
    
    @Published var selectedCard: CardModel?
    @Published var generatedLink: String = ""
    
    var cardManager: CardServiceProtocol
    var manager: TransferServiceProtocol
    init(cardManager: CardServiceProtocol = CardService.shared,
         manager: TransferServiceProtocol = TransferService.shared) {
        self.cardManager = cardManager
        self.manager = manager
    }
    
    @MainActor func getCards() {
        loading = true
        alertMessage = ""
        
        Task {
            let result = await cardManager.fetchCards(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let cards):
                self.cards = cards
                self.selectedCard = cards.first(where: { $0.defaultCard })
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func requestPayment() {
        loadingRequest = true
        Task {
            let result = await manager.requestTransfer(amount: amount)
            
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let response):
                self.generatedLink = response.message
                NotificationCenter.default.post(name: Notification.Name(NotificationName.requestPaymentSent.rawValue), object: nil)
                print(response)
            }
            
            if !Task.isCancelled {
                loadingRequest = false
            }
        }
    }
}
