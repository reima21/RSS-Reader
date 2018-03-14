//
//  FeedTableViewCell.swift
//  0321
//
//  Created by 松平 礼史 on 2017/03/21.
//  Copyright © 2017年 松平礼史. All rights reserved.
//

import UIKit
@IBDesignable
class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // XIB読み込み
        //let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell
        //addSubview(cell)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
