//
//  RemoteFeedLoader.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 03/08/21.
//

import Foundation

public enum HTTPClientResult{
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL,completion: @escaping(HTTPClientResult) -> Void)
}
public class RemoteFeedLoader{
    private let url : URL
    private let client : HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case inValidData
    }
    public enum Result: Equatable{
        case success([FeedItem])
        case failure(Error)
    }
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion: @escaping(Result) -> Void ){
        self.client.get(from: url) { result in
            switch result{
            case let .success(data,responce):
                if responce.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from:data){
                    completion(.success(root.items))
                }else{
                    completion(.failure(.inValidData))
                }
            case .failure(_):
            completion(.failure(.connectivity))
            
            }
        }
    }
}

private struct Root:Decodable {
   let items:[FeedItem]
}
