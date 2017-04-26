//
//  LoginViewController.swift
//  Contacts
//
//  Created by Quirin Schweigert on 3/17/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
	
	let showContactListSegueIdentifier = "ShowContactList"
	let emailUserDefaultsIdentifier = "emailAddress"
	@IBOutlet weak var activityIndicatorParentView: UIView!
	@IBOutlet weak var emailTextField:UITextField!
	
	private var contacts: [Contact] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		emailTextField.text = UserDefaults.standard.string(forKey: emailUserDefaultsIdentifier)
	}
	
	
	@IBAction func loginButtonPressed() {
		
		var imageBuffer = ThreadSafeDictionary<String, UIImage>()

		UserDefaults.standard.set(emailTextField.text, forKey: emailUserDefaultsIdentifier)
		activityIndicatorParentView.isHidden = false
        
		DispatchQueue.global(qos: .userInitiated).async {
			
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let context = appDelegate.persistentContainer.viewContext
			
			let fetchRequest:NSFetchRequest<Contact> = Contact.fetchRequest()
			
			do {
				self.contacts = try context.fetch(fetchRequest)
				
				for contact in self.contacts {
					guard let imageData = contact.imageData as Data? else {
                        continue
                    }
					let image = UIImage(data: imageData)
					imageBuffer[contact.imageName!] = image
				}
				
			} catch {
				print("Contacts couldn't be fetched")
			}
			
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: self.showContactListSegueIdentifier, sender: imageBuffer)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let contactListViewController = (segue.destination as? UINavigationController)?.childViewControllers[0] as? ContactListViewController,
			let imageBuffer = sender as? ThreadSafeDictionary<String, UIImage> else { return }
		contactListViewController.contacts = contacts
		contactListViewController.imagesWithAppliedFilter = imageBuffer
		contactListViewController.imageBuffer = imageBuffer
	}
	
	@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
		activityIndicatorParentView.isHidden = true
	}
}
