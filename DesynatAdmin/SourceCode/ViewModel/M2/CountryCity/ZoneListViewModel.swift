//
//  ZoneViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import Foundation
class ZoneViewModel {
    private(set) var searchText : String = ""
    private var searchTimer : Timer?
    var cityInfo:CitiesInfo?
    private(set) var refresHandler : HandleTableRefresh?
    private var zoneActionHandler:HandleZoneAction?
    private(set) var arrayZone : [ZoneInfo] = []
    
    func setCity(_ data:CitiesInfo)  {
        self.cityInfo = data
    }
    func setRefreshHandler(_ handler:HandleTableRefresh,zoneActionHandler:HandleZoneAction)  {
        refresHandler = handler
        self.zoneActionHandler = zoneActionHandler
    }
    
    func setSearch(_ string:String)  {
        if (searchTimer != nil) {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        self.searchText = string
        self.searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleSearch(_:)), userInfo: nil, repeats: false)
    }
    
    @objc func handleSearch(_ sender:Timer) {
        self.getZones()
    }
    
    func getZones() {

        var paramter : [String:Any] = [
            APIKeys.city_id:String.getString(cityInfo?.id),
            APIKeys.country_id:String.getString(cityInfo?.countryId),
        ]
        if (!searchText.isEmpty) {
            paramter[APIKeys.search] = searchText
        }
        WebService.sharedInstance.getZones(parameter: paramter) { cityModel in
            self.arrayZone = (cityModel.data ?? []).map({ZoneInfo.makeData($0, handler: self.zoneActionHandler)})
            self.refresHandler?.refreshTable(for: "")
        }
    }
    
    func deleteZone(id:String,_ completion:@escaping () -> Void) {
        WebService.shared.deleteZone(zoneId: id) { data in
            completion()
        }
    }
    func changeZoneStatus(id:String,_ completion:@escaping () -> Void) {
        WebService.shared.changeZoneStatus(zoneID: id) { data in
            completion()
        }
    }
}
