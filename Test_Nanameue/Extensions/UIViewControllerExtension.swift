//
//  UIViewControllerExtension.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 22/06/2022.
//

import UIKit

extension UIViewController{
    func setRootTimelineViewController() {
        let vc = TimelineViewController()

        let navigationController = UINavigationController(rootViewController: vc)

        if let window = UIApplication.shared.keyWindow{
            window.rootViewController = navigationController
        }
    }
    func showAlert(text: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  action in
            switch action.style{
            case .default:
                completion()
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            default:
                break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
