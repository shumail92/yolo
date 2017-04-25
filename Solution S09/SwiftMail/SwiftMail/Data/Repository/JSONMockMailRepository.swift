import Foundation

class JSONMockMailRepository: MailRepository {
    
    fileprivate var mails: [MailModel]?
    fileprivate let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func loadMails(success: @escaping  ([MailModel]) -> (), error: @escaping (Error) -> ()) {
        if mails == nil {
            mails = loadMailsFromJson()
        }
        success(mails!)
    }
    
    func send(mail: MailModel,success: @escaping () -> (), error: @escaping (Error) -> ()) {
        // Simulate a delay when sending a mail
        let delay = Int(arc4random_uniform(1000))
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
            success()
        })
    }
}

// MARK: Private Methods
extension JSONMockMailRepository {
    fileprivate func loadMailsFromJson() -> [MailModel] {
        var mails: [MailModel] = []
        
        guard let data = loadJsonDataFromFile() else { return mails }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Any] else { return mails }
        
        for jsonMail in json {
            if let mail = MailModel(json: jsonMail as! [String : Any]) {
                mails.append(mail)
            }
        }
        return mails
    }
    
    fileprivate func loadJsonDataFromFile() -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe) as Data
                return jsonData
            } catch {
                print("Error! Unable to parse \(fileName).json")
            }
        }
        return nil
    }
}
