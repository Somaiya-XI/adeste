//
//  IntentionCard.swift
//  levelUp
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftUI

struct IntentionCard: View {
    @State var name = ""
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            let height = size.height
            
            ZStack{
                Image("Intentions1")
                    .ignoresSafeArea()
                    .overlay {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                    }.blur(radius: 4)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                        .frame(width: (width * 0.9), height: (height * 0.58))
                    
                    VStack (alignment: .leading) {
                        HStack(alignment: .center){
                            Text("New Intention")
                                .font(.s24Semibold)
                            Spacer()
                            Button{
                                
                            }label:{
                                Image(systemName: "xmark.circle")
                                    .font(.s28Medium)
                            }.tint(.brand)
                        }
                        
                        HStack{
                                Circle()
                                .fill(.secColorBlue.opacity(0.7))
                                    .frame(width: width * 0.16)
                                    .overlay {
                                        Image(systemName: "pencil")
                                            .font(.s32Bold)
                                    }
                                                           
                                TextField("e.g, Reading", text: $name)
                                    .padding(16)
                                    .background(.gray.opacity(0.4))
                                    .clipShape(.capsule)
                            }
                        Text("Apps").font(.s20Medium)
                            ScrollView(.vertical){
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], alignment: .center, spacing: 8){
                                    ForEach(1...14, id:\.self ){ i in
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.black.opacity(0.3))
                                            .frame(width: width * 0.16, height: width * 0.16).padding(.horizontal, 8)
                                    }
                                    
                                }.padding(.vertical, 10)
                                    .padding(.horizontal, 4)
                            }.scenePadding(.vertical)
                            .safeAreaPadding(.horizontal)
                            .frame(maxHeight: width * (0.16*2.9))
                            .background(.gray)
                            .clipShape(.rect(cornerRadius: 20))

                            
                        Button{}
                        label:{
                            Text("Done")
                                .font(.s20Semibold)
                                .padding(8)
                        }
                            .buttonSizing(.flexible)
                            .buttonStyle(.bordered)
                            .tint(.secColorBerry)

                       Spacer()
                      
                    }.padding(.top, height * 0.2)
                    .padding(16)
                    
                }.padding()
                
            }
        }

        }

}

#Preview {
    IntentionCard()
}
