//
//  TransactionTableViewCell.swift
//
//
//  Created by Jack Young on 11/01/2024.
//

import UIKit
import SharedModel
import Common
import Views

public class TransactionTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    let priceLabel = Components.baseLabel()
    let roundLabel = Components.baseLabel()
    let merchantLabel = Components.baseLabel()
    let dateLabel = Components.detailLabel()
    
    let leftStack = Components.createStackView(.vertical, space2)
    let rightStack = Components.createStackView(.vertical, space2)
    let metaStack = Components.createStackView(.horizontal, space2)
    
    let divider = Components.createDivider()
    
    func setUpView() {
        
        self.selectionStyle = .none
        roundLabel.textColor = .green
        rightStack.addArrangedSubview(priceLabel)
        rightStack.addArrangedSubview(roundLabel)
        
        rightStack.alignment = .trailing
        leftStack.addArrangedSubview(merchantLabel)
        leftStack.addArrangedSubview(dateLabel)
        
        metaStack.addArrangedSubview(leftStack)
        metaStack.addArrangedSubview(rightStack)

        
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
    
    public func bind(_ item: TransactionViewModel, hidesDivider: Bool = false) {
        roundLabel.text = item.roundedUpDisplay
        priceLabel.text = item.transactionDisplay
        merchantLabel.text = item.transaction.counterPartyName
        dateLabel.text = item.timeDisplay
        divider.isHidden = hidesDivider
    }
}
