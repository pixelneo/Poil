//
//  Product+CoreDataProperties.swift
//  Poil
//
//  Created by Ondrej Mekota on 28/06/16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var imagePath: NSData?
    @NSManaged var name: String?
    @NSManaged var palm: NSNumber

}
