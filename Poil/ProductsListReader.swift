//
//  ProductsListReader.swift
//  Poil
//
//  Created by Ondrej Mekota on 24/06/16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import Foundation

class ProductsListReader: NSObject {
    private static var retrievedNames: [String] = []
    
    class func retrieveNames(fromDocument docName:NSURL) -> Array<String>{
        do{
            retrievedNames.removeAll()
            let content = try String(contentsOfURL: docName)
            let lines = content.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "\n"))
            for var line in lines{
                line = String(line.characters.dropFirst())
                line = String(line.characters.dropLast(2))
                
                //TODO: udělat uppercase prvního slova
                retrievedNames.append(line)
            }
            return retrievedNames
            
        } catch _ {
            print("chyba")
            return []
        }
    }
    
    
    
    
    
}