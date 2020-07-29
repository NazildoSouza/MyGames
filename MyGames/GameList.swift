//
//  GameList.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct GameList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: Game.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Game.title, ascending: true)]
    ) var games: FetchedResults<Game>
    
    @ObservedObject var data: GamesData
    @State private var searchbar = ""
    @State private var showBusca = false
    @State private var value = CGFloat.zero
    
    func dateFormatted(date: Date) -> String {
        let formatt = DateFormatter()
        formatt.dateStyle = .long
        return formatt.string(from: date)
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
//                    if self.searchbar != "" {
//                        FilteredList(filter: searchbar)
//                    } else {
                if self.games.count != 0 {
                    ZStack(alignment: .bottomTrailing) {
                        List {
                            if self.games.filter({ self.searchbar.isEmpty ? true : $0.title!.localizedStandardContains(self.searchbar)}).count != 0 {
                                
                                ForEach(games.filter({ self.searchbar.isEmpty ? true : $0.title!.localizedStandardContains(self.searchbar)
                                }), id: \.self) { game in
                                    NavigationLink(destination: GameView(game: game, data: self.data)) {
                                        HStack(alignment: .top) {
                                            if game.cover != nil {
                                                Image(uiImage: UIImage(data: game.cover!)!)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 100)
                                                    .cornerRadius(15)
                                            } else {
                                                Image("noCoverFull")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 100)
                                                    .cornerRadius(15)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(game.title ?? "Sem Titulo")
                                                    .font(.title)
                                                    .fontWeight(.heavy)
                                                Text(game.console?.name ?? "console desconhecido")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                
                                                Text(self.dateFormatted(date: game.releaseDate ?? Date()))
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .padding(.top, 8)
                                                
                                            }
                                            .padding(.leading, 5)
                                        }
                                        
                                    }
                                }
                                .onDelete { index in
                                    let game = self.games[index.first!]
                                    self.moc.delete(game)
                                    if self.moc.hasChanges {
                                        try? self.moc.save()
                                    }
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    Text("Sem resultados")
                                        .font(.headline)
                                    Spacer()
                                }
                            }
                        }
                        
                        SearchView(showBusca: $showBusca, txt: $searchbar)
                            .padding([.horizontal, .bottom], 30)
                            .offset(y: -self.value / 1.3)
                            .onAppear {
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .none) { (noti) in
                                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                    let height = value.height
                                    self.value = height
                                }
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                                    self.value = .zero
                                }
                        }
                            .animation(.easeInOut)
                    }
                    
                } else {
                    HStack {
                        Spacer()
                        Text("Não há jogos salvo!")
                            .font(.headline)
                        Spacer()
                    }
                }
                //  }
            }
            .navigationBarTitle("Lista de Jogos")
            .navigationBarItems(trailing: Button(action: {
                self.data.addOurEdit = 0
                self.data.showingAddGame.toggle()
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
                .sheet(isPresented: self.$data.showingAddGame) {
                    AddGame(data: self.data).environment(\.managedObjectContext, self.moc)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView: View {
    
    @Binding var showBusca: Bool
    @Binding var txt: String
    
    var body: some View {
        HStack {
            HStack {
                if self.showBusca {
                    Image(systemName: "magnifyingglass")
                        .padding(10)
                    TextField("Busca", text: self.$txt)
                    
                    Button(action: {
                        withAnimation {
                            self.showBusca.toggle()
                            self.txt = ""
                        }
                    }) {
                        Image(systemName: "xmark")
                            .padding(10)
                        
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            self.showBusca.toggle()
                        }
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .padding(20)
                    }
                }
            }
            .padding(self.showBusca ? 10 : 0)
            .background(Blur(stile: .systemMaterial))
            .cornerRadius(25)
        }
    }
    
}

struct GameList_Previews: PreviewProvider {
    static var previews: some View {
        GameList(data: GamesData())
    }
}
