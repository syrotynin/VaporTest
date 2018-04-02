import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        /// Setting up the POST request with the secret key.
        /// With a secret path to be sure that nobody else knows that URL.
        /// https://core.telegram.org/bots/api#setwebhook
        post("testwebhhok") { request in
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
                    case "/kek":
                        /// Set the response message text.
                        if userFirstName == "SerhiiSyrotynin" {
                            response = userFirstName + " loshok"
                        }
                        else {
                            response = userFirstName + ", Welcome to СЕРЕГА&CAHE4EK_CREW!\n"
                        }
                    /// Help command "/help".
                    case "/help":
                        /// Set the response message text.
                        response = "use /kek"
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
        
        try resource("posts", PostController.self)
    }
}
