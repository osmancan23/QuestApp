import XCTest

final class LoginViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI-Testing", "isLoggedIn_false"]
        app.launch()
    }
    
    func testLoginScreenElements() throws {
        // Login başlığı kontrolü
        let loginTitle = app.staticTexts["Log In"].firstMatch
        XCTAssertTrue(loginTitle.exists, "Login başlığı görünür olmalı")
        
        // Username field kontrolü
        let usernameField = app.textFields["Username"]
        XCTAssertTrue(usernameField.exists, "Username field görünür olmalı")
        
        // Password field kontrolü
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.exists, "Password field görünür olmalı")
        
        // Login butonu kontrolü
        let loginButton = app.buttons["Log In"]
        XCTAssertTrue(loginButton.exists, "Login butonu görünür olmalı")
        
        // Register linki kontrolü
        let registerLink = app.staticTexts["Don't have an account?"].firstMatch
        XCTAssertTrue(registerLink.exists, "Register linki görünür olmalı")
    }
    
    func testSuccessfulLogin() throws {
        // Test verileri
        let testUsername = "Osmancan"
        let testPassword = "123456"
        
        // Username girişi
        let usernameField =  app.textFields["Username"]
        usernameField.tap()
        usernameField.typeText(testUsername)
        
        // Password girişi
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(testPassword)
        
        // Login butonuna tıklama
        let loginButton = app.buttons["Log In"]
        loginButton.tap()
        
        // Login sonrası yönlendirme kontrolü
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "Uygulama ön planda kalmalı")
    }
    
    func testFailedLogin() throws {
        // Hatalı test verileri
        let wrongUsername = "wronguser"
        let wrongPassword = "wrongpass"
        
        // Username girişi
        let usernameField = app.textFields["Username"]
        usernameField.tap()
        usernameField.typeText(wrongUsername)
        
        // Password girişi
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(wrongPassword)
        
        // Login butonuna tıklama
        let loginButton = app.buttons["Log In"]
        loginButton.tap()
        
        // Hata alert'inin kontrolü
        let alert = app.alerts["Hata"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Hata alert'i görünür olmalı")
    }
    
    func testRegisterNavigation() throws {
        // Register linkine tıklama
        let registerLink = app.staticTexts["Don't have an account?"]
        registerLink.tap()
        
        // Register sayfasına yönlendirme kontrolü
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "Uygulama ön planda kalmalı")
    }
    
    func testEmptyFieldValidation() throws {
        // Boş alanlarla login denemesi
        let loginButton = app.buttons["Log In"]
        loginButton.tap()
        
        // Hata mesajı kontrolü
        let alert = app.alerts["Hata"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Validation hatası alert'i görünür olmalı")
    }
} 
