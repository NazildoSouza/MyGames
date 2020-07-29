//
//  AddConsole.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct AddConsole: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var data: GamesData
    
    var body: some View {
        ZStack {
            Blur(stile: .systemMaterial)
            
            VStack {
                VStack {
                    if self.data.imageConsole == nil {
                        Button(action: {
                            self.data.showingPicker.toggle()
                        }) {
                            Text("Clique para adicionar imagem")
                                .padding(.horizontal)
                                .padding(.vertical, 25)
                        }
                    } else {
                        Button(action: {
                            self.data.showingPicker.toggle()
                        }) {
                            Image(uiImage: UIImage(data: self.data.imageConsole!)!)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 80, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding()
                        }
                    }
                }
                
                Text("Digite o nome do Console.")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Nome do Console", text: self.$data.console)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .layoutPriority(1)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                HStack {
                    Button(action: {
                        self.data.showingAddConsole = false
                        self.hiddenKeyboard()
                    }) {
                        Text("Cancelar")
                            .padding()
                            .background(self.colorScheme == .light ? Color.white : Color(#colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    
                    Button(action: {
                        if self.data.addOurEdit == 0 {
                            let console = Console(context: self.moc)
                            console.name = self.data.console
                            console.imageConsole = self.data.imageConsole
                            
                            do {
                                if self.moc.hasChanges {
                                    try self.moc.save()
                                    print("console salvo")
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            self.data.tempConsole?.name = self.data.console
                            self.data.tempConsole?.imageConsole = self.data.imageConsole
                            
                            do {
                                if self.moc.hasChanges {
                                    try self.moc.save()
                                    print("console atualizado")                                    
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        self.data.showingAddConsole = false
                        self.hiddenKeyboard()
                    }) {
                        Text(self.data.addOurEdit == 0 ? "Adicionar" : "Atualizar")
                            .padding()
                            .background(self.colorScheme == .light ? Color.white : Color(#colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    .disabled(self.data.console.isEmpty)
                }
            }
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .cornerRadius(20)
        .shadow(radius: 10)
        .sheet(isPresented: self.$data.showingPicker) {
            ImagePicker(image: self.$data.imageConsole)
        }
    }
    
    func hiddenKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

struct Blur: UIViewRepresentable {
    var stile: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: stile)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct AddConsole_Previews: PreviewProvider {
    static var previews: some View {
        AddConsole(data: GamesData())
    }
}
