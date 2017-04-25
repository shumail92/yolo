//
//  AddEditViewController.swift
//  Lottery
//
//  Created by Samy El Deib on 17/04/2017.
//  Copyright © 2017 Samy. All rights reserved.
//

import UIKit

class AddEditViewCell: UITableViewCell {

    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!    
}


// MARK: - AddEditDrawViewDelegate
protocol AddEditDrawViewDelegate: class {
    func didAddDraw(draw: Draws)
    func didEditDraw(timestamp: String)
    func didDeleteDraw(timestamp: String)
    func didCancel()
}
    

// MARK: - AddEditDrawMode
enum AddEditDrawMode {
    case AddDrawMode
    case EditDrawMode
}
    
    
// MARK: - AddEditDrawViewController
class AddEditViewController: UIViewController {
    // MARK: - Public
    @IBOutlet weak var gainTableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var multiplierView: UIView!
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    @IBOutlet weak var number4: UITextField!
    @IBOutlet weak var number5: UITextField!
    @IBOutlet weak var mulitplier: UITextField!
        
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    var mode: AddEditDrawMode = .AddDrawMode
    var draw: Draws?
    weak var delegate: AddEditDrawViewDelegate?
        
        
    // MARK: - Public
    override func viewDidLoad() {
        super.viewDidLoad()

        setProperTitle()
        setUpUIForDraw()
    }
    
    /**
     Linked to the "Cancel"-button in the navigation bar.
     Cancels the adding/editing of the currently selected drawing.
     */
    @IBAction func cancelAddEdit(_ sender: UIBarButtonItem) {
        // Return back to main screen
        dismiss(animated: true, completion: nil)
        delegate?.didCancel()
    }
    
    /**
     Linked to the "Trash"-button in the navigation bar.
     Deletes the currently selected drawing.
     */
    @IBAction func deleteDraw(_ sender: Any) {
        if let draw = draw {
            // We delete an existing draw (we only need the id for that, obviously)
            RemoteConnectionHandler.deleteDraws(timestamp: draw.timestamp , success: {
                print("Yay! Draw deleted.")
                self.delegate?.didDeleteDraw(timestamp: draw.timestamp)
                self.dismiss(animated: true, completion: nil)
                    
            }) { (error) in
                print("Bah! Didn't delete draw...")
                self.showSomethingWentWronAlert(title: "Delete failed",
                                                message: "Deleting draw failed: \(error.localizedDescription)")
            }
        }
    }
        
    /**
     Linked to the "Save"-button in the navigationbar.
     Depending on the mode either triggers a REST
     POST for a new draw (.AddDrawnMode)
     or
     PUT for an existing Draw (.EditDrawMode)
     */
    @IBAction func saveChanges(_ sender: Any) {
            
        // Collect draw data
        if let creDraw = createDrawFromProvidedData() {
                
        // Trigger REST call
        switch mode {
        case .AddDrawMode:
            // We post a new draw
            RemoteConnectionHandler.postDraws(draw: creDraw, success: { () in
                print("Yay! Draw added.")
                self.delegate?.didAddDraw(draw: creDraw)
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Bah! Didn't add draw...")
                self.showSomethingWentWronAlert(title: "Add failed", message: "Adding draw failed: \(error.localizedDescription)")
            })
                    
        case .EditDrawMode:
            // We edit an existing draw
            RemoteConnectionHandler.putDraws(draw: creDraw, success: {
                print("Yay! Draw edited.")
                self.delegate?.didEditDraw(timestamp: creDraw.timestamp)
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Bah! Didn't edit draw...")
                self.showSomethingWentWronAlert(title: "Edit failed",
                                                message: "Editing draw failed: \(error.localizedDescription)")
                })
            }
        } else {
            showSomethingWentWronAlert(title: "Insufficient draw data", message:
                "Your draw seems incomplete. Please check if you've provided:\n- 6 numbers")
        }
    }
    
    // MARK: - Private
    /**
     Sets the appropriate title in the navigationbar depending on the
     currend mode.
    */
    private func setProperTitle() {
        switch mode {
        case .AddDrawMode:
            title = "Add Draw"

        case .EditDrawMode:
            title = "Edit Draw"
            
        }
    }
    
    /**
     Depending on the currend mode either
     creates an empty draw and one additional answer cell
     or
     creates a filled draw and adds as many answer cells
     in respect to the given draw.
    */
    private func setUpUIForDraw() {
        gainTableView.dataSource = self
        gainTableView.delegate = self
        multiplierView.layer.cornerRadius = multiplierView.frame.size.width / 2
        
        switch mode {
        case .AddDrawMode:
            deleteBtn.isEnabled = false
            number1.text = "0"
            number2.text = "0"
            number3.text = "0"
            number4.text = "0"
            number5.text = "0"
            mulitplier.text = "0"
        case .EditDrawMode:
            deleteBtn.isEnabled = true
            if let draw = draw {
                number1.text = draw.numbers[0]
                number2.text = draw.numbers[1]
                number3.text = draw.numbers[2]
                number4.text = draw.numbers[3]
                number5.text = draw.numbers[4]
                mulitplier.text = draw.numbers[5]
            } else {
                number1.text = "0"
                number2.text = "0"
                number3.text = "0"
                number4.text = "0"
                number5.text = "0"
                mulitplier.text = "0"
            }
        }

    }
        
    /**
     Shows an alert view over the current view.
     Is used to communicate errors to the user, but could be used for anything.
    */
    private func showSomethingWentWronAlert(title: String? = nil, message: String? = nil) {
        let title = title ?? "Oops!"
        let message = message ?? "Something went wrong there. Try again."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
            
        present(alert, animated: true, completion: nil)
    }
        
    /**
     Collects added/edited fields data and creates a new draw object from it.
     Invalid inputs like whitespaces only get trimmed.
     If there is some invalid input, returns nil immediately.
    */
    private func createDrawFromProvidedData() -> Draws? {
        var timestamp = ""
        switch mode {
        case .AddDrawMode:
            timestamp = String(describing: datePicker.date)
            let timestamps = timestamp.components(separatedBy: " ")
            timestamp = timestamps[0]
        case .EditDrawMode:
            if let draw = draw {
                timestamp = (draw.timestamp)
            }
            
        }
        var draws: [String] = []
        if let number1 = number1.text,
            let number2 = number2.text,
            let number3 = number3.text,
            let number4 = number4.text,
            let number5 = number5.text,
            let multiplier = mulitplier.text {
            draws.append(number1)
            draws.append(number2)
            draws.append(number3)
            draws.append(number4)
            draws.append(number5)
            draws.append(multiplier)
        } else {
            showSomethingWentWronAlert(title: "Incomplete",
                                       message: "Not every Textfield was filled")
            draws[0] = "0"
            draws[1] = "0"
            draws[2] = "0"
            draws[3] = "0"
            draws[4] = "0"
            draws[5] = "0"
        }
        
        return Draws(timestamp: timestamp, numbers: draws)
    }
}


//Extension for filling the Table View
extension AddEditViewController: UITableViewDataSource {
    
    //Filling the TableView with 7 cells
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let constant: Constants = Constants()
        return constant.gains.count
    }
}

extension AddEditViewController: UITableViewDelegate {
    //Filling the cells
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let constant: Constants = Constants()
        let cell = tableView.dequeueReusableCell(withIdentifier: "addEditCell", for: indexPath) as! AddEditViewCell
        
        let gains = constant.gains[indexPath.row]
        let place = constant.place[indexPath.row]
        
        cell.moneyLabel.text = String(gains)
        cell.gainLabel.text = place
        
        return cell
    }
}
