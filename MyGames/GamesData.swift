//
//  GamesData.swift
//  MyGames
//
//  Created by Nazildo Souza on 09/05/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

class GamesData: ObservableObject {
    @Published var showingAddConsole = false
    @Published var showingAddGame = false
    
    @Published var title = ""
    @Published var console = ""
    @Published var date = Date()
    @Published var indice: FetchedResults<Console>.Element = Console()
    
    @Published var showingPicker = false
    @Published var imageCover: Data?
    @Published var imageConsole: Data?
    
    @Published var addOurEdit = 0 {
        didSet {
            if addOurEdit == 0 {
                title = ""
                console = ""
                date = Date()
                imageCover = nil
                imageConsole = nil
            }
        }
    }
    
    @Published var tempConsole: FetchedResults<Console>.Element?
    @Published var tempGame: FetchedResults<Game>.Element?
    
}
