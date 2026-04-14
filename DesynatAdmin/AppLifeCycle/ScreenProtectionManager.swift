//
//  ScreenProtectionManager.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//


import UIKit

final class SecureView: UIView {

    private let secureTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSecureLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSecureLayer()
    }

    private func setupSecureLayer() {
        secureTextField.isSecureTextEntry = true
        secureTextField.isUserInteractionEnabled = false
        secureTextField.backgroundColor = .clear
        
        addSubview(secureTextField)
        secureTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secureTextField.topAnchor.constraint(equalTo: topAnchor),
            secureTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            secureTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            secureTextField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func wrap(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}


class BaseViewController: UIViewController {

    private var isSecureApplied = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applySecurity()
    }

    private func applySecurity() {
        guard !isSecureApplied else { return }
        isSecureApplied = true
        
        let secureView = SecureView(frame: view.bounds)
        secureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Move all existing content into secure container
        let contentView = UIView(frame: view.bounds)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        while let subview = view.subviews.first {
            contentView.addSubview(subview)
        }

        secureView.wrap(view: contentView)
        view.addSubview(secureView)
    }
}
