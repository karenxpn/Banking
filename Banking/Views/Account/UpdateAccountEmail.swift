//
//  UpdateAccountEmail.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.10.23.
//

import SwiftUI

struct UpdateAccountEmail: View {
    @State private var email: String
    @State private var emailValid: Bool
    @StateObject private var accountVM = AccountViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    
    init(email: String?) {
        _email = State(initialValue: email ?? "")
        _emailValid = State(initialValue: email?.isEmail ?? true)
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            TextHelper(text: NSLocalizedString("email", comment: ""), color: AppColors.gray, fontName: Roboto.bold.rawValue, fontSize: 16)
            
            CardDetailTextFieldDecorator(content: {
                TextField(NSLocalizedString("example@domain.com", comment: ""), text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .font(.custom(Roboto.medium.rawValue, size: 16))
                    .padding(.leading, 16)
                    .onChange(of: email) { newValue in
                        emailValid = newValue.isEmail
                    }
            }, isValid: $emailValid)
            
            TextHelper(text: NSLocalizedString("youWillReceiveVerificationEmail", comment: ""), color: AppColors.gray)
            
            
            ButtonHelper(disabled: !emailValid || (emailValid && email.isEmpty) || accountVM.loading, label: NSLocalizedString("update", comment: "")) {
                accountVM.updateEmail(email: email)
            }.padding(.top, 100)
            
            
        }.padding(24)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(Text(""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextHelper(text: NSLocalizedString("verifyYourEmail", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                    }
                }.onReceive(NotificationCenter.default.publisher(for:
                                                                    Notification.Name(rawValue: NotificationName.emailUpdated.rawValue))) { _ in
                    viewRouter.popToAccountRoot()
                }.alert(NSLocalizedString("error", comment: ""), isPresented: $accountVM.showAlert, actions: {
                    Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
                }, message: {
                    Text(accountVM.alertMessage)
                })
    }
}

#Preview {
    UpdateAccountEmail(email: nil)
}
