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
    
    //  MARK: - View Components
    let contentStack = Components.createStackView(axis: .vertical, spacing: space2)
    let amountsStack = Components.createStackView(axis: .horizontal, distribution: .fill)
    let progressStack = Components.createStackView(axis: .vertical, spacing: space2)
    let nameLabel = Components.titleLabel()
    var currentAmmountLabel = Components.baseLabel()
    var targetAmmountLabel = Components.baseLabel()
    let progressBar = Components.progressBar()
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
        contentStack.addArrangedSubview(nameLabel)
        amountsStack.addArrangedSubview(currentAmmountLabel)
        amountsStack.addArrangedSubview(targetAmmountLabel)
        progressStack.addArrangedSubview(amountsStack)
        progressStack.addArrangedSubview(progressBar)
        contentStack.addArrangedSubview(progressStack)

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
    public func bind(_ item: SavingsGoalViewModel, hidesDivider: Bool = false) {
        nameLabel.text = item.name
        currentAmmountLabel.text = item.displayedCurrentAmount
        targetAmmountLabel.text = item.displayedTarget
        progressBar.progress = item.displayedProgress
    }
}
