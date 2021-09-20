//
//  ViewController.swift
//  RemoteImage
//
//  Created by iBamboola on 07/19/2021.
//  Copyright (c) 2021 iBamboola. All rights reserved.
//

import UIKit
import RemoteImage

class ViewController: UIViewController {
    
    private var buttonWithURL: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("correct", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var buttonWithUncorrectURL: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("uncorrect", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var buttonWithNil: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("nil", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        return imageView
    }()
    
    private var imageProcessor: RoundCornerImageProcessor? {
        RoundCornerImageProcessor(targetSize: imageView.frame.size, cornerRadius: 20)
    }
    
    private let httpAdressForImageAsString = "https://i.ytimg.com/vi/1Ne1hqOXKKI/maxresdefault.jpg"
    
    private let placeholderImage = UIImage(systemName: "photo.fill.on.rectangle.fill")
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .medium)

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        view.addSubview(imageView)
        setConstraintsForImageView()
        
        let imageUrl = URL(string: httpAdressForImageAsString)!
        DispatchQueue.main.async {
            self.imageView.setImage(with: imageUrl,
                                    placeholder: self.placeholderImage,
                                    loadingIndicator: self.activityIndicator,
                                    imageProcessor: self.imageProcessor)
        }

        let stack = createStackViewWithButtons()
        view.addSubview(stack)
        setConstraintsFor(stack: stack)
    }
    
    private func setConstraintsForImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 17),
            imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -17)
        ])
    }
    
    private func createStackViewWithButtons() -> UIStackView {
        let stack = UIStackView(frame: .zero)
        stack.alignment     = .fill
        stack.axis          = .horizontal
        stack.distribution  = .equalSpacing
        
        stack.backgroundColor = .clear
        
        addActionsToButtons()
        
        stack.addArrangedSubview(buttonWithURL)
        stack.addArrangedSubview(buttonWithUncorrectURL)
        stack.addArrangedSubview(buttonWithNil)
        
        return stack
    }
    
    private func setConstraintsFor(stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.heightAnchor.constraint(equalToConstant: 50),
            stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -100)
        ])
    }
    
    private func addActionsToButtons() {
        buttonWithURL.addTarget(self, action: #selector(correctURLPressed), for: .touchUpInside)
        buttonWithUncorrectURL.addTarget(self, action: #selector(uncorrectURLPressed), for: .touchUpInside)
        buttonWithNil.addTarget(self, action: #selector(nilPressed), for: .touchUpInside)
    }
    
    @objc private func correctURLPressed() {
        let imageUrl = URL(string: httpAdressForImageAsString)!
        DispatchQueue.main.async {
            self.imageView.setImage(with: imageUrl,
                                    placeholder: self.placeholderImage,
                                    loadingIndicator: self.activityIndicator,
                                    imageProcessor: self.imageProcessor)
        }
    }
    
    @objc private func uncorrectURLPressed() {
        let imageUrl = URL(string: "h")!
        DispatchQueue.main.async {
            self.imageView.setImage(with: imageUrl,
                                    placeholder: self.placeholderImage,
                                    loadingIndicator: self.activityIndicator,
                                    imageProcessor: self.imageProcessor)
        }
    }
    
    @objc private func nilPressed() {
        let imageUrl: URL? = nil
        DispatchQueue.main.async {
            self.imageView.setImage(with: imageUrl,
                                    placeholder: self.placeholderImage,
                                    loadingIndicator: self.activityIndicator)
        }
    }
    
}

extension UIActivityIndicatorView: LoadingIndicator {
    public func startLoading() {
        startAnimating()
        print("Starting download...")
    }
    
    public func stopLoading() {
        stopAnimating()
        print("Stopping download...")
    }
    
    
}
