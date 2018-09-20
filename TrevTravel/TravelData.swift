//
//  TravelData.swift
//  TrevTravel
//
//  Created by Song Liu on 2018-09-20.
//  Copyright © 2018 Song Liu. All rights reserved.
//

import UIKit


class TravelData {
    struct Content {
        var image = ""
        var text = ""
        var isCoverImg = ""
        var map = ""
    }
    struct TravelInfo {
        var title = ""
        var coverImg = ""
        var shortText = ""
        var author = ""
        var createdAt = ""
        var changedAt = ""
        var contentArray:[Content] = []
    }
    
    var travelArray:[TravelInfo] = []
    var contentArray:[Content] = []
    
    init() {
        var newNote = TravelInfo()
        newNote.title = "Drottningholm"
        newNote.coverImg = "Drottningholm"
        newNote.shortText = "The Drottningholm Palace (Swedish: Drottningholms slott) is the private residence of the Swedish royal family. It is located in Drottningholm."
        newNote.author = "Yangshan"
        newNote.createdAt = "2018-09-17 17:38:57"
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        
        newNote.title = "Stadshuset"
        newNote.coverImg = "Stadshuset"
        newNote.shortText = "The Stockholm City Hall is the building of the Municipal Council for the City of Stockholm in Sweden. It stands on the eastern tip of Kungsholmen island, next to Riddarfjärden's northern shore and facing the islands of Riddarholmen and Södermalm"
        newNote.author = "Yangshan"
        newNote.createdAt = "2018-09-17 18:38:57"
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
    }
    
    func addContent(){
        
    }
}

