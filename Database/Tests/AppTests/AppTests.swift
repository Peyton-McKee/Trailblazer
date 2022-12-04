@testable import App
import Fluent

extension User {
    static func create(
        userName: String = "Aqua_Retro",
        password: String = "test1Password",
        on database: Database
    ) throws -> User {
        let user = User(userName: userName, password: password, alertSettings: ["moguls", "icy"], routingPreference: "easiest")
        try user.save(on: database).wait()
        return user
    }
}
