//
//  DashboardViewController.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 20/06/2022.
//

import UIKit
import FirebaseAuth
import ZainSPM
class TimelineViewController: UITableViewController {
    
    // MARK: - Variables
    var viewModel = TimelineViewModel()
    var isLoadedData = false
    private let refresh = UIRefreshControl()
    
    // MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // checking if there is any user
        if let user = Auth.auth().currentUser {
            viewModel.getuserDetails(with: user.uid)
        }
        
        // binding tmieline posts and updating ui based on listener
        viewModel.timelinePosts.bind {[weak self] timelinePosts in
            // weak self handling and updating UI
            guard let self = self else {return}
            self.isLoadedData.toggle()
            self.tableView.reloadData()
            self.stopActivityIndicator()
        }
    }
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // fetch time line posts
        fetchTimeLinePosts()
    }
    // loading views
    override func loadView() {
        super.loadView()
        title = "Timeline"
        // setting up setup navigation bar buttons
        setupNavigationBarButtons()
        
        // setting up refresh control
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchTimeLinePosts), for: .valueChanged)
        
        // register cell from xib file
        let cellView = UINib(nibName: TimelineCellView.reuseIdentifier, bundle: nil)
        tableView.register(cellView, forCellReuseIdentifier: TimelineCellView.reuseIdentifier)
        
    }
    
    // MARK: - Methods
    // setting up bar buttongs
    func setupNavigationBarButtons() {
        // logout bar button
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutBarButton
        
        // create post bar button
        let createBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostButtonTapped))
        navigationItem.leftBarButtonItem = createBarButton
    }
    
    // logout button action
    @objc func logoutButtonTapped() {
        logoutConfirmationAlert()
    }
    
    // logout confirmation alert
    func logoutConfirmationAlert() {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
        // logout action
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] action in
            // weak self handling
            if let self = self{
                // logout method for logging out from firebase
                self.logoutFromFirestore()
            }
        }))
        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  action in
            print("cancel")
        }))
        // presenting alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // logout from firestore
    func logoutFromFirestore() {
        // logout from firestore
        viewModel.logoutFromFirebase { [weak self] completion in
            // weak self handling
            guard let strongSelf = self else { return }
            if completion{
                // sucseccfully logout and setting LoginViewControler root
                if let window = UIApplication.shared.keyWindow{
                    let viewController = LoginViewController.instantiate()
                    window.rootViewController = viewController
                }
            }else{
                // unable to logout
                strongSelf.showAlert(text: "Unable to logout!")
            }
        }
    }
    
    // fetch timeline posts and showing loading
    @objc func fetchTimeLinePosts() {
        // method from UIViewController extension to show loading in the middle of screen
        startActivityIndicator()
        // flag to update UI
        isLoadedData = false
        // get timeline post from view model method
        viewModel.getTimelinePosts()
        // end refreshing
        refresh.endRefreshing()
    }
    
    // post button action
    @objc func addPostButtonTapped() {
        // showing create post view controller
        let createPostViewController = CreatePostViewController.instantiate() as! CreatePostViewController
        // passing full name to store with full name
        createPostViewController.userName = viewModel.user.value?.fullName ?? ""
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
    
    // edit post alert sheet
    func showEditPostAlertSheet(post: TimelineModel) {
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: "Select Option", message: "Please Select an Option", preferredStyle: alertStyle)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ [weak self] (UIAlertAction)in
            // handling weak self and id from post
            if let self = self, let id = post.id{
                // delete post with viewmodel delete post method
                self.viewModel.deletePost(uuid: id) { completion in
                    // showing alert with completion handler
                    self.showAlert(text: completion) {
                        // on press ok on alert getting post again
                        self.isLoadedData = false
                        self.viewModel.getTimelinePosts()
                    }
                }
            }
        }))
        // cancel alert action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        // presenting alert
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}
// MARK: - TableViewController Delegate Extension
extension TimelineViewController{
    // numberOfRowsInSection check from view model
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if data is loaded then show an empty message
        if isLoadedData{
            if viewModel.timelinePosts.value?.count == 0{
                tableView.setEmptyMessage("Click on + button to create a post.")
            }else{
                // remove the empty meassage
                tableView.restore()
            }
        }
        // returing numberof timeline post or zero
        return viewModel.timelinePosts.value?.count ?? 0
    }
    // cell for row method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cheking if there is any TimelineCellView cell otherwise return empty cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCellView.reuseIdentifier, for: indexPath) as? TimelineCellView
        else {return UITableViewCell()}
        
        // if there is any post we will bind it to cell
        if let post = viewModel.timelinePosts.value?[indexPath.row]{
            cell.timelinePost = post
            // delegate for more button actions
            cell.delegate = self
        }
        return cell
    }
}

// MARK: - TableViewController TimelineCellViewProtocol Extension
extension TimelineViewController: TimelineCellViewProtocol{
    // more button action
    func moreButtonTapped(post: TimelineModel) {
        // method for delete alert sheet
        showEditPostAlertSheet(post: post)
    }
}
