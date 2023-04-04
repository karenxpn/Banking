//
//  AllFAQs.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.04.23.
//

import SwiftUI

struct AllFAQs: View {
    @StateObject private var accountVM = AccountViewModel()
    @State private var showDetail: Bool = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            
            LazyVStack {
                ForEach(accountVM.faqs, id: \.id) { faq in
                    Button {
                        showDetail.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            TextHelper(text: faq.question, color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 24)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            TextHelper(text: faq.answer, color: AppColors.gray, fontName: Roboto.regular.rawValue, fontSize: 12)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)

                        }.padding(20)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(AppColors.border, lineWidth: 1)
                            }.onAppear {
                                if faq.id == accountVM.faqs.last?.id && !accountVM.loading {
                                    accountVM.getFaqs()
                                }
                            }
                    }.sheet(isPresented: $showDetail) {
                        FAQDetail(faq: faq)
                    }
                }
                
                if accountVM.loading {
                    ProgressView()
                }
            }.padding(24)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            
        }.padding(.top, 1)
            .task {
                accountVM.getFaqs()
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: $accountVM.showAlert, actions: {
                Button(NSLocalizedString("gotIt", comment: ""), role: .cancel) { }
            }, message: {
                Text(accountVM.alertMessage)
            })
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextHelper(text: NSLocalizedString("faq", comment: ""), color: AppColors.darkBlue, fontName: Roboto.bold.rawValue, fontSize: 20)
                }
            }
    }
}

struct AllFAQs_Previews: PreviewProvider {
    static var previews: some View {
        AllFAQs()
    }
}