//
//  ChatPageCell.swift
//  ChatApp
//
//  Created by Mv Mobile on 4/2/22.
//

import UIKit

class ChatPageCell: UITableViewCell{

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var chatView : UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.layer.cornerRadius = 15.0
       view.layer.borderWidth = 0.5
       view.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
       view.layer.masksToBounds = true
       return view
    }()
    
    var messageView: UITextView = {
        let text_view = UITextView()
        text_view.translatesAutoresizingMaskIntoConstraints = false
        text_view.font = UIFont(name: "sans-serif", size: 16.0)
        text_view.isEditable = false
        text_view.isScrollEnabled = false
        text_view.isUserInteractionEnabled = false
        text_view.backgroundColor = .clear
        return text_view
    }()
    
    @objc private func tap() {
        print("tap")
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Add view into contentView
    }

    func setConstraintForChatView_1(estimate_width: Float){
        
        self.contentView.addSubview(chatView)
        self.contentView.addSubview(messageView)
        
        chatView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive  = true
        chatView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive  = true
        chatView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive  = true
        chatView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: CGFloat(estimate_width)+0.05).isActive  = true
        
        messageView.topAnchor.constraint(equalTo: self.chatView.topAnchor).isActive  = true
        messageView.leadingAnchor.constraint(equalTo: self.chatView.leadingAnchor).isActive  = true
        messageView.heightAnchor.constraint(equalTo: self.chatView.heightAnchor).isActive  = true
        messageView.widthAnchor.constraint(equalTo: self.chatView.widthAnchor).isActive  = true
    }
    
    func setConstraintForChatView_2(estimate_width: Float){
        
        self.contentView.addSubview(chatView)
        self.contentView.addSubview(messageView)
        
        chatView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive  = true
        chatView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive  = true
        chatView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive  = true
        chatView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: CGFloat(estimate_width)+0.05).isActive  = true
        
        messageView.topAnchor.constraint(equalTo: self.chatView.topAnchor).isActive  = true
        messageView.leadingAnchor.constraint(equalTo: self.chatView.leadingAnchor).isActive  = true
        messageView.heightAnchor.constraint(equalTo: self.chatView.heightAnchor).isActive  = true
        messageView.widthAnchor.constraint(equalTo: self.chatView.widthAnchor).isActive  = true


    }
}
