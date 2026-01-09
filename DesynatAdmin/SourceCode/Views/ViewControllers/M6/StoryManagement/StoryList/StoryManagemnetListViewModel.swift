//
//  StoryManagemnetListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper on 09/01/26.
//

import Foundation

class StoryManagemnetListViewModel {

    private var hostVC: StoryManagemnetViewController
    var storiesList: [AdminStoriesList] = []

    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true

    init(hostVC: StoryManagemnetViewController) {
        self.hostVC = hostVC
    }

    func getAdminStoriesList(reset: Bool = false) {

        guard !isFetching, hasMorePages else { return }

        isFetching = true

        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            storiesList.removeAll()
        }

        let params: [String: Any] = [
            "page": currentPage,
            "limit": 9]
        WebService.shared.getAdminStoriesList(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                guard let data = response.data else { return }
                // Append only once
                self.storiesList.append(contentsOf: data)
                self.lastPage = response.lastPage ?? 1
                // Decide if more pages exist
                if self.currentPage >= self.lastPage {
                    self.hasMorePages = false
                } else {
                    self.currentPage += 1
                }
                self.hostVC.bindData()
            }
        }
    }
  
  func resetAndFetchStories() {
      currentPage = 1
      lastPage = 1
      isFetching = false
      hasMorePages = true
      storiesList.removeAll()
      getAdminStoriesList()
  }
  
  func deleteAdminStories(param: [String: Any]) {
    WebService.shared.deleteAdminStories(param: param){ [weak self] response in
      guard let self = self else { return }
      CommonUtils.showToast(message: "Story Deleted Succesfully")
      self.resetAndFetchStories()
    }
  }
}
