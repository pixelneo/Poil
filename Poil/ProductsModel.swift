//
//  ProductsModel.swift
//  Poil
//
//  Created by Ondrej Mekota on 18.06.16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import Foundation
import CoreData

class ProductsModel: NSObject {
    
    private static let docDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    
    private class func fileInDocumentsPath(fileName:String)-> NSURL?{
        
        return self.docDir?.URLByAppendingPathComponent(fileName)
    }
    
    private class func getProductNamesFromCSV(fileName: String) -> [String]{
        if let file = ProductsModel.fileInDocumentsPath(fileName){
            let productNames = ProductsListReader.retrieveNames(fromDocument: file)
            
            return productNames
        }
        return []
    }
    
    class func getProductList() ->[Product]{
        let namesWithoutPalmOil = getProductNamesFromCSV("list_no_palm.csv")
        let namesWithPalmOil = getProductNamesFromCSV("list_palm.csv")
        var products:[Product] = []
    
        //bez palmového oleje
        for index in Range(0..<namesWithoutPalmOil.count-1){
            products.append(Product(name: namesWithoutPalmOil[index], imagePath: getPicturePathForProduct(withId: index, withPalmOil: false), palm: false))
        }
        
        //s palmovým olejem
        for index in Range(0..<namesWithPalmOil.count-1){
            products.append(Product(name: namesWithPalmOil[index], imagePath: getPicturePathForProduct(withId: index, withPalmOil: true), palm: true))
        }
        
        return products
    }
    
    private class func getPicturePathForProduct(withId id:Int, withPalmOil palm: Bool) -> NSData{
        
        let dir = palm ? "images/s_"+String(id)+".jpg" : "images/bez_"+String(id)+".jpg"
        let imagePath = docDir?.URLByAppendingPathComponent(dir)
        
        let image = NSData(contentsOfFile: imagePath!.path!)
        return image!
    }
    
    struct Product {
        var name:String
        var imagePath:NSData
        var palm:Bool
    }
}