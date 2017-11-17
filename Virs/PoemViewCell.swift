//
//  PoemViewCell.swift
//  Virs
//
//  Created by Greg Heggie on 11/14/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import UIKit

class PoemViewCell: UITableViewCell {

    @IBOutlet weak var poetView: UIImageView!
    @IBOutlet weak var snapLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var poemPreviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.poetView.layer.cornerRadius = self.poetView.frame.size.width / 2
        self.poetView.clipsToBounds = true
        self.poetView.layer.borderWidth = 1.5
        self.poetView.layer.borderColor = UIColor.init(red: 185/255, green: 159/255, blue: 216/255, alpha: 1).cgColor
        poetView.contentMode = UIViewContentMode.scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
