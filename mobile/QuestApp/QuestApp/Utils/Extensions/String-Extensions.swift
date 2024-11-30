//
//  String-Extensions.swift
//  ShopApp-SwiftUI
//
//  Created by Osmancan Akagündüz on 6.09.2024.
//

import Foundation

extension String {
    
    var asUrl : URL? {
        return URL(string: self)
    }
    
}
