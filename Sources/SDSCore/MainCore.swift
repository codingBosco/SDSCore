//
//  ServerCore.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation
import Combine

public enum AuthState {
    
    case hasToLog
    case isLoggingFromID
    case logging
    case logged
    
}

@Observable
///La classe principale del Server della SDS, contenente i dati caricati e le chiamate API al server custom, avviato dall'organizzazione.
///
///``Profile``
///
public class MainCore {
    
    public init() { }
    

    ///When true, the AppStorage persistent value "canTryLoginFirst" is resetted to true and the session will be initialized.
    public var shouldRecheckLogin = false
    
    ///Gli studenti caricati dal server all'avvio dell'app.
    public var students: [Student] = []
    
    ///I Pacchetti caricati dal server all'avvio dell'app.
    public var packs: [Pack] = []
    
    ///Le classi caricate dal server all'avvio dell'app.
    public var classes: [Classe] = []
    
    ///Le conferenze caricatei dal server all'avvio dell'app.
    public var conferences: [Conference] = []
    
    ///I giorni caricati dal server all'avvio dell'app.
    public var days: [Day] = []
    
    public var tranches: [Tranche] = []
    
    ///Il profilo utilzzato per accedere al server ed effettuare le chiamate ai file.
    ///
    ///Al primo avvio, l'applicazione chiederà all'utente di effettuare il login
    ///
    public var profile: Profile?
    public var authState: AuthState = .hasToLog
    
    public var isLoading: Bool = false
    
    public var showError: Bool = false
    public var errorMessage: String = ""
    
    public var serverURL = "http://localhost:3000"
    public var socketURL = "ws://localhost:3000"
    
    public var isConnected = false
    public var isWebSocketConnected = false
    
    //TODO: If app device storage is local invalidate the timer. Change it to Timer? and manage it at app boot.
    public let serverCheckTimer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    
    public var cancellables = Set<AnyCancellable>()
    
    public func passError(_ error: String) {
        
        print(errorMessage)
        
        
        errorMessage = error
        showError = true
    }
    
    public func dismissError() {
        showError = false
        errorMessage = ""
    }
    
