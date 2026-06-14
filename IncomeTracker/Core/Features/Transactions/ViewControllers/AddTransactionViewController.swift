//
//  AddTransactionViewController.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 14.06.2026.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    // MARK: - Properties
    
    var onSave: (() -> Void)?
    var editingTransaction: TransactionModel?
    
    private var selectedType: TransactionType = .expense {
        didSet { reloadCategories() }
    }
    private var selectedCategory: CategoryModel?
    private var categories: [CategoryModel] = []
    
    //MARK: - UI
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = AppConstants.Padding.lg
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Income", "Expense"])
        sc.selectedSegmentIndex = 1
        sc.selectedSegmentTintColor = AppColors.expense
        return sc
    }()
    
    private let amountView = AmountInputView()
    
    private lazy var categoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 72, height: 88)
        layout.minimumLineSpacing = AppConstants.Padding.sm
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.heightAnchor.constraint(equalToConstant: 96).isActive = true
        return cv
    }()
    
    private let noteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add note..."
        tf.font = AppFonts.regular(16)
        tf.borderStyle = .none
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        dp.date = Date()
        return dp
    }()
    
    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.cornerStyle = .large
        config.baseBackgroundColor = AppColors.accent
        config.baseForegroundColor = .white
        
        let btn = UIButton(configuration: config)
        btn.heightAnchor.constraint(equalToConstant: 54).isActive = true
        btn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = editingTransaction == nil ? "Add transaction" : "Edit transaction"
        setupNavBar()
        setupLayout()
        setupActions()
        reloadCategories()
        fillIfEditing()
    }
    
    // MARK: - Setup
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        [
            segmentControl,
            makeSectionCard(title: "Amount", content: amountView),
            makeSectionCard(title: "Category", content: categoryCollection),
            makeSectionCard(title: "Note", content: noteTextField),
            makeSectionCard(title: "Date", content: datePicker),
            saveButton
        ].forEach { contentStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppConstants.Padding.md),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: AppConstants.Padding.md),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -AppConstants.Padding.md),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -AppConstants.Padding.xl),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -AppConstants.Padding.md * 2)
        ])
    }
    
    private func setupActions() {
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
}

// MARK: - Helpers
private extension AddTransactionViewController {
    func makeSectionCard(title: String, content: UIView) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColors.card
        container.layer.cornerRadius = AppConstants.CornerRadius.card
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = AppFonts.semibold(13)
        titleLabel.textColor = AppColors.textSecondary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        content.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(content)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: AppConstants.Padding.md),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: AppConstants.Padding.md),
            
            content.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppConstants.Padding.sm),
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: AppConstants.Padding.md),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -AppConstants.Padding.md),
            content.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppConstants.Padding.md)
        ])
        
        return container
    }
    
    func reloadCategories() {
        categories = CoreDataManager.shared.fetchCategories(type: selectedType)
        selectedCategory = nil
        categoryCollection.reloadData()
        
        let color = selectedType == .income ? AppColors.income : AppColors.expense
        segmentControl.selectedSegmentTintColor = color
        saveButton.configuration?.baseBackgroundColor = color
    }
    
    func fillIfEditing() {
        guard let t = editingTransaction else { return }
        amountView.amount = t.amount
        noteTextField.text = t.note
        datePicker.date = t.date
        segmentControl.selectedSegmentIndex = t.type == .income ? 0 : 1
        selectedType = t.type
        
        if let index = categories.firstIndex(where: { $0.id == t.categoryId }) {
            categoryCollection.selectItem(at: IndexPath(item: index,section: 0), animated: false, scrollPosition: .left)
            selectedCategory = categories[index]
        }
    }
}

private extension AddTransactionViewController {
    @objc func segmentChanged() {
        selectedType = segmentControl.selectedSegmentIndex == 0 ? .income : .expense
    }
    
    @objc func saveTapped() {
        guard amountView.amount > 0 else {
            showError("Please enter an amount")
            return 
        }
        
        guard let category = selectedCategory else {
            showError("Please select a category")
            return
        }
        
        if let existing = editingTransaction {
            let updated = TransactionModel(
                id: existing.id,
                amount: amountView.amount,
                type: selectedType,
                note: noteTextField.text ?? "",
                date: datePicker.date,
                createdAt: existing.createdAt,
                categoryId: category.id
            )
            CoreDataManager.shared.updateTransaction(updated)
        } else {
            let new = TransactionModel(
                id: UUID(),
                amount: amountView.amount,
                type: selectedType,
                note: noteTextField.text ?? "",
                date: datePicker.date,
                createdAt: Date(),
                categoryId: category.id
            )
            CoreDataManager.shared.createTransaction(new)
        }
        
        onSave?()
        dismiss(animated: true)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddTransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.configure(with: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
    }
}
