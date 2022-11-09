@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    let userUserName = "Alice"
    let userPassword = "kitten12"
    let usersURI = "/api/users/"
    var app: Application!
    
    override func setUpWithError() throws {
        app = try Application.testable()
    }
    override func tearDownWithError() throws {
        app.shutdown()
    }
    func testUsersCanBeRetrievedFromAPI() throws {
        let user = try User.create(userName: userUserName, password: userPassword, on: app.db)
        _ = try User.create(on: app.db)
        try app.test(.GET, usersURI, afterResponse: {
            response in
            XCTAssertEqual(response.status, .ok)
            let users = try response.content.decode([User].self)
            
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users[0].userName, userUserName)
            XCTAssertEqual(users[0].password, userPassword)
            XCTAssertEqual(users[0].id, user.id)
        })
    }
    func testUserCanBeSavedWithAPI() throws {
        let user = User(userName: userUserName, password: userPassword)
        
        try app.test(.POST, usersURI, beforeRequest: {
            req in
            try req.content.encode(user)
        }, afterResponse: { response in
            let receivedUser = try
            response.content.decode(User.self)
            XCTAssertEqual(receivedUser.userName, userUserName)
            XCTAssertEqual(receivedUser.password, userPassword)
            XCTAssertNotNil(receivedUser.id)
            
            try app.test(.GET, usersURI, afterResponse: {secondResponse in
                let users =
                try secondResponse.content.decode([User].self)
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users[0].userName, userUserName)
                XCTAssertEqual(users[0].password, userPassword)
                XCTAssertEqual(users[0].id, receivedUser.id)
            })
        })
    }
    func testGettingASingleUserFromTheAPI() throws {
        // 1
        let user = try User.create(userName: userUserName, password: userPassword, on: app.db)
        
        // 2
        try app.test(.GET, "\(usersURI)\(user.id!)",
                     afterResponse: { response in
            let receivedUser = try response.content.decode(User.self)
            // 3
            XCTAssertEqual(receivedUser.userName, userUserName)
            XCTAssertEqual(receivedUser.password, userPassword)
            XCTAssertEqual(receivedUser.id, user.id)
        })
    }
    func testDeletingASingleUserFromTheAPI() throws {
        let user = try User.create(userName: userUserName, password: userPassword, on: app.db)
        try app.test(.DELETE, "\(usersURI)\(user.id!)", afterResponse: {
            response in
            XCTAssertEqual(response.status, .noContent)
            
        })
    }
}
