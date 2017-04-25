import UIKit

class MailModel: NSObject {
    // Subclass NSObject to be Key-Value-Observable
    
    var id: String?
    let datetime: Date
    var from: String
    var fromName: String
    var to: String
    var subject: String
    var body: String
    
    var bc: [String]
    var cc: [String]
    
    var pictureUrl: URL?
    dynamic var thumbnail: UIImage?
    
    init(from: String, fromName: String, to: String, subject:String, body: String, datetime: Date = Date(), bc: [String]? = nil, cc: [String]? = nil, pictureUrl: String? = nil) {
        self.datetime = datetime
        self.from = from
        self.fromName = fromName
        self.to = to
        self.subject = subject
        self.body = body
        self.bc = bc ?? []
        self.cc = cc ?? []
        super.init()
        if let pictureUrl = URL(string: pictureUrl ?? "") {
            self.pictureUrl = pictureUrl
            self.downloadThumbnail(url: pictureUrl)
        }
    }
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let datetime = Date(fromString: json["datetime"] as? String ?? ""),
            let from = json["from"] as? String,
            let fromName = json["name"] as? String,
            let to = json["to"]  as? String,
            let subject = json["subject"]  as? String,
            let body = json["body"] as? String
            else {
                return nil
        }
        
        self.id = String(format: "%2d",id)
        self.datetime = datetime
        self.from = from
        self.fromName = fromName
        self.to = to
        self.subject = subject
        self.body = body
        self.bc = (json["bc"] as? [String]) ?? []
        self.cc = (json["cc"] as? [String]) ?? []
        super.init()
        if let urlString = (json["pictureUrl"] as? String), let pictureUrl = URL(string: urlString) {
            self.pictureUrl = pictureUrl
            self.downloadThumbnail(url: pictureUrl)
        }
    }
    
    private func downloadThumbnail(url: URL) {
        
        let session = URLSession(configuration: .default)
        
        let downloadThumbnailTask = session.dataTask(with: url) {[weak self]  (data, response, error) in

            if let e = error {
                print("Error downloading picture: \(e)")
            }
            
            if let imageData = data {
                if let thumbnail = UIImage(data: imageData) {
                    self?.thumbnail = thumbnail
                } else {
                   print("Error could not get image: Image is nil")
                }
            }
        }

        downloadThumbnailTask.resume()
    }
}
