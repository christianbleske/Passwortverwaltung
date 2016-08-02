//
//  Passwort.swift
//  Passwortverwaltung
//
//  Created by Christian Bleske on 02.12.14.
//  Copyright (c) 2014 Christian Bleske. All rights reserved.
//

import Foundation
import CoreData

/*class Passwort {
    
    var passwort: String=""
    var name: String=""
    var bemerkung: String=""
    
}*/

class Passwort: NSManagedObject {
    
    @NSManaged var passwort: String
    @NSManaged var name: String
    @NSManaged var bemerkung: String
    
}


