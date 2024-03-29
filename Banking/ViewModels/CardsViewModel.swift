//
//  CardsViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 27.03.23.
//

import Foundation
import SwiftUI
import Combine

class CardsViewModel: AlertViewModel, ObservableObject {
    @AppStorage("userID") var userID: String = ""

    @Published var loading: Bool = false
    @Published var loadingCards: Bool = true
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var cards = [CardModel]()
    
    @Published var cardNumber: String = ""
    @Published var cardHolder: String = ""
    @Published var cvv: String = ""
    @Published var expirationDate: String = ""
    
    @Published var cardType = CreditCardType.nonIdentified
    @Published var design: CardDesign = .standardBlue
    
    
    var manager: CardServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var formURL = "https://www.google.com/"
    @Published var orderNumber: String = ""
    @Published var orderID: String = ""
    
    init(manager: CardServiceProtocol = CardService.shared) {
        self.manager = manager
    }
    
    @MainActor func getCards() {
        loadingCards = true
        alertMessage = ""
        
        Task {
            let result = await manager.fetchCards(userID: userID)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(let cards):
                self.cards = cards
            }
            
            if !Task.isCancelled {
                loadingCards = false
            }
        }
    }
    
    @MainActor func reorderCards() {
        Task {
            let result = await manager.reorderCards(userID: userID, cards: cards)
            print(result)
        }
    }
    
    @MainActor func deleteCard(id: String) {
        Task {
            let result = await manager.removeCard(userID: userID, cardID: id)
            switch result {
            case .failure(let error):
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            case .success(()):
                self.cards.removeAll(where: { $0.id == id })
            }
        }
    }
    
    @MainActor func registerOrder() {
        
        loading = true
        Task {
            do {
                let result = try await manager.registerOrder()

                self.formURL = result.formUrl!
                self.orderNumber = result.orderNumber
                self.orderID = result.orderId!
                print(result)
                NotificationCenter.default.post(name: Notification.Name(NotificationName.orderRegistered.rawValue), object: nil)
                
            } catch {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
    
    @MainActor func getAttachmentStatus() {
        loading = true
        Task {
            do {
                let result = try await manager.attachCard(orderNumber: orderNumber, orderId: orderID, cardStyle: design)
                print(result)
                
                NotificationCenter.default.post(name: Notification.Name(NotificationName.cardAttached.rawValue), object: nil)

                
            } catch {
                self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
            }
            
            if !Task.isCancelled {
                loading = false
            }
        }
    }
}
