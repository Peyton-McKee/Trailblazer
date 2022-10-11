import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymsController = AcronymsController()
    let usersController = UsersController()
    try app.register(collection: acronymsController)
    try app.register(collection: usersController)
}
