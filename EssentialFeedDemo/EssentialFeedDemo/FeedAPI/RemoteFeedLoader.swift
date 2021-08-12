//
//  RemoteFeedLoader.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 03/08/21.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}
public class RemoteFeedLoader{
    private let url : URL
    private let client : HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(){
        self.client.get(from: url)
    }
}

