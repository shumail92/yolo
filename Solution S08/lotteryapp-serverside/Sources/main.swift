import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MongoDB
import libmongoc


let dbUri = "mongodb://localhost"
let dbName = "test"
let collectionName = "lottery"


// Connect to the database
let (dbClient, db, collection): (MongoClient, MongoDatabase, MongoCollection) =
    startDB(uri: dbUri, dbName: dbName, collectionName: collectionName)

// Before the application shuts down, you want to close the communicatation to collection, db, and dbClicent
defer {
    collection.close()
    db.close()
    dbClient.close()
}

// Create a HTTP Server, bind it to a port, and add possible routes
let server = HTTPServer()
server.serverPort = 8080
server.addRoutes(generateRoutes());


do {
    try server.start()
} catch PerfectError.networkError(let err, let msg)  {
    print("Network Error! \(err) \(msg)")
}
