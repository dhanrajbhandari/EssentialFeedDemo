//
//  FeedLoader.swift
//  EssentialFeedDemo
//
//  Created by Dhanraj Bhandari on 12/07/21.
//

import Foundation

enum LoadFeedResult {
    case sucess([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func loadFeed(completion: @escaping() -> Void)
}
