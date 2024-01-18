//
//  SavingsGoalTableViewCell.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Views
import Common
import SharedModel
import SavingsGoalFeature

public class SavingsGoalTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    let nameLabel = Components.titleLabel()
    var currentAmmountLabel = Components.baseLabel()
    var targetAmmountLabel = Components.baseLabel()
    
    let progressStack = Components.createStackView(.vertical, space2)
    let metaStack = Components.createStackView(.vertical, space2)
    let divider = Components.createDivider()
    let progressBar = Components.progressBar()
    
    func setUpView() {
        self.selectionStyle = .none
        metaStack.addArrangedSubview(nameLabel)
        
        
        let amountsStack = Components.createStackView(.horizontal)
        amountsStack.addArrangedSubview(targetAmmountLabel)
        amountsStack.addArrangedSubview(currentAmmountLabel)
        
        progressStack.addArrangedSubview(amountsStack)
        progressStack.addArrangedSubview(progressBar)
        
        metaStack.addArrangedSubview(progressStack)

        contentView.addSubview(metaStack)
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            metaStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: space5),
            metaStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -space5),
            metaStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space3),
//            metaStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -space3),
//
//            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -space5),
//            rightStack.topAnchor.constraint(equalTo: leftStack.topAnchor, constant: space3),
            
            divider.topAnchor.constraint(equalTo: metaStack.bottomAnchor, constant: space5),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])

    }
    
    public func bind(_ item: SavingsGoalViewModel, hidesDivider: Bool = false) {
        nameLabel.text = item.name
        currentAmmountLabel.text = item.displayedCurrentAmount
        targetAmmountLabel.text = item.displayedTarget
        
        progressBar.progress = item.displayedProgress
        
    }
}
