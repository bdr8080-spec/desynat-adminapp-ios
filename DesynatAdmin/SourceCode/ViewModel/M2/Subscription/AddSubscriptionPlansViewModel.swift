//
//  AddSubscriptionPlansViewModel.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 10/11/25.
//

import Foundation
struct PlanInfo {
    
    var id:String = UUID().uuidString
    var country:GetCountryDataModel?
    var planNameEnglish:String = ""
    var planNameArabic:String = ""
    var duration:Double = 0.0
    var durationType:DurationType = .year
    var noOfVideos:Int = 0
    var noOfProducts:Int = 0
    var noOfHighlights:Int = 0
    var stories:Int = 0
    var noOfEmployee:Int = 0
    var isStoryOpen:Bool = false
    var isComission:Bool = false
    var price:Double = -0.1
    var comission:Double = 0.0
    var isActive:Bool = false
    var NewPrice:Double = -0.1
    var Newduration:Double = 0.0
    var NewdurationType:DurationType = .year
    var isFreeMonths: Bool = false
    var noOfFreeMonths: Int = 0
    var productType: Bool = false
    
    static func makeInfo(_ data:SubscriptionPlanDataModel) -> Self {
        PlanInfo(
            id: String.getString(data.id),
            country: data.countryInfo,
            planNameEnglish: String.getString(data.planNameEnglish),
            planNameArabic: String.getString(data.planNameArabic),
            duration: Double.getDouble(data.duration),
            durationType: DurationType(rawValue: Int.getInt(data.durationType)) ?? .none,
            noOfVideos: Int.getInt(data.noOfVideos),
            noOfProducts: Int.getInt(data.noOfProducts),
            noOfHighlights: Int.getInt(data.noOfHighlights),
            stories: Int.getInt(data.stories),
            noOfEmployee: Int.getInt(data.noOfEmployee),
            isStoryOpen:  Int.getInt(data.stories) == 1,
            isComission:   Int.getInt(data.commission) == 1,
            price: Double.getDouble(data.price),
            comission:   Double.getDouble(data.commissionPercentage),
            isActive:   Int.getInt(data.status) == 1,
            NewPrice: Double.getDouble(data.discountedPrice),
            Newduration: Double.getDouble(data.newduration),
            NewdurationType: DurationType(rawValue: Int.getInt(data.newdurationType)) ?? .none,
            isFreeMonths: Int.getInt(data.isFreeMonths) == 1,
            noOfFreeMonths: Int.getInt(data.noOfFreeMonths),
            productType: Int.getInt(data.productType) == 0

        )
    }
    func validateData(isForEdit: Bool = false) -> AlertConstant{
        if country == nil {
            return .selectCountry
        } else if planNameEnglish.trimmingCharacters(in: .whitespaces).isEmpty {
            return .enterEnglishPlanName
        } else if planNameArabic.trimmingCharacters(in: .whitespaces).isEmpty {
            return .enterArabicPlanName
        } else if duration <= 0.0 {
            return .enterPlanDuration
        }// ✅ NEW VALIDATION START
        if durationType == .month {
            if duration >= 12 {
                return .durationShouldLessThan12 // create this alert
            }
        } else if durationType == .year {
            if duration != 1 {
                return .durationShouldBeOneYear // create this alert
            }
        }
        
        if isForEdit {
            if Newduration <= 0.0 {
                        return .enterNewDuration
                    }
                    
                    if NewdurationType == .none {
                        return .selectNewDurationType
                    }
                    
            if NewPrice == -0.1 {
                        return .enterNewPrice
                    }
                    
                    // same rule apply for new duration
                    if NewdurationType == .month {
                        if Newduration >= 12 {
                            return .durationShouldLessThan12
                        }
                    } else if NewdurationType == .year {
                        if Newduration != 1 {
                            return .durationShouldBeOneYear
                        }
                    }
        }
        
        else if noOfVideos <= 0 {
            return .enterNoOfVideo
        } else if productType {
            if noOfProducts <= 0 {
                return .enterNoOfProduct
            }
        } else if noOfHighlights <= 0 {
            return .enterNoOfHighlights
        } else if noOfEmployee <= 0 {
            return .enterNoOfEmployee
            //        } else if price <= 0.0 {
            //            return .enterPlanPrice
        } else if price == -0.1 {
            return .enterPlanPrice
        } else if isComission && comission <= 0.0 {
            return .enterComission
        } else if comission > 100 {
            return .comissionShouldLess100
        } else if isComission && comission <= 0 {
            return .enterComission
        } else if isComission && comission > 100 {
            return .comissionShouldLess100
        } else if isFreeMonths {
            if noOfFreeMonths <= 0 {
                return .enterFreeMonths
            }
            
            if noOfFreeMonths >= 12 {
                return .noOfFreeMonthsShouldLess12
            }
        }
        return .none
    }
    
