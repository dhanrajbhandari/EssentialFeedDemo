//
//  FeedItem.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 12/07/21.
//

import Foundation

public struct FeedItem : Equatable{
    public let id : UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id:UUID,description:String?,location:String?,url:URL){
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = url
    }
}


