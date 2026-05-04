//
//  CustomTableViewCell.swift
//  CustomNibFileLab_Day2
//
//  Created by Bayoumi on 04/05/2026.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet private weak var cardLabel: UILabel!
    @IBOutlet private weak var cardImageView: UIImageView!
    
    static let identifier = "CustomTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        // Reset before reuse
        cardLabel.text = nil
        cardImageView.image = nil
    }
    private func setupUI(){
        cardImageView.layer.cornerRadius = 24
        cardImageView.clipsToBounds = true
        cardImageView.contentMode = .scaleAspectFit
    }
    
    func configure(name :String , image: UIImage?){
        cardLabel.text = name
        cardImageView.image = image ?? UIImage(systemName: "person.circle")
    }
    
}
