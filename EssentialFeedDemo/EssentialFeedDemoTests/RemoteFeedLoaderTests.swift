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
    static let shared = HTTPClient()
    private init(){}
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_initdoesNotLoadDatFromURL(){
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDatFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
