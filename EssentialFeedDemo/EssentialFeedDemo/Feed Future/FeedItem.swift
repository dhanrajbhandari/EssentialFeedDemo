//
//  FeedItem.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 12/07/21.
//

import Foundation

public struct FeedItem : Equatable{
    let id : UUID
    let description: String?
    let location: String?
    let url: URL
}
