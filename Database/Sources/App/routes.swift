import Fluent
import Vapor

func routes(_ app: Application) throws {
    let usersController = UsersController()
    try app.register(collection: usersController)
    let trailReportsController = TrailReportsController()
    try app.register(collection: trailReportsController)
    let userLocationsController = UserLocationController()
    try app.register(collection: userLocationsController)
    let userRoutesController = UserRoutesController()
    try app.register(collection: userRoutesController)
}
