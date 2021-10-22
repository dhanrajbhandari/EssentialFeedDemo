//
//  FeedItemMapper.swift
//  EssentialFeedDemo
//
//  Created by Anzu on 22/10/21.
//

import Foundation

internal class FeedItemMaper{
    
    private struct Root:Decodable {
       let items:[Item]
    }

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
    
    internal static func map(_ data:Data, _ responce: HTTPURLResponse) throws -> [FeedItem]{
        
        guard responce.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.inValidData
        }
        let root = try JSONDecoder().decode(Root.self, from:data)
        return (root.items.map{ $0.item})
    }
    
}
