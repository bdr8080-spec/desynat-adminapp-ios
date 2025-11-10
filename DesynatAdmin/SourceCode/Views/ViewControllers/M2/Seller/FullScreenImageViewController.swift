//
//  FullScreenImageViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imgPreview: UIImageView!
    private var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
     
    }
    private func setUpUi() {
        self.imgPreview.image = image
    }
    func setImage(_ image:UIImage?) {
        self.image = image
    }

    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
