//
//  ContactListViewController
//  Contacts
//
//  Created by Quirin Schweigert on 3/18/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var infoBubbleText: UILabel!
	@IBOutlet weak var infoBubbleImage: UIImageView!
	
	public var contacts: [Contact] = []
	public var serverContacts: [ServerContact] = []
	
	// this will be used in TASK 7
	internal var imageBuffer = ThreadSafeDictionary<String, UIImage>()
	internal var imagesWithAppliedFilter = ThreadSafeDictionary<String, UIImage>()
	internal let cellReuseIdentifier = "ContactCell"
	internal let contactCellReuseIdentifier = "ContactTableViewCell"
	internal let filterIdentifier = "filterActivated"
	private var viewControllerLoadedFirstTime = true
	
	override func viewDidLoad() {
		tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: contactCellReuseIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		hideInfoBubble()
		updateContactsFromServer()
	}
	
	/*
	* It would normally be better to load the data already before the view is visible so that the
	* table is already filled when the view animates on screen. However for this tutorial, loading
	* the data afterwards makes the specific loading times recognizeable.
	*/
	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()

		if viewControllerLoadedFirstTime {
			viewControllerLoadedFirstTime = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.showInfoBubbleAnimated()
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
					self.hideInfoBubbleAnimated()
				}
			}
		}
	}
	
	func updateContactsFromServer() {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		DispatchQueue.global(qos: .userInitiated).async {
			
			let loadedContacts = SimulatedNetwork.loadContactList()
			for contact in loadedContacts {
				
                let indexOfContactInArray = self.contacts.index { persistentContact in
					return persistentContact.phoneNumber == contact.phoneNumber
				}
				
				if indexOfContactInArray == nil {
					
                    if let image = SimulatedNetwork.loadImage(name: contact.imageName) {
                        self.imageBuffer[contact.imageName] = image
                    }
					
					let newContact = ServerContact(imageName: contact.imageName, firstName: contact.firstName, lastName: contact.lastName, phoneNumber: contact.phoneNumber)
					self.serverContacts.append(newContact)
					
				} else {
					
					let imageChanged = contact.imageName != self.contacts[indexOfContactInArray!].imageName
					if imageChanged {
						guard let newImage = SimulatedNetwork.loadImage(name: contact.imageName) else {
                            break
                        }
						
						let newImageData = UIImageJPEGRepresentation(newImage, 1.0)
						
						let displayedContact = self.contacts[indexOfContactInArray!]
						displayedContact.imageName = contact.imageName
						displayedContact.imageData = newImageData as NSData?
						
						self.imageBuffer[displayedContact.imageName!] = newImage
					}
				}
			}
			
			do {
				try context.save()
			} catch {
				print("Changes couldn't be saved")
			}
            self.applyFilter()
		}
	}
	
	func applyFilter(){
		DispatchQueue.global(qos: .userInitiated).async {
            for (imageName, image) in self.imageBuffer {
                self.imagesWithAppliedFilter[imageName] = ImageFilter.applyContactFilter(to: image)
            }
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
    func favorite(contact: ServerContact, index:Int, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newContact = Contact(context: context)
            newContact.firstName = contact.firstName
            newContact.lastName = contact.lastName
            newContact.phoneNumber = contact.phoneNumber
            newContact.imageName = contact.imageName
            do {
                try context.save()
                self.contacts.append(newContact)
                self.serverContacts.remove(at: index)
            } catch {
                print("Error")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func unfavorite(contact: Contact, index: Int, completion: @escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        DispatchQueue.global(qos: .userInitiated).async {
            let newContact = ServerContact(imageName: contact.imageName!, firstName: contact.firstName!, lastName: contact.lastName!, phoneNumber: contact.phoneNumber!)
            do {
                context.delete(contact)
                try context.save()
                self.serverContacts.append(newContact)
                self.contacts.remove(at: index)
            } catch {
                print("Error")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension ContactListViewController: StarDelegate {
	func starPressed(in cell: ContactTableViewCell) {
		guard let indexPath = tableView.indexPath(for: cell) else { print("bla"); return }
		if indexPath.row < contacts.count {
			unfavorite(contact: contacts[indexPath.row], index: indexPath.row) {
				cell.activityIndicator.stopAnimating()
				cell.activityIndicator.isHidden = true
				cell.starButton.isHidden = false
				self.tableView.reloadData()
			}
		} else {
			favorite(contact: serverContacts[indexPath.row-contacts.count], index: indexPath.row-contacts.count) {
				_ in
				cell.activityIndicator.stopAnimating()
				cell.activityIndicator.isHidden = true
				cell.starButton.isHidden = false
				self.tableView.reloadData()
			}
		}
	}
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
	// MARK: - Table view data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return  contacts.count + serverContacts.count
	}
	

    // Use the image with applied filter and show it
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: contactCellReuseIdentifier, for: indexPath)
		guard let contactCell = cell as? ContactTableViewCell else {
            return cell
        }
		
		if indexPath.row < contacts.count {
			let contact = contacts[indexPath.row]
			if let firstName = contact.firstName,
				let lastName = contact.lastName,
				let imageName = contact.imageName {
				contactCell.nameLabel.text = firstName + " " + lastName
				contactCell.numberLabel.text = contact.phoneNumber
				contactCell.starButton.setTitle("★", for: UIControlState.normal)
				contactCell.starButton.setTitleColor(UIColor.yellow, for: .normal)
                if UserDefaults.standard.bool(forKey: self.filterIdentifier) {
                    contactCell.roundedImageView.image = imagesWithAppliedFilter[imageName]
                }
                else{
                    contactCell.roundedImageView.image = imageBuffer[imageName]
                }
			}
		} else {
			let contact = serverContacts[indexPath.row-contacts.count]
			contactCell.nameLabel.text = contact.firstName + " " + contact.lastName
			contactCell.numberLabel.text = contact.phoneNumber
			contactCell.starButton.setTitle("☆", for: UIControlState.normal)
			contactCell.starButton.setTitleColor(UIColor.black, for: .normal)
            if UserDefaults.standard.bool(forKey: self.filterIdentifier) {
                contactCell.roundedImageView.image = imagesWithAppliedFilter[contact.imageName]
            }
            else{
                contactCell.roundedImageView.image = imageBuffer[contact.imageName]
            }
		}

		contactCell.delegate = self
		
		return cell
	}
}

extension ContactListViewController {
	// MARK: functions for animating the information bubble
	
	internal func showInfoBubbleAnimated() {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
			self.infoBubbleImage.alpha = 1.0
			self.infoBubbleText.alpha = 1.0
		}, completion: nil)
	}
	
	internal func hideInfoBubble() {
		self.infoBubbleImage.alpha = 0.0
		self.infoBubbleText.alpha = 0.0
	}
	
	internal func hideInfoBubbleAnimated() {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
			self.infoBubbleImage.alpha = 0.0
			self.infoBubbleText.alpha = 0.0
		}, completion: nil)
	}
}
