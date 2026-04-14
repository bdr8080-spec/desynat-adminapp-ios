//
//  AddZoneViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
import CoreLocation
class AddZoneViewModel {
    private(set) var data : ZoneInfo = ZoneInfo()
    private(set) var cityInfo : CitiesInfo?
    private(set) var isForEdit : Bool = false
    
    func setInitial(_ data:ZoneInfo,isForEdit:Bool = false)  {
        self.data = data
        self.isForEdit = isForEdit
    }
    func setCityInfo(_ cityInfo:CitiesInfo) {
        self.data.countryId = cityInfo.countryId
        self.data.parentCityId = cityInfo.id
        self.cityInfo = cityInfo
    }
    
    func setEnglishName(_ string:String) {
        self.data.nameEn = string
    }
    func setArabicName(_ string:String) {
        self.data.nameAr = string
    }
    
    func setLocation(_ location:CLLocationCoordinate2D) {
        self.data.coordinates.append(location)
    }
    func undoLPath() -> Bool {
        if data.coordinates.count > 0 {
            self.data.coordinates.removeLast()
            return true
        }
        return false
    }
    
    func addZone(_ completion:@escaping () -> Void) {
        var paramter:[String:Any] = data.paramter
        if (self.isForEdit) {
            paramter[APIKeys.zone_id] = self.data.id
        }
        if self.isForEdit {
            WebService.sharedInstance.updateZone(parameter: paramter) { dat in
                completion()
            }
        } else {
            WebService.sharedInstance.addZone(parameter: paramter) { dat in
                completion()
            }
        }
        
    }
}
