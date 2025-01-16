import Testing
import Foundation
@testable import SDSCore

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    
    
}


//@available(macOS 14.0, *)
//@available(iOS 17.0, *)
//@Test("Error Test") func testError() {
//    let db = DatabaseModel()
//    
//    let errorMessage = "Error Test Message"
//    
//    db.passError(errorMessage)
//
//    #expect(db.errorMessage == errorMessage && db.showError == true)
//    
//    
//}
//
//
//@Suite("Auth Tests")
//struct SDSAuthTests {
//
//    let db = DatabaseModel()
//    
//    @Test("General GET Request", .tags(.apiCall))
//    func testGeneralGETRequest() async {
//        
//        let result: String? = await db.get(.init(apiRoute: .avaibility))
//        
//        #expect(result != nil)
//    }
//    
//    @Test
//    func serverAvaibilityCheck() async {
//        
//
//        do {
//            
//            let data: Data? = await db.get(.init(apiRoute: .avaibility))
//            
//            try #require(data != nil)
//            
//            if let data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
//                let code = jsonData["rawResponseValue"]
//                
//                #expect(code == "1")
//                
//            }
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//    @Test("Login", .tags(.apiCall))
//    func login() async {
//        
//        await db.login(username: "debug", password: "debug")
//        
//        #expect(db.profile != nil)
//        
//    }
//    
//    @Test("Append Student", .tags(.dataManipulation))
//    func appendStudent() async throws {
//        let newStudent = Student(name: "Mario", surname: "Rossi", classe: "class_id_test", attendedPacks: [], isGuardian: [], isIgnored: [], isModerator: [])
//    
//        do {
//            let data: Data? = await db.append(.init(apiRoute: .appendStudent), with: newStudent)
//            try #require(data != nil)
//            
//            if let data, let response = String(data: data, encoding: .utf8) {
//                #expect(response == .appendStudentSuccessResponse)
//            }
//            
//        } catch {
//            print("error")
//        }
//        
//    }
//    
//    @Test("Logout", .tags(.authentication))
//    func logout() async {
//        await db.logout()
//        #expect(db.profile == nil)
//    }
//    
//    @Test("Host Report")
//    func hostReport() async {
//        do {
//            
//            let data: Data? = try await db.get(.init(apiRoute: .hostReport))
//            
//            try #require(data != nil)
//            // Decode the data directly into `HostCapabilityReport`
//            let hostReport = try JSONDecoder().decode(HostCapabilityReport.self, from: data!)
//            
//            #expect(hostReport.system == "macOS")
//            
//        } catch {
//           print("Error in testing")
//        }
//    }
//    
//    
//}
//
//extension String {
//    
//    static let appendStudentSuccessResponse =  "{\"message\":\"Studente aggiunto con successo\"}"
//    
//}
