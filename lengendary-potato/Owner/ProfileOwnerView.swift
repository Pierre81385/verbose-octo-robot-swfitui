//
//  OwnerImageView.swift
//  lengendary-potato
//
//  Created by m1_air on 5/22/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileOwnerView: View {
    @ObservedObject var ownerViewModel: OwnerViewModel
    @State private var ownerDocFound: Bool = false
    @State private var locationShared: Bool = false
    @State private var showMapWithAddress: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if(ownerDocFound){
                    VStack{
                        Spacer()
                        AsyncAwaitImageView(imageUrl: URL(string: ownerViewModel.owner.avatarUrl)!)
                            .scaledToFill()
                            .frame(width: 325, height: 325)
                            .clipShape(Circle())
                        Text(ownerViewModel.owner.name)
                        Text(ownerViewModel.owner.email)
                        if(ownerViewModel.owner.lat == 0) {
                            
                                HStack{
                                    Button(action: {
                                        showMapWithAddress = true
                                    }, label: {
                                        HStack{
                                            Text("Find My Location").foregroundStyle(.white)
                                        }
                                    }).sheet(isPresented: $showMapWithAddress, onDismiss: {}, content: {
                                        UserLocationView()
                                    })
                                    .frame(width: 200, height: 30)
                                        .background(RoundedRectangle(cornerRadius: 8))
                                        .foregroundStyle(.black)
                                        .shadow(color: .gray.opacity(0.6), radius: 15, x: 5, y: 5)
                                }

                        }
                        Spacer()
                    }
                } else {
                    Text("Loading Profile.")
                }
            }.onAppear{
                if(Auth.auth().currentUser != nil){
                    ownerViewModel.owner.id = Auth.auth().currentUser!.uid
                    Task{
                        ownerDocFound = await ownerViewModel.getOwner()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileOwnerView(ownerViewModel: OwnerViewModel())
}

