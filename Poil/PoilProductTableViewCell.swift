//
//  PoilProductTableViewCell.swift
//  Poil
//
//  Created by Ondrej Mekota on 18.06.16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import UIKit

class PoilProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productLabel: UILabel!
    
    
    
    var product:Product? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI() {
        productImage?.image = nil
        productLabel?.text = nil
        
        
        if let product = self.product{
            productLabel?.text = product.name
            productLabel?.textColor = Bool(product.palm) ? UIColor(red: 0.53, green: 0, blue: 0, alpha: 1.0 ) : UIColor(red: 0, green: 0.53, blue: 0.0, alpha: 1.0 )
            //productImage?.layer.cornerRadius = 5.0
            productImage?.contentMode = UIViewContentMode.ScaleAspectFill
            productImage?.image = UIImage(data: product.imagePath!) //?? chybi obrazek
            
        }
    }
}
