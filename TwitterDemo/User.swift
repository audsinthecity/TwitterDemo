//
//  User.swift
//  TwitterDemo
//
//  Created by Audrey Chaing on 10/29/16.
//  Copyright © 2016 Audrey Chaing. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString) as NSURL?
        }
        
        tagline = dictionary["description"] as? NSString
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
            
                if let userData = userData {
        
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
                
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
            
        }
    }

}
