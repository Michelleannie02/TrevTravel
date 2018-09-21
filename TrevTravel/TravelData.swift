//
//  TravelData.swift
//  TrevTravel
//
//  Created by Yangshan Liu on 2018-09-17.
//  Copyright © 2018 TrevTravel. All rights reserved.
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
        var likes = ""
        var place = ""
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
        newNote.likes = "3"
        newNote.place = "Drottningholm 22"
        newNote.author = "Yangshan"
        newNote.createdAt = "2018-09-17"
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        
        newNote.title = "Stadshuset"
        newNote.coverImg = "Stadshuset"
        newNote.shortText = "The Stockholm City Hall is the building of the Municipal Council for the City of Stockholm in Sweden. It stands on the eastern tip of Kungsholmen island, next to Riddarfjärden's northern shore and facing the islands of Riddarholmen and Södermalm"
        newNote.likes = "1"
        newNote.place = "Vasagatan 22"
        newNote.author = "Yangshan"
        newNote.createdAt = "2018-09-17"
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
        travelArray.append(newNote)
    }
    
    func addContent(){
    
    }
}