    var paratmer: [String: Any] {
        
        var params: [String: Any] = [
            APIKeys.country_id: Int.getInt(self.country?.id),
            APIKeys.plan_name_english: self.planNameEnglish,
            APIKeys.plan_name_arabic: self.planNameArabic,
            APIKeys.duration: self.duration,
            APIKeys.duration_type: self.durationType.rawValue,
            APIKeys.no_of_videos: self.noOfVideos,
            APIKeys.no_of_highlights: self.noOfHighlights,
            APIKeys.no_of_employee: self.noOfEmployee,
            APIKeys.stories: self.isStoryOpen ? 1 : 0,
            APIKeys.price: self.price,
            APIKeys.commission: self.isComission ? 1 : 0,
            APIKeys.commissionPercentage: self.isComission ? self.comission : 0
        ]
        
        // ✅ Product Type
        params[APIKeys.productType] = self.productType ? 0 : 1
        
        if self.productType {
            params[APIKeys.no_of_products] = self.noOfProducts
        }
        
        // ✅ Free Months
        params[APIKeys.isFreeMonths] = self.isFreeMonths ? 1 : 0
        
        if self.isFreeMonths {
            params[APIKeys.noOfFreeMonths] = self.noOfFreeMonths
        }
        
        return params
    }
    
    
    var editParatmer: [String: Any] {
        
        var params: [String: Any] = [
            APIKeys.country_id: Int.getInt(self.country?.id),
            APIKeys.plan_name_english: self.planNameEnglish,
            APIKeys.plan_name_arabic: self.planNameArabic,
            APIKeys.duration: self.duration,
            APIKeys.duration_type: self.durationType.rawValue,
            APIKeys.no_of_videos: self.noOfVideos,
            APIKeys.no_of_highlights: self.noOfHighlights,
            APIKeys.no_of_employee: self.noOfEmployee,
            APIKeys.stories: self.isStoryOpen ? 1 : 0,
            APIKeys.price: self.price,
            APIKeys.commission: self.isComission ? 1 : 0,
            APIKeys.commissionPercentage: self.isComission ? self.comission : 0,
            APIKeys.newprice: self.NewPrice,
            APIKeys.newduration: self.Newduration,
            APIKeys.newduration_type: self.NewdurationType.rawValue
        ]
        
        // ✅ Product Type
        params[APIKeys.productType] = self.productType ? 0 : 1
        
        if self.productType {
            params[APIKeys.no_of_products] = self.noOfProducts
        }
        
        // ✅ Free Months
        params[APIKeys.isFreeMonths] = self.isFreeMonths ? 1 : 0
        
        if self.isFreeMonths {
            params[APIKeys.noOfFreeMonths] = self.noOfFreeMonths
        }
        
        return params
    }
}
enum DurationType:Int,CaseIterable {
    case none,month = 1,year
    var title:String {
        switch self {
        case .none:
            ""
        case .month:
            "Month".localiz()
        case .year:
            "Year".localiz()
        }
    }
}
class AddSubscriptionPlansViewModel {
    
