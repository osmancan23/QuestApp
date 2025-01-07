import XCTest
@testable import QuestApp

final class AuthManagerTests: XCTestCase {
    var sut: AuthManager!
    
    override func setUp() {
        super.setUp()
        sut = AuthManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Given - When
        // AuthManager oluşturulduğunda
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.currentUsername, "user")
    }
    
    func testSetUsername() {
        // Given
        let newUsername = "testUser"
        
        // When
        sut.setUsername(newUsername)
        
        // Then
        XCTAssertEqual(sut.currentUsername, newUsername)
    }
    
    func testLogout() {
        // Given
        sut.isLoggedIn = true
        sut.currentUsername = "testUser"
        
        // When
        sut.logout()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.currentUsername, "user")
    }
} 
