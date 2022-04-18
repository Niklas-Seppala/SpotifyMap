import Foundation

struct AuthResponse: Codable, CustomStringConvertible {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
    public var description: String {
        return "ACESS TOKEN: \(self.access_token)\nREFRESH TOKEN: \(self.refresh_token ?? "null")\nEXPIRATION: \(self.expires_in)"
    }
}
