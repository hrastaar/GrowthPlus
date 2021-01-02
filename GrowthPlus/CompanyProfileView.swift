//
//  CompanyProfileView.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/1/21.
//

import SwiftUI

// Extention for popover view
extension StockPageView {
    var CompanyInfoPopoverView: some View {
        VStack {
            HStack {
                Text("Hold Popup to Hide")
                    .font(primaryFont(size: 12))
                Spacer()
                Text(financialConnection.companyProfile.ticker)
                    .font(primaryFont(size: 12))
                Divider()
                    .background(Color.white)
                    .frame(height: 15)
                Text(financialConnection.companyProfile.exchange)
                    .font(primaryFont(size: 12))
            }.onTapGesture {
                self.showCompanyProfilePopoverView = false
            }
            .padding(.horizontal)
            .padding(.top)
            
            Text(financialConnection.companyProfile.companyName)
                .font(primaryFont(size: 20))
            
            ScrollView {
                VStack(spacing: 20) {
                    Section {
                        HStack {
                            Text("Industry")
                                .font(primaryFont(size: 15))
                            Spacer()
                            Text(financialConnection.companyProfile.industry)
                                .font(primaryFont(size: 15))
                        }
                        if !financialConnection.companyProfile.CEO.isEmpty {
                            HStack {
                                Text("CEO")
                                    .font(primaryFont(size: 15))
                                Spacer()
                                Text(financialConnection.companyProfile.CEO)
                                    .font(primaryFont(size: 15))
                            }
                        }
                        
                        if let numEmployees = financialConnection.companyProfile.numEmployees {
                            HStack {
                                Text("No. of Employees")
                                    .font(primaryFont(size: 15))
                                Spacer()
                                Text(numEmployees == 0 ? "NA" : String(numEmployees))
                                    .font(.custom("DIN-D", size: 15))
                            }
                        }
                        if let description = financialConnection.companyProfile.description {
                            Text("Description")
                                .font(primaryFont(size: 15))
                            Text(description.isEmpty ? "Not Available" : "\t" + description)
                                .font(primaryFont(size: 12))
                                .multilineTextAlignment(.leading)
                        }
                        
                    }.padding(.horizontal)
                    Divider()
                        .background(colorManager.primaryColor)
                        .frame(width: UIScreen.main.bounds.width - 75)
                    if let tags = financialConnection.companyProfile.tags {
                        Section {
                            Text("Company Tags")
                                .font(primaryFont(size: 18))
                            ForEach(tags.indices, id: \.self) { index in
                                HStack {
                                    Text(tags[index])
                                        .padding(3)
                                        .background(colorManager.primaryColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(7.5)
                                        .font(primaryFont(size: 15))
                                }
                            }
                        }
                        Divider()
                            .background(colorManager.primaryColor)
                            .frame(width: UIScreen.main.bounds.width - 75)
                    }
                    
                    // If true, it is guaranteed that none of the address data is nil
                    if financialConnection.companyProfile.addressAvailable() {
                        Section {
                            VStack {
                                Text("Company Address")
                                    .font(primaryFont(size: 18))
                                Text(financialConnection.companyProfile.address)
                                    .font(primaryFont(size: 13))
                                HStack {
                                    Text(financialConnection.companyProfile.city! + ", " + financialConnection.companyProfile.state!)
                                        .font(primaryFont(size: 13))
                                    Text(financialConnection.companyProfile.zip!)
                                        .font(.custom("DIN-D", size: 13))
                                }
                                Text(financialConnection.companyProfile.phone)
                                    .font(.custom("DIN-D", size: 13))
                            }
                        }.padding(.bottom)
                    }
                }
                
            } /// End of ScrollView
        }.onLongPressGesture {
            self.showCompanyProfilePopoverView = false
        }
        .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height - 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.init(white: 0.07).opacity(0.95))
        .foregroundColor(.white)
        .cornerRadius(12.5)
        .padding()
    }
}
