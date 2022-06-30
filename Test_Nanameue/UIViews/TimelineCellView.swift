//
//  TimelineCellView.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 22/06/2022.
//

import UIKit
import SDWebImage
import FirebaseAuth
class TimelineCellView: UITableViewCell {

    // MARK: - Static Identifier
    static let reuseIdentifier = "TimelineCellView"
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: - Variables
    var delegate: TimelineCellViewProtocol?
    
    var timelinePost: TimelineModel?{
        didSet{
            // checking if timelinePost is not nil
            guard let timelinePost = timelinePost else {
                return
            }
            
            // hiding or showing views
            moreButton.isHidden = true
            postImageView.isHidden = true
            postTextLabel.isHidden = timelinePost.postText.isEmpty
            
            // setting up user image based on library that uses name and create an image with initials
            userImageView.setImage(string: timelinePost.userName, color: .appColor(.themeBlue))
            
            // setting up data on views
            usernameLabel.text = timelinePost.userName
            postTextLabel.text = timelinePost.postText
            
            // time ago method to convert date into text that show how much time ago the post was posted
            timeAgoLabel.text = timelinePost.timestamp.timeAgoDisplay()
            
            // setting up timeline post image
            if let imageUrl = timelinePost.imageUrl{
                postImageView.isHidden = false
                postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                
                // creating a queue to load data faster
                let queue = DispatchQueue(label: "com.test_nanameue.dispatch.qos")

                // async with background type
                queue.async(qos: .userInteractive) {
                    self.postImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(), options: [.progressiveLoad])
                }
            }
            // showing or hiding more button based on if user own the post
            if let userId = Auth.auth().currentUser?.uid{
                if timelinePost.userId == userId{
                    moreButton.isHidden = false
                }
            }
        }
    }
    
    // more button action
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        guard let timelinePost = timelinePost else {
            return
        }
        // calling delegate method to delete post
        delegate?.moreButtonTapped(post: timelinePost)
    }
}

