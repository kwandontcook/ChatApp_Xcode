//
//  ChatPageController.swift
//  ChatApp
//
//  Created by Mv Mobile on 3/2/22.
//

import UIKit
import Firebase

class ChatPageController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    var channel: Channel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ChatPageCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.separatorStyle = .none
        self.title = ""
        self.tableView.tableFooterView = create_text_field_button()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (channel?.message.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Load cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ChatPageCell
        // Obtain user identify
        if let user_id = Auth.auth().currentUser?.uid{
            // If it is sented by this user
            let estimate_width_f = (estimateFrameForText((channel?.message[indexPath.row].message)!).width/self.tableView.frame.width)

            
            if(user_id == channel?.message[indexPath.row].sent_user){
                cell.chatView.removeFromSuperview()
                cell.messageView.removeFromSuperview()
                cell.setConstraintForChatView_2(estimate_width: Float(estimate_width_f))
                cell.chatView.backgroundColor = .systemBlue
                cell.messageView.attributedText = NSMutableAttributedString(string: (channel?.message[indexPath.row].message)!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0),NSAttributedString.Key.foregroundColor : UIColor.white])
                cell.selectionStyle = .none
                cell.messageView.sizeToFit()
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
                tapGestureRecognizer.delegate = self
                cell.messageView.addGestureRecognizer(tapGestureRecognizer)
            }else{
                cell.chatView.removeFromSuperview()
                cell.messageView.removeFromSuperview()
                cell.setConstraintForChatView_1(estimate_width: Float(estimate_width_f))
                cell.chatView.backgroundColor = .systemGray6
                cell.messageView.attributedText = NSMutableAttributedString(string: (channel?.message[indexPath.row].message)!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0)])
                cell.selectionStyle = .none
                cell.messageView.sizeToFit()
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
                tapGestureRecognizer.delegate = self
                cell.chatView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
        return cell
    }
    
    @objc private func tap() {
        let menuController: UIMenuController = UIMenuController.shared
        menuController.setMenuVisible(true, animated: true)
        menuController.arrowDirection = UIMenuController.ArrowDirection.default
        menuController.setTargetRect(CGRect.zero, in: view)
        
        let menuItem1: UIMenuItem = UIMenuItem(title: "Menu 1", action: #selector(onMenu1(sender:)))
        let menuItem2: UIMenuItem = UIMenuItem(title: "Menu 2", action: #selector(onMenu2(sender:)))
        let menuItem3: UIMenuItem = UIMenuItem(title: "Menu 3", action: #selector(onMenu3(sender:)))
        
        // Store MenuItem in array.
        let myMenuItems: [UIMenuItem] = [menuItem1, menuItem2, menuItem3]
        
        // Added MenuItem to MenuController.
        menuController.menuItems = myMenuItems
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if [#selector(onMenu1(sender:)), #selector(onMenu2(sender:)), #selector(onMenu3(sender:))].contains(action) {
            return true
        }

        return false
    }
    
    
    @objc internal func onMenu1(sender: UIMenuItem) {
            print("onMenu1")
        }
        
        @objc internal func onMenu2(sender: UIMenuItem) {
            print("onMenu2")
        }
        
        @objc internal func onMenu3(sender: UIMenuItem) {
            print("onMenu3")
        }
    
    
    func add_product_into_view(data:DataMessage){
        if(self.channel!.message.count == 0){
            self.channel?.message.append(data)
        }else{
            // Iterate to find the suitable position
            var index = 0;
            // Retrieve index for adding
            for m in 0..<(self.channel?.message.count)!{
                if(data.date > (self.channel?.message[m].date)!){
                    index = index+1
                }
            }
            // Append the data according to index
            self.channel?.message.insert(data, at: index)
            
            // reload tableview
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func data_observer(){
        // Gain the database reference
        let database = Database.database().reference()
        // Retrieve messages from database
        database.child("Channels").child((channel?.channel_id)!).child("Chats").child("messages").observe(.value, with: {
            snapshot in
            // Delete all the record in the previous array
            self.channel?.message.removeAll()
            // Retrieve communicated Users
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dictionary = rest.value as? [String:Any] else{
                  return;
                }
                let data_messages = DataMessage()
                data_messages.message = dictionary["data"] as! String
                data_messages.sent_user = dictionary["sent_user"] as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                data_messages.date  = dateFormatter.date(from:  dictionary["date_sent"] as! String)!
                
                self.add_product_into_view(data: data_messages)
            }
            
            DispatchQueue.main.async {
                // Select the lastRow
                if((self.channel?.message.count)! > 0){
                    self.tableView.selectRow(at: IndexPath(row: (self.channel?.message.count)!-1, section: 0), animated: true, scrollPosition: .bottom)
                }
            }
        })
        
        
        
    }
    

     func create_text_field_button() -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 60)
        
        // Create textfield
        let textfield = UITextField()
        textfield.frame = CGRect(x: 5, y: 5, width: self.tableView.frame.width - 100, height: 60)
        textfield.font = UIFont(name: "helvetica", size: 14.0)
        textfield.layer.cornerRadius = 15.0
        textfield.delegate = self
        textfield.layer.borderWidth = 0.5
        textfield.tag = 1
        textfield.delegate = self
        textfield.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        v.addSubview(textfield)
        
        // Create send button
        let submit = UIButton()
        submit.frame = CGRect(x: self.tableView.frame.width - 90, y: 20, width: 70, height: 30)
        submit.contentMode = .scaleAspectFit
        submit.setTitleColor(.systemBlue, for: .normal)
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(send_data_to_database), for: .touchUpInside)
        v.addSubview(submit)
        
        return v
    }
    
    @objc func send_data_to_database(){
        let reference = Database.database().reference()
        
        guard let user_id = Auth.auth().currentUser?.uid else {
            return;
        }
        
        let sub_review = reference.child("Channels").child((channel?.channel_id)!).child("Chats").child("messages").childByAutoId()
        
        // Get current time
        let date_time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let date_string = dateFormatter.string(from : date_time)
        
        if let text_field = self.tableView.viewWithTag(1) as? UITextField{
            sub_review.setValue(["data":text_field.text!, "sent_user": user_id, "date_sent": date_string])
            text_field.text = ""
        }
    }
    
     func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 350, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height_t: CGFloat = 80
        
        //get estimated height somehow????
        if let text = channel?.message[indexPath.row].message {
            height_t = estimateFrameForText(text).height + 20
        }
        
        return height_t
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
