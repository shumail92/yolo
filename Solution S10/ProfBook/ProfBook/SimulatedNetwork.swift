//
//  SimulatedNetwork.swift
//  Contacts
//
//  Created by Quirin Schweigert on 3/17/17.
//  Copyright © 2017 TUM. All rights reserved.
//

import UIKit

/*
 *  You have nothing to do here, but you are welcome to have a look and think about the way I implemented
 *  the delay that simulates a very slow network connection. Notice that delays add up, i.e. if multiple
 *  recources are reqeusted they are processed in serial.
 */

class SimulatedNetwork {
    static let serialQueue = DispatchQueue(label: "de.tum.www1.ProfBook.SimulatedNetwork")
    
    public static func loadContactList() -> [ServerContact] {
        _ = serialQueue.sync { sleep(2) }
        return internalData.map {
            // simulates the profs switching their contact pics
            ServerContact(imageName: $0.imageNames[Int(arc4random_uniform(UInt32($0.imageNames.count)))],
                          firstName: $0.firstName,
                          lastName: $0.lastName,
                          phoneNumber: $0.phoneNumber)
        }
    }
    
    public static func loadImage(name: String) -> UIImage? {
        _ = serialQueue.sync { usleep(300_000) }
        return UIImage(named: name)
    }
    
	
    
    static let internalData: [(imageNames: [String], firstName: String, lastName: String, phoneNumber: String)] = [
        (imageNames: ["albers_1.jpg", "albers_2.jpg"], firstName: "Susanne", lastName: "Albers", phoneNumber: "+498928917702"),
        (imageNames: ["bode_1.jpg", "bode_2.jpg"], firstName: "Arndt", lastName: "Bode", phoneNumber: "+498928917654"),
        (imageNames: ["bruegge_1.jpg", "bruegge_2.jpg"], firstName: "Bernd", lastName: "Brügge", phoneNumber: "+498928918204"),
        (imageNames: ["brueggemann-klein_1.jpg", "brueggemann-klein_1.jpg"], firstName: "Anne", lastName: "Brüggemann-Klein", phoneNumber: "+498928918659"),
        (imageNames: ["bungartz_1.jpg", "bungartz_2.jpg"], firstName: "Hans-Joachim", lastName: "Bungartz", phoneNumber: "+498928918604"),
        (imageNames: ["carle_1.jpg"], firstName: "Georg", lastName: "Carle", phoneNumber: "+498928918030"),
        (imageNames: ["esparza_1.jpg", "esparza_2.jpg"], firstName: "Javier", lastName: "Esparza", phoneNumber: "+498928917204")
        // ...
    ]
}

public struct ServerContact {
	public let imageName: String
	public let firstName: String
	public let lastName: String
	public let phoneNumber: String
}
