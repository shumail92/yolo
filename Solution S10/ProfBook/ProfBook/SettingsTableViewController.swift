//
//  SettingsTableViewController.swift
//  Contacts
//
//  Created by Michael Schlicker on 06/04/2017.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	@IBOutlet var filterSwitch: UISwitch!
	internal let filterIdentifier = "filterActivated"
	
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        
        filterSwitch.isOn = UserDefaults.standard.bool(forKey: filterIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func switchFilter(_ sender: Any) {
        let defaults = UserDefaults.standard
        if (filterSwitch.isOn) {
            defaults.set(true, forKey: filterIdentifier)
        }
        else{
            defaults.set(false, forKey: filterIdentifier)
        }        
    }
}
