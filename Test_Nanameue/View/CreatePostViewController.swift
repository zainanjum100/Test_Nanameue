//
//  CreatePostViewController.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 22/06/2022.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    // MARK: - IBOutlts
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var uploadView: UIView!
    
    // MARK: - Variables
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()

    var viewModel = CreatePostViewModel()
    
    var userName = ""
    var isUploadedImage = false
    var placeholderLabel : UILabel!
    let placeHolder = "What's on your mind?"
    var selectedImage: UIImage?
    var loadingAlert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        postButton.isEnabled = false
        postTextView.delegate = self
        setupTextViewPlaceHolder()
        
        viewModel.uploadTask.bind { uploadTask in
            
            // Add a progress observer to an upload task
            uploadTask?.observe(.progress) { [weak self] snapshot in
              // A progress event occured
                guard let self = self else {return}
                DispatchQueue.main.async {
                    let progress = snapshot.progress?.fractionCompleted ?? 0
                    print(progress)
                    let roundedProgress = String(format: "%.2f", progress*100)
                    self.loadingAlert.message = "\(roundedProgress)% uploaded"
                }
                
            }
        }
    }
    
    // view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.uploadTask.value?.removeAllObservers()
    }
    
    // MARK: - Methods
    // setting up label in textview to act like a UITextField
    func setupTextViewPlaceHolder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = placeHolder
        placeholderLabel.font = .italicSystemFont(ofSize: (postTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        postTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (postTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .appColor(.themeLightGray)
        placeholderLabel.isHidden = !postTextView.text.isEmpty
    }
    
    // updateviews
    func updateViews() {
        postButton.isEnabled = isUploadedImage || postTextView.text.count > 0
        imageContainer.isHidden = !isUploadedImage
        uploadView.isHidden = isUploadedImage
    }
    
    // post button action
    @IBAction func postButtonTapped(_ sender: UIButton) {
        // checking if image is selected or not
        if selectedImage != nil{
            // if there is an image then showing loading alert with percentage
            showLoadingAlertWith(text: "Uploading")
        }else{
            // other wise showing simple loading in the middle of viewcontrller
            startActivityIndicator()
        }
        // getting text from postTextView
        guard let postText = postTextView.text else { return }
        // calling viewmodel upload post method to uppload post on firestore
        viewModel.uploadPostWith(text: postText, postImage: selectedImage, userName: userName) { [weak self] result in
            
            // weak self handling
            guard let self = self else {return}
            
            // cheking image is not nil dismiss loading alert
            if self.selectedImage != nil{
                self.dismiss(animated: true)
            }else{
                // otherwise stopping activity indicator
                self.stopActivityIndicator()
            }
            
            // result handling
            switch result{
            case .success(let text):
                // setting image not and showing result alert
                self.selectedImage = nil
                // popping view from navigation stack
                self.showAlert(text: text) {
                    self.navigationController?.popViewController(animated: true)
                }
                // error handling
            case.failure(let err):
                debugPrint(err)
            }
        }
    }
    
    // upload image button tapped
    @IBAction func uploadImageButtonTapped() {
        // showing alert sheet for choice betweek camera and photo library
        showAlertSheet()
    }
    // delete button action
    @IBAction func deleteImageButtonTapped() {
        // resseting image functionality
        isUploadedImage.toggle()
        selectedImage = nil
        updateViews()
    }
    // select source alert sheet
    func showAlertSheet() {
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: "Select Source", message: "Please Select an Option", preferredStyle: alertStyle)
        
        // camera alert action
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ [weak self] (UIAlertAction) in
            if let self = self{
                // image picker method to select camera
                self.imagePicker.cameraAsscessRequest()
            }
        }))
        // photo library aert action
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ [weak self] (UIAlertAction)in
            if let self = self{
                // image picker method to select photo library
                self.imagePicker.photoGalleryAsscessRequest()
            }
        }))
        // cancel alert action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // loading alert for post creation
    func showLoadingAlertWith(text: String) {
        
        if #available(iOS 13.0, *) {
            loadingAlert.view.tintColor = UIColor.label
        } else {
            loadingAlert.view.tintColor = UIColor.black
        }
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        if #available(iOS 13.0, *) {
            loadingIndicator.color = .label
        } else {
            loadingIndicator.color = .black
        }
        loadingAlert.view.addSubview(loadingIndicator)
        self.present(loadingAlert, animated: true)
        
    }
    
    
}
// MARK: - CreatePostViewController UITextViewDelegate Extension
extension CreatePostViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        postButton.isEnabled = isUploadedImage || postTextView.text.count > 0
    }
}
// MARK: - CreatePostViewController ImagePickerDelegate Extension
extension CreatePostViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        postImageView.image = image
        selectedImage = image
        imagePicker.dismiss()
        isUploadedImage.toggle()
        updateViews()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
