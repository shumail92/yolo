

class Injector {
    private static var mailRepository: MailRepository?
    
    static func provideMailRepository() -> MailRepository {
        if mailRepository == nil {
            mailRepository = JSONMockMailRepository(fileName: "mails")
        }
        
        return mailRepository!
    }
}
