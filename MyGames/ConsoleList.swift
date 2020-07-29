//
//  ConsoleList.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct ConsoleList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Console.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Console.name, ascending: true)
    ]) var consoles: FetchedResults<Console>
    
    @ObservedObject var data: GamesData
    @State private var value = CGFloat.zero
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if consoles.count != 0 {
                        List {
                            ForEach(consoles, id: \.self) { console in
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text(console.name ?? "Console desconhecido")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    if console.imageConsole != nil {
                                        Image(uiImage: UIImage(data: console.imageConsole!)!)
                                            .resizable()
                                            .frame(width: 80, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .shadow(radius: 2)
                                            .padding(.horizontal)
                                        
                                    } else {
                                        Image("noCoverFull")
                                            .resizable()
                                            .frame(width: 80, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .shadow(radius: 2)
                                            .padding(.horizontal)
                                        
                                    }
                                }
                                .contextMenu {
                                    VStack {
                                        Button(action: {
                                            self.data.tempConsole = console
                                            self.data.addOurEdit = 1
                                            withAnimation {
                                                self.data.showingAddConsole = true
                                            }
                                            
                                            self.data.console = console.name ?? ""
                                            self.data.imageConsole = console.imageConsole
                                            
                                        }) {
                                            HStack {
                                                Image(systemName: "square.and.pencil")
                                                Text("Editar")
                                                    .font(.headline)
                                                
                                            }
                                        }
                                        Button(action: {
                                            let av = UIActivityViewController(activityItems: [console.imageConsole ?? "N/C"], applicationActivities: nil)
                                            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                                        }) {
                                            Text("Compartilhe")
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            .onDelete { index in
                                let console = self.consoles[index.first!]
                                self.moc.delete(console)
                                if self.moc.hasChanges {
                                    try? self.moc.save()
                                }
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Não há consoles salvo!")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("Lista de plataformas")
                .navigationBarItems(trailing: Button(action: {
                    self.data.addOurEdit = 0
                    withAnimation {
                        self.data.showingAddConsole.toggle()
                    }
                    
                }, label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            Blur(stile: .systemUltraThinMaterial).opacity(self.data.showingAddConsole ? 1 : 0).edgesIgnoringSafeArea(.all).onTapGesture {
                self.hiddenKeyboard()
            }
            
            if self.data.showingAddConsole {
                AddConsole(data: self.data).environment(\.managedObjectContext, self.moc)
                    .offset(y: -self.value / 3)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                            let heigth = value.height
                            self.value = heigth
                        }
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                            self.value = .zero
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }     
        }
    }
    
    func hiddenKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct ConsoleList_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleList(data: GamesData())
    }
}
