@testable import App
import Fluent

extension User {
    static func create(
        userName: String = "Aqua_Retro",
        password: String = "test1Password",
        on database: Database
    ) throws -> User {
        let user = User(userName: userName, password: password)
        try user.save(on: database).wait()
        return user
    }
}