    private(set) var countryListData: [GetCountryDataModel] = []
    private(set) var refresHandler : HandleTableRefresh?
    private(set) var subscriptionInfo : PlanInfo = PlanInfo()
    private(set) var durationType : PlanInfo = PlanInfo()
    private(set) var isForEdit:Bool = false
 
    func setData(_ data:PlanInfo)  {
        self.subscriptionInfo = data
        self.isForEdit = true
    }
    func setRefreshHandler(_ handler:HandleTableRefresh)  {
        refresHandler = handler
    }
    
    func setPlanEnglishName(_ string:String)  {
        self.subscriptionInfo.planNameEnglish = string
    }
    
    func setPlanArabicName(_ string:String)  {
        self.subscriptionInfo.planNameArabic = string
    }
    
    func setDuration(_ string:String)  {
        self.subscriptionInfo.duration = Double.getDouble(string)
    }
    func setnewDuration(_ string:String)  {
        self.subscriptionInfo.Newduration = Double.getDouble(string)
    }
    
    func setDurationType(_ index:Int)  {
        if (DurationType.allCases.count > index) {
            self.subscriptionInfo.durationType = DurationType.allCases.filter({$0 != .none})[index]
        }
    }
    
    func setnewDurationType(_ index:Int)  {
        if (DurationType.allCases.count > index) {
            self.subscriptionInfo.NewdurationType = DurationType.allCases.filter({$0 != .none})[index]
        }
    }
    
    
    func setNoOfVideo(_ string:String)  {
        self.subscriptionInfo.noOfVideos = Int.getInt(string)
    }
    func setNoOfHighLights(_ string:String)  {
        self.subscriptionInfo.noOfHighlights = Int.getInt(string)
    }
    func setNoOfProducts(_ string:String)  {
        self.subscriptionInfo.noOfProducts = Int.getInt(string)
    }
    func setNoOfEmployee(_ string:String)  {
        self.subscriptionInfo.noOfEmployee = Int.getInt(string)
    }
    
    func setStory(_ bool:Bool)  {
        self.subscriptionInfo.isStoryOpen = bool
    }
    
    func setComission(_ string:String)  {
        self.subscriptionInfo.comission = Double.getDouble(string)
    }
    func setFreeMonths(_ string:String)  {
        self.subscriptionInfo.noOfFreeMonths = Int.getInt(string)
    }
    func isComission(_ bool:Bool)  {
        self.subscriptionInfo.isComission = bool
    }
    func setPrice(_ string:String)  {
        self.subscriptionInfo.price = Double.getDouble(string)
    }
    func setnewPrice(_ string:String)  {
        self.subscriptionInfo.NewPrice = Double.getDouble(string)
    }
    func setCountry(_ country:GetCountryDataModel) {
        self.subscriptionInfo.country = country
        refresHandler?.refreshTable(for: "")
    }
    func setIsFreeMonths(_ value: Bool) {
        self.subscriptionInfo.isFreeMonths = value
    }
    func productType(_ bool:Bool)  {
        self.subscriptionInfo.productType = bool
    }
    
    
    func getAllCountry(_ completion:@escaping(() -> Void) ) {
        WebService.shared.getAllCountry(){ [weak self] response in
            guard let self = self else { return }
            countryListData = response
            if (!countryListData.isEmpty) {
                if self.subscriptionInfo.country == nil {
                    self.setCountry(countryListData[0])
                }
            }
            refresHandler?.refreshTable(for: "")
            completion()
        }
    }
    
    func makePlan(_ completion:@escaping () -> Void) {
        if self.isForEdit {
            var paramter = self.subscriptionInfo.editParatmer
            paramter[APIKeys.plan_id] = self.subscriptionInfo.id
            WebService.sharedInstance.editPlan(paramter: paramter) { _ in
                completion()
            }
        } else {
            WebService.sharedInstance.addPlan(paramter: self.subscriptionInfo.paratmer) { _ in
                completion()
            }
        }
        
    }
}
