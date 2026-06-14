//
//  AmountInputView.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 14.06.2026.
//

import UIKit

final class AmountInputView: UIView {
    var amount: Double = 0 {
        didSet { updateLabel() }
    }
    
    var onAmountChanged: ((Double) -> Void)?
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold(52)
        label.textAlignment = .center
        label.textColor = AppColors.textPrimary
        label.text = "0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.medium(20)
        label.textColor = AppColors.textSecondary
        label.text = "UAH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .decimalPad
        tf.isHidden = true
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        addSubview(amountLabel)
        addSubview(currencyLabel)
        addSubview(hiddenTextField)
        
        hiddenTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            currencyLabel.topAnchor.constraint(equalTo: topAnchor),
            currencyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: AppConstants.Padding.xs),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConstants.Padding.md),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.Padding.md),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        hiddenTextField.becomeFirstResponder()
        return true
    }
    
    @objc private func textChanged() {
        let text = hiddenTextField.text ?? ""
        amount = Double(text) ?? 0
        onAmountChanged?(amount)
        updateLabel()
    }
    
    private func updateLabel() {
        amountLabel.text = String(format: "%.2f", amount)
    }
}
