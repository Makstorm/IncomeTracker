//
//  CategoryCell.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 14.06.2026.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let iconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconLabel: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular(11)
        label.textAlignment = .center
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet { updateSelection() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        iconView.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),
            
            iconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 28),
            iconLabel.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with category: CategoryModel) {
        nameLabel.text = category.name
        iconLabel.image = UIImage(systemName: category.icon)
        iconView.backgroundColor = UIColor(hex: category.colorHex)
    }
    
    private func updateSelection() {
        UIView.animate(withDuration: 0.2) {
            self.iconView.transform = self.isSelected ? CGAffineTransform(scaleX: 1.15, y: 1.15) : .identity
            self.iconView.layer.borderWidth = self.isSelected ? 3 : 0
            self.iconView.layer.borderColor = AppColors.accent.cgColor
            self.nameLabel.textColor = self.isSelected ? AppColors.accent : AppColors.textSecondary
        }
    }
}
