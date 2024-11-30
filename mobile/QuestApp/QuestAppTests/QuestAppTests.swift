//
//  QuestAppTests.swift
//  QuestAppTests
//
//  Created by Osmancan Akagündüz on 25.11.2024.
//

import XCTest
@testable import QuestApp

final class QuestAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchPostService()   {
        let manager = NetworkManager()
        
        // [PostModel] tipinde bir sonuç dönecek managerı kullan
        
        do{
            manager.fetch(onSuccess: { (posts: [PostModel]) in
                debugPrint(posts.count)
                XCTAssert(posts.isEmpty == false)
            }, onFailed: { error in
                print(error)
            }, route: .posts)
            
        }catch{
            print("hata")
        }
       
    }

    
    func testCreatePostService()   {
        let manager = NetworkManager()
       

        let requestData = CreatePostModel(
            id: 5,
            title: "Test Title",
            content: "This is a test post.",
            userId:  1
        )

    }
    
    func testLogin()  {
        let manager = NetworkManager()
        
        manager.post(onSuccess: { (response : AuthResponseModel) in
            print(response.accessToken)
            XCTAssert(response.accessToken.isEmpty == false)
        }, onFailed: { error in
            print(error)
        }, route: .login,body: AuthRequestModel(userName: "mustafa", password: "123456"))

    }
    
   
}
