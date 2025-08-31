//
//  ResearchCell.swift
//  Calculadora
//
//  Created by Nicholas Forte on 30/08/25.
//

import Foundation
import UIKit

protocol ResearcherCellProtocol {
    func addInfo(_ info: ResearchItem)
}

final class ResearcherCell: UITableViewCell {
    static let reuseId = "ResearcherCell"
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        descLabel.font = .preferredFont(forTextStyle: .subheadline)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with item: ResearchItem) {

    }
}

extension ResearcherCell: ResearcherCellProtocol {
    func addInfo(_ info: ResearchItem) {
        titleLabel.text = info.title
        descLabel.text = info.description
    }
}
