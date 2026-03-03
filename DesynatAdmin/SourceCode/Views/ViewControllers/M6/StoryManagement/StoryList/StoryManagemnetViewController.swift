//
//  StoryManagemnetViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit
import AVFoundation
import UIKit
import AVKit

class StoryManagemnetViewController: UIViewController {
    
    @IBOutlet weak var storyCollectionView: UICollectionView! {
        didSet {
            storyCollectionView.registerCellFromNib(cellID: "StoryManagemnetCollectionViewCell")
            storyCollectionView.registerCellFromNib(cellID: "StoryUploadCollectionViewCell")
        }
    }
    
    private lazy var viewModel = StoryManagemnetListViewModel(hostVC: self)
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetAndFetchStories()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func bindData() {
        storyCollectionView.reloadData()
    }
    
}

extension StoryManagemnetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.storiesList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryUploadCollectionViewCell", for: indexPath) as! StoryUploadCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryManagemnetCollectionViewCell", for: indexPath) as! StoryManagemnetCollectionViewCell
            let story = viewModel.storiesList[indexPath.item - 1]
            cell.configData(data: story)
            cell.onDeleteToggle = {
                self.showConfirmationAlert(msg: "Are you sure you want to delete this story?") { [weak self] in
                    guard let self = self else { return }
                    let param: [String: Any] = ["story_id": story.id ?? ""]
                    viewModel.deleteAdminStories(param: param)
                }
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextVC = AddStoryViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let media = viewModel.storiesList[indexPath.item - 1]
            guard let fileURLString = media.file,
                  let encodedURLString = fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: encodedURLString) else { return }
            
            if fileURLString.lowercased().contains(".mp4") {
                player = AVPlayer(url: url) // retain player
                let playerVC = AVPlayerViewController()
                playerVC.player = player
                self.present(playerVC, animated: true) {
                    self.player?.play()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (storyCollectionView.frame.width - 20) / 2
        let height: CGFloat = 220
        return CGSize(width: width, height: height)
    }
    
}

extension StoryManagemnetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Don't paginate if content is not scrollable
        guard scrollView.contentSize.height > scrollView.frame.height else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.getAdminStoriesList()
        }
    }
    
}
