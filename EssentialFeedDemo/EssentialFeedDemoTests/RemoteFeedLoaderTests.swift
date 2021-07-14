//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedDemoTests
//
//  Created by Dhanraj Bhandari on 13/07/21.
//

import XCTest

class RemoteFeedLoader{
   // let client = HTTPClient.shared
    func load(){
        HTTPClient.shared.requestedURL = URL.init(string: "http://a-url.com")
    }
}
class HTTPClient {
    static var shared = HTTPClient()
    var requestedURL: URL?

    func get(from url: URL){}
}

class HTTPClientSpy: HTTPClient {
   override func get(from url: URL){
        self.requestedURL = url
    }
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_initdoesNotLoadDatFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDatFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
