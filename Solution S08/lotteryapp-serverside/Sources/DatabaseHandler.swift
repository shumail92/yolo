import Foundation
import MongoDB


/**
 Creates a connection to the MongoDB server, to the given database [dbName], and to the given
 collection [collectionName]
 
 - parameter uri: URI to the MongoDB server
 - parameter dbName: name of the database
 - parameter collectionName: name of the collection
 
 - return: tuple MongoClient, MongoDatabase, and MongoCollection objects
 */
func startDB(uri: String, dbName: String, collectionName: String)
    -> (MongoClient, MongoDatabase, MongoCollection) {
    let dbClient: MongoClient = try! MongoClient(uri: uri)
    let db: MongoDatabase = dbClient.getDatabase(name: dbName)
    let collection: MongoCollection = getCollection(db: db, collectionName: collectionName)
    
    return (dbClient, db, collection)
}

// Creates a connection to a collection if it exists. Otherwise, creates the collection
func getCollection( db: MongoDatabase, collectionName: String) -> MongoCollection {
    
    // get all the collections avaliable in the specified database [db]
    let collections: [String] = db.collectionNames()
    
    // check whether the collection exists or not
    if !collections.contains(collectionName) {
        _ = db.createCollection(name: collectionName, options: nil)
    }
    
    return  db.getCollection(name: collectionName)!
}
