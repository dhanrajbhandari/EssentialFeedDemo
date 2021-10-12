//
//  RemoteFeedLoader.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 03/08/21.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping(Error) -> Void)
}
public class RemoteFeedLoader{
    private let url : URL
    private let client : HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
    }
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping(Error) -> Void ){
        self.client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

