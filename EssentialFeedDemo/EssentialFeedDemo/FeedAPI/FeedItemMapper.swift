//
//  FeedItemMapper.swift
//  EssentialFeedDemo
//
//  Created by Anzu on 22/10/21.
//

import Foundation

internal final class FeedItemMaper{
    
    //MARK:-Decoadable root struct
    private struct Root:Decodable {
        let items:[Item]
        
        var feed:[FeedItem] {
            return items.map{ $0.item}
        }
    }
    //MARK:- Mapper Item
    private struct Item: Decodable{
        let id : UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item:FeedItem {
            return FeedItem.init(id: id, description: description, location: location, url: image)
        }
    }
    
    private static var OK_200:Int  { return 200}
    
    
    //MARK:- Private Helper Function
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from:data)  else {
            return .failure(.inValidData)
        }
        return .success(root.feed)
    }
}
