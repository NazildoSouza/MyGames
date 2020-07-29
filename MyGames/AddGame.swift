//
//  AddGame.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct AddGame: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var endAddGame
    @FetchRequest(entity: Console.entity(), sortDescriptors: []) var consoles: FetchedResults<Console>
    
    @ObservedObject var data: GamesData
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nome do Jogo")) {
                    TextField("Jogo", text: self.$data.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .onTapGesture {
                    self.hiddenKeyboard()
                }
                
                Section(header: Text("Modelo do Console")) {
                    Picker("Console", selection: self.$data.indice) {
                        ForEach(consoles.sorted(by: {$0.name ?? "N/C" < $1.name ?? "N/C"}), id: \.self) { i in
                            HStack {
                                if i.imageConsole != nil {
                                    Image(uiImage: UIImage(data: i.imageConsole!)!)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .cornerRadius(10)
                                } else {
                                    Image("noCoverFull")
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .cornerRadius(10)
                                }
                                Text(i.name ?? "")
                            }
                        }
                    }
                    .labelsHidden()
                    .padding(.horizontal)
                    .pickerStyle(WheelPickerStyle())
                }
                .onTapGesture {
                    self.hiddenKeyboard()
                }
                
                Section(header: Text("Data de Lançamento")) {
                    DatePicker("Data", selection: self.$data.date ,displayedComponents: .date)
                    
                }
                
                Section(header: Text("Capa do Game")) {
                    HStack(alignment: .top) {
                        Spacer()
                        if self.data.imageCover != nil {
                            Image(uiImage: UIImage(data: self.data.imageCover!)!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.6)
                                .onTapGesture {
                                    self.data.showingPicker.toggle()
                            }
                        } else {
                            Button(action: {
                                self.data.showingPicker.toggle()
                            }) {
                                Text("Clique para adicionar imagem")
                                    .padding(.vertical, 30)
                            }
                        }
                        Spacer()
                    }
                }.animation(nil)
                
                Section {
                    HStack(alignment: .top) {
                        Spacer()
                        Button(action: {
                            if self.data.addOurEdit == 0 {
                                let game = Game(context: self.moc)
                                game.title = self.data.title
                                game.releaseDate = self.data.date
                                game.cover = self.data.imageCover
                                game.console = self.data.indice
                                
                                do {
                                    if self.moc.hasChanges {
                                        try self.moc.save()
                                        print("game salvo")
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                
                            } else {
                                self.data.tempGame?.title = self.data.title
                                self.data.tempGame?.releaseDate = self.data.date
                                self.data.tempGame?.console = self.data.indice
                                self.data.tempGame?.cover = self.data.imageCover
                                
                                do {
                                    if self.moc.hasChanges {
                                        try self.moc.save()
                                        print("game atualizado")
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                
                            }
                            
                            self.endAddGame.wrappedValue.dismiss()
                            
                        }) {
                            Text(self.data.addOurEdit == 0 ? "Adicionar" : "Atualizar")
                            
                        }
                        .disabled(self.data.title.isEmpty || self.consoles.count == 0)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(self.data.addOurEdit == 0 ? "Adicionar Jogo" : "Editar Jogo")
            .sheet(isPresented: self.$data.showingPicker) {
                ImagePicker(image: self.$data.imageCover)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if self.data.addOurEdit == 0 {
                self.data.indice = self.consoles.sorted(by: {$0.name ?? "N/C" < $1.name ?? "N/C"}).first ?? Console()
            }
        }
    }
    
    func hiddenKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct AddGame_Previews: PreviewProvider {
    static var previews: some View {
        AddGame(data: GamesData())
    }
}
