//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedDemoTests
//
//  Created by Dhanraj Bhandari on 13/07/21.
//

import XCTest

class RemoteFeedLoader{
    let client : HTTPClient
    let url : URL
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    func load(){
        self.client.get(from: url)
    }
}
protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    func get(from url: URL) {
        self.requestedURL = url
    }
    var requestedURL: URL?

}

class RemoteFeedLoaderTests: XCTestCase {

    func test_initdoesNotLoadDatFromURL(){
        let client = HTTPClientSpy()
        let url = URL.init(string: "http://a-url.com")!
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDatFromURL(){
        let client = HTTPClientSpy()
        let url = URL.init(string: "http://a-given-url.com")!

        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
