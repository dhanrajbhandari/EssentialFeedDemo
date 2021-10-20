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
        expect(sut, toCompleteWithResult: .failure(.connectivity), when:  {
            let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
            client.complete(with: clientError)
        })
    }
    //MARK:- Send Error when invalid Data  means status code not 200
    
    func test_load_deliverErrorOnInvalidHTTPStatusCode(){
         //Arrange
        let (sut, client) = makeSUT()
       
        //Act
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach{ index, code in
            expect(sut, toCompleteWithResult: .failure(.inValidData),when:  {
                client.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deleverErrorOn200HTTPSCodeWithInvalidJSON(){
        //Arrange
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.inValidData)) {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    func test_load_deliverNoItemOn200HTTPResponseWithEmptyJSON(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .success([]),when:  {
            let emptyJSON = Data("{\"items\":[]}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSON)
        })
 
    }
    //MARK:- Helper Method
    private func expect(_ sut:RemoteFeedLoader, toCompleteWithResult result: RemoteFeedLoader.Result, when action: ()->Void, file: StaticString=#file, line: UInt=#line){
        //Act
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {
            capturedResults.append($0)
        }
        action()
        //Assert
        XCTAssertEqual(capturedResults, [result], file:file, line:line)
    }
    private func makeSUT(url:URL = URL.init(string: "http://a-url.com")!)-> (sut:RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }

    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url:URL, completion:(HTTPClientResult) -> Void) ]()
        
        var requestedURLs : [URL]{
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append( (url, completion))
        }
        func complete(with error:Error, at index:Int = 0){
            self.messages[index].completion(.failure(error))
        }
        func complete(withStatusCode code:Int ,data: Data = Data(), at index:Int = 0 ){
            
            let response = HTTPURLResponse.init(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            self.messages[index].completion(.success(data,response))
            
        }
    }
}
