//
//  FullScreenImageViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var imgPreview: UIImageView!
    
    // MARK: - Property Decalaration
    private var image : UIImage?
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
    }
    
    // MARK: - Button's Action
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function's declaration
    private func setUpUi() {
        self.imgPreview.image = image
    }
    
    func setImage(_ image:UIImage?) {
        self.image = image
    }
    
}
