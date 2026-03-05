//
//  MultiSelectDropdownView.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 04/02/26.
//


import UIKit

final class MultiSelectDropdownView: UIView {

    // MARK: - UI
    private let tableView = UITableView()
    private let closeButton = UIButton(type: .system)
    private let containerView = UIView()

    // MARK: - Data
    private var items: [String] = []
    private(set) var selectedIndexes = Set<Int>()

    var onSelectionChanged: ((Set<Int>) -> Void)?
    var onClose: (() -> Void)?
    private let rowHeight: CGFloat = 48
    private let headerHeight: CGFloat = 48
    private let maxDropdownHeightRatio: CGFloat = 0.65

    // MARK: - Init
    init(items: [String], selectedIndexes: Set<Int>) {
        self.items = items
        self.selectedIndexes = selectedIndexes
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        addSubview(containerView)

        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerCellFromNib(cellID: "DropDownCheckboxCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = rowHeight
        containerView.addSubview(closeButton)
        containerView.addSubview(tableView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let contentHeight =
            headerHeight + (CGFloat(items.count) * rowHeight)

        let maxHeight = bounds.height * maxDropdownHeightRatio
        let finalHeight = min(contentHeight, maxHeight)

        let width = bounds.width - 40

        containerView.frame = CGRect(
            x: 20,
            y: (bounds.height - finalHeight) / 2,
            width: width,
            height: finalHeight
        )

        closeButton.frame = CGRect(
            x: containerView.bounds.width - 80,
            y: 8,
            width: 70,
            height: 32
        )

        tableView.frame = CGRect(
            x: 0,
            y: headerHeight,
            width: containerView.bounds.width,
            height: containerView.bounds.height - headerHeight
        )

        tableView.isScrollEnabled = contentHeight > maxHeight
    }


    // MARK: - Actions
    @objc private func closeTapped() {
        onClose?()
        removeFromSuperview()
    }
}

// MARK: - TABLE VIEW METHODS
extension MultiSelectDropdownView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCheckboxCell", for: indexPath) as! DropDownCheckboxCell
        cell.titleLabel?.text = items[indexPath.row]
        let isSelected = selectedIndexes.contains(indexPath.row)
        cell.checkboxImageView?.image = isSelected
            ? .selectedCheckBox
            : .unslectedCheckbox

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let index = indexPath.row
        let allItemIndexes = Set(1..<items.count)

        if index == 0 {
            // User tapped "Select All"
            if selectedIndexes.contains(0) {
                // Unselect everything
                selectedIndexes.removeAll()
            } else {
                // Select all INCLUDING index 0
                selectedIndexes = allItemIndexes
                selectedIndexes.insert(0)
            }
        } else {
            // User tapped a normal item
            if selectedIndexes.contains(index) {
                selectedIndexes.remove(index)
            } else {
                selectedIndexes.insert(index)
            }

            // Sync Select All state
            if allItemIndexes.isSubset(of: selectedIndexes) {
                selectedIndexes.insert(0)
            } else {
                selectedIndexes.remove(0)
            }
        }

        tableView.reloadData()
        onSelectionChanged?(selectedIndexes)
    }

}
