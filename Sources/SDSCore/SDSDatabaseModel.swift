//
//  DatabaseModel.swift
//  SDSCore
//
//  Created by Sese on 03/01/25.
//

import Foundation
import Combine

@Observable
///La classe principale del Database Locale della SDS, contenente i dati caricati e le chiamate API al server custom, avviato dall'organizzazione.
///
///``Profile``
///

public class SDSLDBModel {
    
    public init(
        students: [Student] = [],
        packs: [Pack] = [],
        classes: [Classe] = [],
        conferences: [Conference] = [],
        days: [Day] = [],
        profile: Profile? = nil,
        isLoading: Bool = false,
        showError: Bool = false,
        errorMessage: String = "",
        serverURL: String = "http://localhost:3000"
    ) {
        self.students = students
        self.packs = packs
        self.classes = classes
        self.conferences = conferences
        self.days = days
        self.profile = profile
        self.isLoading = isLoading
        self.showError = showError
        self.errorMessage = errorMessage
        self.serverURL = serverURL
    }
    
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
    
    ///Il profilo utilzzato per accedere al server ed effettuare le chiamate ai file.
    ///
    ///Al primo avvio, l'applicazione chiederà all'utente di effettuare il login
    ///
    public var profile: Profile?
    
    public var isLoading: Bool = false
    
    public var showError: Bool = false
    public var errorMessage: String = ""
    
    
    public var serverURL = "http://localhost:3000"
    
    public func passError(_ error: String) {
        
        print(errorMessage)
        
        
        errorMessage = error
        showError = true
    }
    
    public func dismissError() {
        showError = false
        errorMessage = ""
    }
    
    public func documentDirectoryURL() async throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    public func fetchAvailability() async throws  {
        // Define the server URL (replace with your actual server URL)
        let urlString = "http://localhost:3000/\(API.init(apiRoute: .avaibility).route)"
        
        // Safely construct the URL
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"])
        }
        
        // Create the URLRequest
        let request = URLRequest(url: url)
        
        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Invalid server response."])
        }
        
        // Convert the data to a plain string
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response to string."])
        }
        
        print(responseString)
    }
    
    public enum ResultData<T> {
        case item(T)
        case array([T])
    }
    
    public func get<T: Decodable>(_ api: API) async -> ResultData<T>? {
        
        do {
            
            guard let url = URL(string: "http://localhost:3000/\(api.route)") else {
                passError("Invalid URL")
                throw ServerError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = api.method.rawValue
            
            let (data, resp) = try await URLSession.shared.data(for: request)
            
            guard let response = resp as? HTTPURLResponse else {
                passError("Invalid response")
                throw ServerError.invalidResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                passError("Server error: \(response.statusCode)")
                return nil
            }
            
            let decoder = JSONDecoder()
            
            do {
                let arrayResults = try decoder.decode([T].self, from: data)
                return .array(arrayResults)
            } catch let error as DecodingError {
                if case .typeMismatch = error {
                    
                    do {
                        let item = try decoder.decode(T.self, from: data)
                        return .item(item)
                    } catch {
                        passError("Error in decodign single file, \(error)")
                        throw ServerError.decodingError
                    }
                    
                } else {
                    passError("Error in decoding some file, \(error)")
                    throw ServerError.decodingError
                }
        
            } catch {
                passError("Error in decoding array file: \(error)")
                throw ServerError.decodingError
            }
            
        } catch let urlError as URLError {
            passError("URL ERROR: \(urlError)")
            return nil
        } catch {
            passError("Error in get: \(error)")
            return nil
        }
        
        
        
//
//        do {
//            
//            guard let url = url else {
//                throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(String(describing: url))"])
//            }
//            
//            var request = URLRequest(url: url)
//            
//            request.httpMethod = api.method.rawValue
//            
//            let (data, urlResponse) = try await URLSession.shared.data(for: request)
//            
//            guard let response = urlResponse as? HTTPURLResponse else {
//                throw ServerError.invalidURL
//            }
//            
//            if response.statusCode == 500 {
//                throw ServerError.invalidData
//            }
//            
//            
//            return (data as? T)
//            
//        } catch {
//            // Log or handle the error as needed
//            passError("\(error.localizedDescription), \(error)")
//            
//            return nil
//        }

    }
    
    public func login(username: String, password: String) async {
        
        
        do {
            
            let url = URL(string: "http://localhost:3000/api/login")
            
            guard let loginRoute = url else {
                throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(String(describing: url))"])
            }
            
            var request = URLRequest(url: loginRoute)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encodedProfile : [String: String] = [
                "username": username,
                "secureCode": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: encodedProfile)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServerError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw ServerError.invalidHTTPStatus
            }
            
            guard let decodedResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw ServerError.decodingError
            }
            
            let message = decodedResponse["message"]
            let authState = decodedResponse["authState"]
            let sessionID = decodedResponse["session_id"] as? String
            let activeSessions = decodedResponse["user_authorized_sessions_list"] as? [String]
            
            let finalProfile = Profile(username: username, secureCode: password, sessionID: sessionID ?? "", activeSessions: activeSessions ?? [])
            
            #if DEBUG
            print(message, authState, sessionID, activeSessions)
            #endif
            
            profile = finalProfile
            
        } catch {
            print(error)
        }
        
    }
    
    public func logout() async {
        
        do {
            
            let logoutRoute = URL(string: "http://localhost:3000/api/logout")
            
            guard let url = logoutRoute else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Status Code: \(response.statusCode)")
                
                await removeCookies()
                profile = nil
                
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func removeCookies() async {
        
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            cookies.forEach { storage.deleteCookie($0) }
        }
        
    }
    
    ///Rimuove i Cookie creati dopo il login dell'utente
    func removeCookie(_ cookie: String) async {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            cookies.forEach {
                $0.name == cookie ? storage.deleteCookie($0) : nil
            }
        }
    }
    
    public var cancellables = Set<AnyCancellable>()
    let url = "http://localhost:3000/"
    
    ///Request single file from the server
    public func request<T: SDSEntity>(api: API, with body: T? = nil) -> AnyPublisher<[T], Error> {
        
        guard let url = URL(string: url + api.route) else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Error in URL"])).eraseToAnyPublisher()
                
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return Fail(error: ServerError.invalidData)
                    .eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { datas -> Data in
                return datas.data
            }
            .decode(type: [T].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
      
    }
    
    
    private var docmentDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    ///Salva in un file sicuro, all'interno dello spazio di archiviazione riservato all'app, la sessione dell'utente
    private func saveUser(_ user: Profile) async throws {
        do {
            let data = try JSONEncoder().encode(user)
            try data.write(to: docmentDirectory.appendingPathComponent("user_session.json"))
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    ///Carica da un file sicuro, all'interno dello spazio di archiviazione riservato all'app, la sessione dell'utente precedentemente avviata.
    private func loadUser() async throws {
        do {
            let data = try Data(contentsOf: docmentDirectory.appendingPathComponent("loggerd_user.json"))
            profile = try JSONDecoder().decode(Profile.self, from: data)
        } catch {
            print("Error loading user: \(error)")
        }
    }
    
    public func getDays(from day: Day?) -> String? {
        return days.first {
            $0 == day
        }?.id
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
        }
    }
    
}


