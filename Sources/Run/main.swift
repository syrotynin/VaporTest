import App

/// We have isolated all of our App's logic into
/// the App module because it makes our app
/// more testable.
///
/// In general, the executable portion of our App
/// shouldn't include much more code than is presented
/// here.
///
/// We simply initialize our Droplet, optionally
/// passing in values if necessary
/// Then, we pass it to our App's setup function
/// this should setup all the routes and special
/// features of our app
///
/// .run() runs the Droplet's commands, 
/// if no command is given, it will default to "serve"
let config = try Config()
try config.setup()

let drop = try Droplet(config)
try drop.setup()

/// Setting up the POST request with the secret key.
/// With a secret path to be sure that nobody else knows that URL.
/// https://core.telegram.org/bots/api#setwebhook
drop.post("587016124:AAE1oEftaxtad-nC-9aLxY3jCEj5-gZc8gM") { request in
    /// Let's prepare the response message text.
    var response: String = ""
    
    /// Chat ID from request JSON.
    let chatID: Int = request.data["message", "chat", "id"]?.int ?? 0
    /// Message text from request JSON.
    let message: String = request.data["message", "text"]?.string ?? ""
    /// User first name from request JSON.
    let userFirstName: String = request.data["message", "from", "first_name"]?.string ?? ""
    
    /// Check if the message is empty
    if message.isEmpty {
        /// Set the response message text.
        response = "I'm sorry but your message is empty 😢"
        /// The message is not empty
    } else {
        /// Check if the message is a Telegram command.
        if message.hasPrefix("/") {
            /// Check what type of command is.
            switch message {
            /// Start command "/start".
            case "/start":
                /// Set the response message text.
                response = "Welcome to SwiftyBot " + userFirstName + "!\n" +
                "To list all available commands type /help"
            /// Help command "/help".
            case "/help":
                /// Set the response message text.
                response = "Welcome to SwiftyBot " +
                    "an example on how create a Telegram bot with Swift using Vapor.\n" +
                    "https://www.fabriziobrancati.com/posts/how-create-telegram-bot-swift-vapor-ubuntu-macos\n\n" +
                    "/start - Welcome message\n" +
                    "/help - Help message\n" +
                "Any text - Returns the reversed message"
            /// Command not valid.
            default:
                /// Set the response message text and suggest to type "/help".
                response = "Unrecognized command.\n" +
                "To list all available commands type /help"
            }
            /// It isn't a Telegram command, so creates a reversed message text.
        } else {
            /// Set the response message text.
            response = message
        }
    }
    
    /// Create the JSON response.
    /// https://core.telegram.org/bots/api#sendmessage
    return try JSON(node:
        [
            "method": "sendMessage",
            "chat_id": chatID,
            "text": response
        ]
    )
}

try drop.run()
