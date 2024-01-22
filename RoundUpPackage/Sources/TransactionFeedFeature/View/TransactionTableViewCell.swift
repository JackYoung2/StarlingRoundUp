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
    
    //  MARK: - View Components
    let contentStack = Components.createStackView(axis: .horizontal, spacing: space2)
    let leftStack = Components.createStackView(axis: .vertical, spacing: space2)
    let rightStack = Components.createStackView(axis: .vertical, spacing: space2)
    let priceLabel = Components.baseLabel()
    let roundLabel = Components.baseLabel()
    let merchantLabel = Components.baseLabel()
    let dateLabel = Components.detailLabel()
    let divider = Components.createDivider()
    
    //  MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //  MARK: - setUpView
    func setUpView() {
        self.selectionStyle = .none
        roundLabel.textColor = ColorSystem.tint
        rightStack.addArrangedSubview(priceLabel)
        rightStack.addArrangedSubview(roundLabel)
        rightStack.alignment = .trailing
        leftStack.addArrangedSubview(merchantLabel)
        leftStack.addArrangedSubview(dateLabel)
        contentStack.addArrangedSubview(leftStack)
        contentStack.addArrangedSubview(rightStack)
        contentView.addSubview(contentStack)
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: space5),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -space5),
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: space3),
            
            divider.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: space5),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    //  MARK: - Bind ViewModel
    
    public func bind(_ item: TransactionViewModel, hidesDivider: Bool = false) {
        roundLabel.text = item.roundedUpDisplay
        priceLabel.text = item.transactionDisplay
        merchantLabel.text = item.transaction.counterPartyName
        dateLabel.text = item.timeDisplay
        divider.isHidden = hidesDivider
    }
}
