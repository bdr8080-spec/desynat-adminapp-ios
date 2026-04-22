//
//  ChatInboxViewController.swift
//  DesynatAdmin
//
//  Created by  shailendra singh on 27/03/26.
//

import UIKit

class ChatInboxViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var customerButton: CustomButton!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var sellerButton: CustomButton!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var driverButton: CustomButton!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var txtFieldSearch: BindableTextField!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.registerCellFromNib(cellID: "ChatInboxTableViewCell")
        }
    }
    
    // MARK: - Variable
    var selectedType: ChatType = .customer
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCustomerAction()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func customerDidTapped(_ sender: Any) {
        handleCustomerAction()
    }
    
    @IBAction func sellerDidTapped(_ sender: Any) {
        handleSellerAction()
    }
    
    @IBAction func driverdDidTapped(_ sender: Any) {
        handlDriverAction()
    }
    
    private func handleSellerAction() {
        customerButton.setImage(UIImage(named: ""), for: .normal)
        customerButton.layer.cornerRadius = 0
        customerLabel.textColor = UIColor.black
        sellerButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        sellerButton.layer.cornerRadius = 0
        sellerLabel.textColor = UIColor.white
        driverButton.setImage(UIImage(named: ""), for: .normal)
        driverButton.layer.cornerRadius = 0
        driverLabel.textColor = UIColor.black
        selectedType = .customer
        txtFieldSearch.text = ""
//        viewModel.changeTab(.approved)
    }
    
    private func handlDriverAction() {
        customerButton.setImage(UIImage(named: ""), for: .normal)
        customerButton.layer.cornerRadius = 0
        customerLabel.textColor = UIColor.black
        sellerButton.setImage(UIImage(named: ""), for: .normal)
        sellerLabel.textColor = UIColor.black
        sellerButton.layer.cornerRadius = 0
        driverButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        driverLabel.textColor = UIColor.white
        driverButton.layer.cornerRadius = 5
        driverButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        driverButton.clipsToBounds = true
        selectedType = .seller
        txtFieldSearch.text = ""
//        viewModel.changeTab(.reject)
    }
    
    private func handleCustomerAction() {
        customerButton.setImage(UIImage(named: "topTabbar"), for: .normal)
        customerButton.layer.cornerRadius = 5
        customerButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        customerButton.clipsToBounds = true
        customerLabel.textColor = UIColor.white
        sellerButton.setImage(UIImage(named: ""), for: .normal)
        sellerButton.layer.cornerRadius = 0
        sellerLabel.textColor = UIColor.black
        driverButton.setImage(UIImage(named: ""), for: .normal)
        driverButton.layer.cornerRadius = 0
        driverLabel.textColor = UIColor.black
        selectedType = .driver
        txtFieldSearch.text = ""
//        viewModel.changeTab(.new)
    }
}

extension ChatInboxViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInboxTableViewCell", for: indexPath) as! ChatInboxTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController.instantiate(fromAppStoryboard: .NotificationCMS)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
enum ChatType {
    case customer
    case seller
    case driver
}

