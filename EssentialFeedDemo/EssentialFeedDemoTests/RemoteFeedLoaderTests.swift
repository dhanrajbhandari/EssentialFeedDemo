//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedDemoTests
//
//  Created by Dhanraj Bhandari on 13/07/21.
//

import XCTest
import EssentialFeedDemo

class RemoteFeedLoaderTests: XCTestCase {

    func test_initdoesNotLoadDatFromURL(){
        
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDatFromURL(){
        let url = URL.init(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs,[url])
    }
    func test_loadTwice_requestDatFromURLTwice(){
        let url = URL.init(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs, [url,url])
    }
    //MARK:- Send Error when no server response
    
    func test_load_deliverErrorOnClientError(){
         //Arrange
        let (sut, client) = makeSUT()
       
        //Act
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load {
            capturedErrors.append ($0)
        }
        let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
        client.complete(with: clientError)
        
        //Assert
        XCTAssertEqual(capturedErrors, [.connectivity])
        
    }
    //MARK:- Send Error when invalid Data  means status code not 200
    
    func test_load_deliverErrorOnInvalidHTTPStatusCode(){
         //Arrange
        let (sut, client) = makeSUT()
       
        //Act
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach{ index, code in
            
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load {
                capturedErrors.append ($0)
            }
            client.complete(withStatusCode: code, at: index)
            //Assert
            XCTAssertEqual(capturedErrors, [.inValidData])
        }
        
    }
    
    private func makeSUT(url:URL = URL.init(string: "http://a-url.com")!)-> (sut:RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url:URL, completion:(Error?,HTTPURLResponse?) -> Void) ]()
        
        var requestedURLs : [URL]{
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (Error?,HTTPURLResponse?) -> Void) {
            messages.append( (url, completion))
        }
        func complete(with error:Error, at index:Int = 0){
            self.messages[index].completion(error, nil)
        }
        func complete(withStatusCode code:Int , at index:Int = 0 ){
            
            let response = HTTPURLResponse.init(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)
            self.messages[index].completion(nil,response)
            
        }
    }
}
