import Foundation

protocol MailRepository {
    
    /**
     *  Loads all mails from the inbox.
     */
    func loadMails(success: @escaping  ([MailModel]) -> (), error: @escaping (Error) -> ())
    
    /**
     *  Sends a mail.
     */
    func send(mail: MailModel, success: @escaping () -> (), error: @escaping (Error) -> ())
}
