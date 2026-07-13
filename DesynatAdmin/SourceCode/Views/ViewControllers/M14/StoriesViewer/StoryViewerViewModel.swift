//
//  StoryViewerViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation
import AVFoundation

class StoryViewerViewModel {
    
    private var hostVC: StoryViewerViewController?
    
    var sellerStories: [GetMyReelsList] = []
    var sellerHighlights: [HighlightsList] = []
    
    func deleteSellerStory(id: Int, completion: @escaping (Bool) -> Void) {
        let param: [String:Any] = ["story_id": id]
        WebService.sharedInstance.deleetSellerstoryListService(param: param) { success in
            completion(true)
        }
    }
    
    func seeStoryService(storyId: Int) {
        let savedUser = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self)
        let param: [String:Any] = ["story_id": storyId,
                                   "type": 3, //1-user,2-seller,3-admin
                                   "user_id": savedUser?.id ?? 0]
        WebService.sharedInstance.seeStoryListService(param: param) { success in
            print("Stopry viewed")
        }
    }
    
    func deleteHighlight(id: Int, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["highlight_id": id]
        WebService.sharedInstance.deleetSellerHighlightListService(param: param) { response in
            completion(true)
        }
    }

}

enum ComingReasonAtStoryViewer {
    case forSellerStory
    case forSellerHighlights
}