    ///Calls a POST function to the server's specified API with a body made up by only one item
    public func write<T: SDSEntity>(to api: API, with body: T) -> AnyPublisher<String, Error> {
        guard let url = URL(string: "\(serverURL)/\(api.route)") else {
            return Fail(error: ServerError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let encodedBody = try? JSONEncoder().encode(body) else {
            return Fail(error: ServerError.invalidData)
                .eraseToAnyPublisher()
        }
        
        request.httpBody = encodedBody
       
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      response.statusCode != 200 else {
                    throw URLError(.badServerResponse)
                }
                
                print("ENCODED DATA: \(String(data: encodedBody, encoding: .utf8) ?? "ERROR ENCODED DATA")")
                return String(data: $0.data, encoding: .utf8) ?? "error in response"
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    ///Calls a GET function from the server's specified API to receive different items
    public func get<T: SDSEntity>(allFrom api: API, for type: [T].Type) -> AnyPublisher<[T], Error> {
        
        guard let url = URL(string: "\(serverURL)/\(api.route)") else {
            print("Invalid URL")
            return Fail(error: ServerError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return $0.data
            }
            .decode(type: [T].self, decoder: JSONDecoder())
            .catch({ error -> AnyPublisher<[T], Error> in
                print("Decoding error: \(error.localizedDescription), \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    ///Calls a GET function from the server's specified API to receive only one item
    public func get<T: SDSEntity>(from api: API, for type: T.Type) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: "\(serverURL)/\(api.route)") else {
            print("Invalid URL")
            return Fail(error: ServerError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch({ error -> AnyPublisher<T, Error> in
                print("Decoding error: \(error.localizedDescription), \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    ///Call a GET function from the server in an async way with a completion handler that passes the response item's data.
    public func get<T: Codable>(_ api: API, for type: T.Type, completionHandler: @escaping (T)->Void) async {
        do {
            guard let url = URL(string: "\(serverURL)/\(api.route)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = api.method.rawValue
           
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(decodedData)
                } catch {
                    print("Errore di decoding: \(error)")
                }
            } else {
                print("Errore nella risposta del server: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    ///Call a GET function from the server with a completion handler that ignores the response.
    public func get(_ api: API, completionHandler: @escaping ()->Void) async {
        do {
            guard let url = URL(string: "\(serverURL)/\(api.route)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = api.method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completionHandler()
            } else {
                print("Errore nella risposta del server: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    ///A function that authenticate the user with a given password (a.k.a secureCode) and return a LoginResponse for the app
    public func login(username: String, secureCode: String, completionHandler: @escaping (LoginRespone)->Void) async {
        do {
            guard let loginRoute = URL(string: "\(serverURL)/api/login/user=\(username)") else {
                throw ServerError.invalidURL
            }
            
            var request = URLRequest(url: loginRoute)
            request.httpMethod = "POST"
            
            let passwordData : [String: String] = [
                "secureCode": secureCode
            ]
            
            request.httpBody = try JSONEncoder().encode(passwordData)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (loginData, response) = try await URLSession.shared.data(for: request)
            
            if let statusResponse = response as? HTTPURLResponse {
                
                switch statusResponse.statusCode {
                case 200:
                    let loginResponse = try JSONDecoder().decode(LoginRespone.self, from: loginData)
                    completionHandler(loginResponse)
                case 404:
                    
                    throw ServerError.invalidServerResource
                    
                case 401:
                    
                    throw ServerError.userNotFound
                default:
                   
                    throw ServerError.responseDecodingError
                }
            }
            
        } catch {
            
            if let serverError = error as? ServerError {
                let errorString = "error in login performing: \(serverError.localizedDescription)"
                
                print(errorString)
                passError(errorString)
            } else {
                print("Other error type in login: \(error.localizedDescription), \(error)")
            }
        }
    }
    
    ///A function that confirm the authentication made by the app and return a full Profile for the app from the Server sessions.data file.
    public func login(username: String, sessionID: String) async -> Profile? {
        var profile: Profile?
        do {
            
            guard let loginRoute = URL(string: "\(serverURL)/api/login/user=\(username)/by_session=\(sessionID)") else {
                throw ServerError.invalidURL
            }
            
            var request = URLRequest(url: loginRoute)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            if let statusResponse = response as? HTTPURLResponse {
                switch statusResponse.statusCode {
                    
                case 200:
                    print("Logged")
                    profile = Profile(username: username, secureCode: "", sessionID: sessionID, activeSessions: [])
                    
                    //TODO: Save the Server's URL Address
                    
                default:
                    throw ServerError.invalidResponse
                }
            }
        } catch {
            if let ServerError = error as? ServerError {
                let errorString = "error in login with session: \(ServerError.localizedDescription)"
                print(errorString)
                passError(errorString)
            } else {
                print("Other error: \(error.localizedDescription)")
            }
            
            return nil
        }
        return profile
    }
    
    
    public func getDays(from day: Day?) -> String? {
        return days.first {
            $0 == day
        }?.id
    }
    
    ///The app will connect to the server's websocket for continuosly listening and istant updates
    func connectToSocket() async {
        do {
            let socketSessions = URLSession(configuration: .default)
            guard let url = URL(string: socketURL) else {
                print("Incorrect URL for web Socket")
                throw ServerError.invalidURL
            }
            webSocketTask = socketSessions.webSocketTask(with: url)
            
            webSocketTask?.resume()
            isWebSocketConnected = true
            try await self.receiveFromSocket()
           
            
        } catch {
            print("Error in webSocket Connection: \(error)")
        }
    }
    
    
    ///The app will disconnect from the server's websocket with a speicified reason closure and data
    func disconnectFromSocket(with closing: URLSessionWebSocketTask.CloseCode = .normalClosure, reasonData: Data? = nil ) {
        webSocketTask?.cancel(with: closing, reason: reasonData)
        isWebSocketConnected = false
    }
    
    
    ///Sends a simple message to the socket, like an action or advertisement
    func sendToSocket(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
            print("sended!")
        }
    }
    
    ///Sends a complex payload to the server, generally used for data editing and large size actions.
    func sendToSocket(with payload: Payload) async {
        do {
            let data = try JSONEncoder().encode(payload)
            let message = URLSessionWebSocketTask.Message.data(data)
            try await webSocketTask?.send(message)
        } catch {
            print("Error in sending payload: \(payload)")
        }
    }
    
    ///The app listens to the socket for messages and responses.
    func receiveFromSocket() async throws {
        let response = try await webSocketTask?.receive()
        switch response {
        case .data(let data):
            print("[WEBSOCKET]: Received Data: \(String(describing: String(data: data, encoding: .utf8)))")
        case .string(let string):
            print("[WEBSOCKET]: Received Message: \(string)")
        case .none:
            print("Error in reaving")
        @unknown default:
            throw ServerError.unknownSocketResponse
        }
    }
    
    
    ///A function that check all the connections to the server.
    public func checkConnection() async {
        await get(.routeTo(.avaibility), for: Response.self) { response in
            if response.result == "success" {
                self.isConnected = true
               
            }
        }
        
        if !isWebSocketConnected {
            await connectToSocket()
        }
    }
    
    public func loadStudents() async {
        await get(allFrom: .routeTo(.students), for: [Student].self)
            .sink(receiveCompletion: { com in
                if case .failure(let failure) = com {
                    print("Student Loads: \(failure)")
                }
                
            }) { data in
                self.students = data
            }.store(in: &cancellables)
    }
    
    public func loadClasses() async {
        await get(allFrom: .routeTo(.classes), for: [Classe].self)
            .sink(receiveCompletion: { com in
                if case .failure(let failure) = com {
                    print("Error in classes load, \(failure.localizedDescription)")
                }
                
            }) { data in
                self.classes = data
            }.store(in: &cancellables)
    }
    
    public func loadTranches() async {
        await get(allFrom: .routeTo(.tranches), for: [Tranche].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("Error in tranches load, \(failure.localizedDescription), \(failure)")
                }
            }) { tranches in
                self.tranches = tranches
            }.store(in: &cancellables)
    }
    
    public func loadDays() async {
        await get(allFrom: .routeTo(.days), for: [Day].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("Error in days load, \(failure.localizedDescription)")
                }
            }) { days in
                self.days = days
            }.store(in: &cancellables)
    }
    
    public func loadPacks() async {
        await get(allFrom: .routeTo(.packs), for: [Pack].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("Error in packs load, \(failure.localizedDescription)")
                }
            }) { packs in
                self.packs = packs
            }.store(in: &cancellables)
    }
    
    public func loadConferences() async {
        await get(allFrom: .routeTo(.conferences), for: [Conference].self)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("Error in conference load, \(failure.localizedDescription)")
                }
            }) { confs in
                self.conferences = confs
            }.store(in: &cancellables)
    }
    
    
    
    
    //MARK: Local Functions
    
    private static var localDocumentDirectory: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Couldn't get document directory, error: \(error.localizedDescription)")
        }
    }
    
    public static var tranchesFile: URL {
        return localDocumentDirectory.appendingPathComponent("tranches.data")
    }
    
    public static var packsFile: URL {
        return localDocumentDirectory.appendingPathComponent("packs.data")
    }
    
    public static var classesFile: URL {
        return localDocumentDirectory.appendingPathComponent("classes.data")
    }
    
    public static var conferencesFile: URL {
        return localDocumentDirectory.appendingPathComponent("conferences.data")
    }
    
    public static var studentsFile: URL {
        return localDocumentDirectory.appendingPathComponent("students.data")
    }
    
    public static var daysFile: URL {
        return localDocumentDirectory.appendingPathComponent("days.data")
    }
    
    public func localLoadAll() async {
        do {
            try await tranches = localLoad(itemType: .tranche)
            try await days = localLoad(itemType: .days)
            try await students = localLoad(itemType: .students)
            try await classes = localLoad(itemType: .classes)
            try await conferences = localLoad(itemType: .conferences)
            try await packs = localLoad(itemType: .packs)
        } catch {
            print("Couldn't load: \(error)")
        }
    }
    
    public func localSaveAll() async throws {
        try await localSave(items: days, for: .days)
        try await localSave(items: tranches, for: .tranche)
        try await localSave(items: students, for: .students)
        try await localSave(items: packs, for: .packs)
        try await localSave(items: conferences, for: .conferences)

        try await localSave(items: classes, for: .classes)

    }
    
    ///Locally saves a collection of items in a given file path
    public func localSave<T: SDSEntity>(items: [T], for itemType: ItemEntity, inFile: String) async throws {
        do {
            let data = try JSONEncoder().encode(items)
            let output = MainCore.localDocumentDirectory.appendingPathComponent("\(inFile).data")
            try data.write(to: output)
        } catch {
            print("Could't save the files")
        }
    }
    
    ///Loads a collection of items from a given file path
    public func localLoad<T: SDSEntity>(from fileName: String, itemType: ItemEntity) async throws -> [T] {
        do {
            guard let data = try? Data(contentsOf: MainCore.localDocumentDirectory.appendingPathComponent("\(fileName).data")) else {
                throw ServerError.decodingError
            }
            
            let items = try JSONDecoder().decode([T].self, from: data)
            return items
        } catch {
            print("Couldn't load \(itemType.rawValue), due to: \(error)")
            return []
        }
    }
    
    ///Locally load a collection of items from the corresponding file path
    public func localLoad<T: SDSEntity>(itemType: ItemEntity) async throws -> [T] {
        do {
            guard let data = try? Data(contentsOf: itemType.directoryURL) else {
                throw ServerError.decodingError
            }
            
            let items = try JSONDecoder().decode([T].self, from: data)
            return items
        } catch {
            print("Couldn't load \(itemType.rawValue), due to: \(error)")
            return []
        }
    }
    
    
    public func localSave<T: SDSEntity>(items: [T], for itemType: ItemEntity) async throws {
        do {
            let data = try JSONEncoder().encode(items)
            let output = itemType.directoryURL
            try data.write(to: output)
           
        } catch {
            print("Could't save the files")
        }
    }
    
    public enum ItemEntity: String, CaseIterable {
        case tranche
        case packs
        case classes
        case conferences
        case students
        case days
        
        var directoryURL: URL {
            switch self {
            case .tranche:
                return tranchesFile
            case .packs:
                return packsFile
            case .classes:
                return classesFile
            case .conferences:
                return conferencesFile
            case .students:
                return studentsFile
            case .days:
                return daysFile
            }
        }
        
    }
    
}

public enum ServerError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case invalidHTTPStatus
    
    case unauthorized
    case decodingError
    
    case responseDecodingError
    
    case invalidServerResource
    
    case userNotFound
    
    case unknownSocketResponse
    
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        case .invalidURL:
            return "Invalid URL"
        case .invalidHTTPStatus:
            return "Invalid HTTP status"
        case .unauthorized:
            return "Unauthorized"
        case .decodingError:
            return "Error in decoding files"
        case .responseDecodingError:
            return "Error in decoding plain response from the server"
        case .invalidServerResource:
            return String(localized: "Server Route not found, maybe the URL of the request is changed in the server or it was to write correctly", comment: "String for ther error 404 in login API")
        case .userNotFound:
            return "User not found"
        case .unknownSocketResponse:
            return "Unknwon response from the socket"
        }
    }
    
}

///The data structure that define the data sent from the server when the user try to perform login.
public struct LoginRespone: Codable {
    
    ///The status of the user and its login
    public var status: String
    
    ///The session unique code given from the server, added to the profile, that certificate the device's authentication
    public var session: String
    
    public enum CodingKeys: String, CodingKey {
        
        case status = "response_status"
        case session = "logged_for_session"
        
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.session = try container.decode(String.self, forKey: .session)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.session, forKey: .session)
    }
    
    public init() {
        self.status = "unlogged"
        self.session = "unavailable"
    }
    
}



public struct Response: Codable, Sendable {
    
    public let result: String
    public let message: String
    
}


public struct Payload: Codable {
    
    public let payloadID: String
    public let from: String
    public let action: PayloadAction
    //TODO: Change targetClass to a enum
    public let targetClass: String
    public let targetID: String
    public let interpolators: [PayloadInterpolator]
    
    public nonisolated init(
        payloadID: String = "payload_share_\(UUID().uuidString.lowercased())",
        from: String,
        action: PayloadAction,
        targetClass: String,
        targetID: String,
        interpolators: [PayloadInterpolator]
    ) {
        self.payloadID = payloadID
        self.from = from
        self.action = action
        self.targetClass = targetClass
        self.targetID = targetID
        self.interpolators = interpolators
    }
    
    public enum CodingKeys: String, CodingKey {
        case payloadID
        case from
        case action
        case targetClass
        case targetID
        case interpolators
    }
    
    public init(from decoder: any Decoder) throws {
        let ct = try decoder.container(keyedBy: CodingKeys.self)
        
        payloadID = try ct.decode(String.self, forKey: .payloadID)
        from = try ct.decode(String.self, forKey: .from)
        action = try ct.decode(PayloadAction.self, forKey: .action)
        targetClass = try ct.decode(String.self, forKey: .targetClass)
        targetID = try ct.decode(String.self, forKey: .targetID)
        interpolators = try ct.decode([PayloadInterpolator].self, forKey: .interpolators)
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        var ct = encoder.container(keyedBy: CodingKeys.self)
        
        try ct.encode(payloadID, forKey: .payloadID)
        try ct.encode(from, forKey: .from)
        try ct.encode(action, forKey: .action)
        try ct.encode(targetClass, forKey: .targetClass)
        try ct.encode(targetID, forKey: .targetID)
        try ct.encode(interpolators, forKey: .interpolators)
        
    }
    
}

extension Payload {
    public struct PayloadInterpolator: Codable {
        
        public var field: String
        public var updatedValue: AnyCodable

    }
}


public enum PayloadAction: String, Codable {
    case add = "ADD"
    case update = "UPDATE"
    case remove = "REMOVE"
}

public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: any Decoder) throws {
        let ct = try decoder.singleValueContainer()
        
        if let int = try? ct.decode(Int.self) {
            self.value = int
        } else if let doubleVal = try? ct.decode(Double.self) {
            self.value = doubleVal
        } else if let boolVal = try? ct.decode(Bool.self) {
            self.value = boolVal
        } else if let stringVal = try? ct.decode(String.self) {
            self.value = stringVal
        } else if let dict = try? ct.decode([String: AnyCodable].self) {
            self.value = dict.mapValues { $0.value }
        } else if let array = try? ct.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let date = try? ct.decode(Date.self) {
            self.value = date
        }
        else {
            throw DecodingError.dataCorruptedError(in: ct, debugDescription: "Tipo non supportato")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
            var ct = encoder.singleValueContainer()

            switch value {
            case let intVal as Int:
                try ct.encode(intVal)
            case let doubleVal as Double:
                try ct.encode(doubleVal)
            case let boolVal as Bool:
                try ct.encode(boolVal)
            case let stringVal as String:
                try ct.encode(stringVal)
            case let dict as [String: Any]:
                try ct.encode(dict.mapValues { AnyCodable($0) })
            case let array as [Any]:
                try ct.encode(array.map { AnyCodable($0) })
            case let date as Date:
                try ct.encode(date)
            default:
                throw EncodingError.invalidValue(value, .init(codingPath: ct.codingPath, debugDescription: "Tipo non supportato"))
            }
        }
}
