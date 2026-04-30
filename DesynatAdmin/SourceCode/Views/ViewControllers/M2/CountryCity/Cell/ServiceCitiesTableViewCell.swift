//
//  ServiceCitiesTableViewCell.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import UIKit

class ServiceCitiesTableViewCell: ResuableTableCell {
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var btnViewZone: CustomButtonFont!
    @IBOutlet weak var lblCity: UILabel!
    var data:CitiesInfo?
    var zoneData:ZoneInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
    }
    private func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnViewZone.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 6)
        }
    }
    func setCity(_ data:CitiesInfo)  {
        self.data = data
        self.btnEdit.isHidden = true
        self.lblCity.text = data.name
        self.btnViewZone.setTitle("View zone".localiz(), for: .normal)
        self.btnSwitch.setImage(data.isActive ? .toggleOn : .toggleOff, for: .normal)
    }
    
    func setZone(_ data:ZoneInfo)  {
        self.zoneData = data
        self.btnEdit.isHidden = false
        self.lblCity.text = data.nameEn
        self.btnViewZone.setTitle("View".localiz(), for: .normal)
        self.btnSwitch.setImage(data.isActive ? .toggleOn : .toggleOff, for: .normal)
    }
    
    @IBAction func handleEdit(_ sender: Any) {
        self.zoneData?.edit()
    }
    
    @IBAction func handleView(_ sender: Any) {
        if let data  {
            data.view()
        } else if let zoneData  {
            zoneData.view()
        }
    }
    @IBAction func handleSwitch(_ sender: Any) {
        if var data = self.data  {
            data.isActive = !data.isActive
            data.setActive()
            self.btnSwitch.setImage(data.isActive ? .toggleOn : .toggleOff, for: .normal)
        } else if var zoneData = self.zoneData  {
            zoneData.isActive = !zoneData.isActive
            zoneData.setActive()
            self.btnSwitch.setImage(zoneData.isActive ? .toggleOn : .toggleOff, for: .normal)
        }
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        if let data  {
            data.delete()
        } else if let zoneData  {
            zoneData.delete()
        }
    }
    
}
