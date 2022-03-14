//
//  DataMessage.swift
//  ChatApp
//
//  Created by Mv Mobile on 3/2/22.
//

import Foundation

class DataMessage {
    // Declare User Email
    var message : String = ""
    var sent_user : String  = ""
    var date: Date = Date()
    init(){
        
    }
    
    init(message: String, sent_user:String, date: Date){
        self.message = message
        self.sent_user = sent_user
        self.date = date
    }
}
