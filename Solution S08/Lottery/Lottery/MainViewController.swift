//
//  ViewController.swift
//  Lottery
//
//  Created by Samy El Deib on 16/04/2017.
//  Copyright © 2017 Samy. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell {

    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
}


class MainViewController: UIViewController {
    
    @IBOutlet weak var gainTableView: UITableView!
    @IBOutlet weak var datePicker: UIPickerView!
    
    @IBOutlet weak var number1: UILabel!
    @IBOutlet weak var number2: UILabel!
    @IBOutlet weak var number3: UILabel!
    @IBOutlet weak var number4: UILabel!
    @IBOutlet weak var number5: UILabel!
    @IBOutlet weak var multiplier: UILabel!
    
    @IBOutlet weak var multiplierView: UIView!
    
    
    var current: Draws?
    var draws: [Draws]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeData()
    }
    
    // Fetch the data from the Server
    func initializeData() {
        draws = []
        datePicker.reloadAllComponents()
        
        RemoteConnectionHandler.getDraws(success: { (draws) in
            self.draws = draws
            DispatchQueue.main.async {
                self.updateView()
            }
            
        }) { (error) in
            self.showErrorAlert(error)
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }

    //If something goes wrong an alert pops up
    private func showErrorAlert(_ error: Error) {
        let title = "Oops!"
        let message = "Could not load draws: \(error.localizedDescription)"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //Will only be loaded once
    private func setup() {
        title = "Lottery"
        gainTableView.dataSource = self
        gainTableView.delegate = self
        multiplierView.layer.cornerRadius = multiplierView.frame.size.width / 2
    }
    
    //fills the labels depending on the lottery draw picked
    private func updateView() {
        if let draw = draws,
            draw.count > 0 {
            datePicker.dataSource = self
            datePicker.delegate = self
        }
        
        if let current = current {
            number1.text = current.numbers[0]
            number2.text = current.numbers[1]
            number3.text = current.numbers[2]
            number4.text = current.numbers[3]
            number5.text = current.numbers[4]
            multiplier.text = current.numbers[5]
        }
        
    }

    //delegates the current or no draw to the next class depending on Add- or EditMode
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case "addButton":
                // The destination is a navigation controller, therefore we must find its root view controller
                if let destNavC = segue.destination as? UINavigationController,
                    let destVC = destNavC.viewControllers.first as? AddEditViewController {
                    destVC.mode = .AddDrawMode
                    destVC.delegate = self
                }
            case "editButton":
                // The destination is a navigation controller, therefore we must find its root view controller
                if let destNavC = segue.destination as? UINavigationController,
                    let destVC = destNavC.viewControllers.first as? AddEditViewController {
                    destVC.mode = .EditDrawMode
                    destVC.draw = current
                    destVC.delegate = self
                }
            default:
                // Do noting (No ID no fun ;) )
                break
            }
        }
    }
}


//Extension for filling the UIPicker
extension MainViewController: UIPickerViewDataSource {
    
    //MARK: Data Sources
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //How many elements in the pickerView
    internal func pickerView(_ pickerView: UIPickerView,
                             numberOfRowsInComponent component: Int) -> Int {
        if let draws = draws {
            return draws.count
        }
         return 0
    }
    
    //Filling the PickerView
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                             forComponent component: Int) -> String? {
        if let draws = draws {
            current = draws[row]
            return String(describing: draws[row].timestamp)
        }
        return  ""
    }
}

extension MainViewController: UIPickerViewDelegate {
    
    //MARK: - Delegates
    //Filling the labels when a date is selected
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                             inComponent component: Int) {
        if let draws = draws {
            number1.text = String(draws[row].numbers[0])
            number2.text = String(draws[row].numbers[1])
            number3.text = String(draws[row].numbers[2])
            number4.text = String(draws[row].numbers[3])
            number5.text = String(draws[row].numbers[4])
            multiplier.text = String(draws[row].numbers[5])
        }
    }
}

//Extension for filling the Table View
extension MainViewController : UITableViewDataSource {
    
    //Filling the TableView with 7 cells
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let constant: Constants = Constants()
        return constant.gains.count
    }
}

extension MainViewController: UITableViewDelegate {
    
    //Filling the cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let constant: Constants = Constants()
        let cell = tableView.dequeueReusableCell(withIdentifier: "gainCell", for: indexPath) as! TableViewCell
        
        let gains = constant.gains[indexPath.row]
        let place = constant.place[indexPath.row]
        
        cell.moneyLabel.text = String(gains)
        cell.gainLabel.text = place
        
        return cell
    }
}

// MARK: - AddEditViewControllerDelegate
extension MainViewController: AddEditDrawViewDelegate {
    
    func didAddDraw(draw: Draws) {
        /*  For less communication overhead you may want to add the draw locally
         instead of reloading all draws all over again. */
        initializeData()
    }
    
    func didEditDraw(timestamp: String) {
        /*  For less communication overhead you may want to edit the draw locally
         instead of reloading all draws all over again. */
        initializeData()
    }
    
    func didDeleteDraw(timestamp: String) {
        /*  For less communication overhead you may want to delete the draw locally
         instead of reloading all draws all over again. */
        initializeData()
    }
    
    func didCancel() {
        // Do what ever you find appropriate if an user cancels adding/editing
    }
}


