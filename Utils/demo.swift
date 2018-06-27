//
//  demo.swift
//  demo
//
//  Created by Roger on 2018/6/27.
//  Copyright © 2018 Zen. All rights reserved.
//

import Foundation

struct Listing : Codable {
    var id : Int
}

class DecodeDemo {

    var json:Data = Data();
    
    
    
    
    
    
    
    func decodeData() throws {
        let decoder = JSONDecoder()
        let list = try decoder.decode([Listing].self, from:json)
        print(list);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}
