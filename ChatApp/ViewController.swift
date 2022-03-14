//
//  ViewController.swift
//  ChatApp ChatHomePage_nav
//  Created by Mv Mobile on 30/1/22.
//

import UIKit
import Firebase
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields


class ViewController: UIViewController, UITextFieldDelegate {

    var user_email_text_field : MDCFilledTextField = {
        let text_field = MDCFilledTextField()
        text_field.label.text = "User Email"
        text_field.translatesAutoresizingMaskIntoConstraints = false
        text_field.autocapitalizationType = .none
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "Email")
        imageView.contentMode = .scaleAspectFit
        text_field.leadingView = imageView
        text_field.leadingViewMode = .always
        return text_field
    }()
    
    var user_password_text_field : MDCFilledTextField = {
        // Setting for textfield
        let text_field = MDCFilledTextField()
        text_field.label.text = "User Password"
        text_field.translatesAutoresizingMaskIntoConstraints = false
        text_field.autocapitalizationType = .none
        text_field.isSecureTextEntry = true
    
        // Set the left view for the textfield
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: "Password")
        imageView.contentMode = .scaleAspectFit
        text_field.leadingView = imageView
        text_field.leadingViewMode = .always
        
        // Set the right view for the textfield
        let button = UIButton(frame: CGRect(x: text_field.frame.size.width - 30, y: 5, width: 34, height: 30))
        button.setImage(UIImage(named: "password_eye_off"), for: .normal)
        button.setImage(UIImage(named: "password_eye_on"), for: .selected)
        button.addTarget(self, action: #selector(refresh(_:)), for: .touchUpInside)
        button.isSelected = true
        text_field.trailingView = button
        text_field.trailingViewMode = .always
        
        return text_field
    }()
    
    var profile_image_view : UIImageView = {
        // Set up for imageView
        
        let image_view = UIImageView()
        image_view.image = UIImage(named: "Firebase")
        image_view.contentMode = .scaleAspectFit
        image_view.translatesAutoresizingMaskIntoConstraints = false
        return image_view
    }()
    
    var login_button: UIButton = {
        // Set up for login button
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15.0
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Login", for: .normal)
        button.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    var New_member_btn : UIButton = {
        // Set up for register button
        let button = UIButton()
        button.setTitle("Create an account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16.0)
        button.backgroundColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    @objc func refresh(_ sender: UIButton){
        if (sender.isSelected){
            sender.isSelected = false
            user_password_text_field.isSecureTextEntry = false
        }else{
            sender.isSelected = true
            user_password_text_field.isSecureTextEntry = true
        }
    }
    
    @objc func register (){
        print(12345)
    }
    
    @objc func login (){
        var alert_controller = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        alert_controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if(user_password_text_field.text! == "" &&  user_email_text_field.text! == ""){
            alert_controller.message = "Please fill data into the text field!"
            self.present(alert_controller, animated: true, completion: nil)
        }else if(user_email_text_field.text! == ""){
            alert_controller.message = "Please fill in the User email"
            self.present(alert_controller, animated: true, completion: nil)
        }else if (user_password_text_field.text! == ""){
            alert_controller.message = "Please fill in the User password"
            self.present(alert_controller, animated: true, completion: nil)
        }else{
            Auth.auth().signIn(withEmail: user_email_text_field.text!, password: user_password_text_field.text!, completion: { (auth, error) in
                if let e = error {
                    alert_controller.message = "User Email or password are not correct, \n Please try again! "
                    self.present(alert_controller, animated: true, completion: nil)
                } else {
                    if let user = auth?.user {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ChatHomePage_nav") as! UINavigationController
                        newViewController.modalPresentationStyle = .overFullScreen
                        newViewController.modalTransitionStyle = .coverVertical
                        self.present(newViewController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        // Loading for superview
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        // Set action for Login and register
        New_member_btn.addTarget(self, action: #selector(register), for: .touchUpInside)
        login_button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        // Setting for profile image
        self.view.addSubview(profile_image_view)
        profile_image_view.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profile_image_view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profile_image_view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profile_image_view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        profile_image_view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.8).isActive = true
        
        // Setting for user_email_text_field

        self.view.addSubview(user_email_text_field)
        user_email_text_field.topAnchor.constraint(equalTo: profile_image_view.bottomAnchor, constant: 20).isActive = true
        user_email_text_field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        user_email_text_field.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        user_email_text_field.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        user_email_text_field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        // Setting for user_email_text_field
        self.view.addSubview(user_password_text_field)
        user_password_text_field.topAnchor.constraint(equalTo: user_email_text_field.bottomAnchor, constant: 10).isActive = true
        user_password_text_field.leadingAnchor.constraint(equalTo: user_email_text_field.leadingAnchor).isActive = true
        user_password_text_field.trailingAnchor.constraint(equalTo: user_email_text_field.trailingAnchor).isActive = true
        user_password_text_field.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        user_password_text_field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        // Setting for login button
        self.view.addSubview(login_button)
        login_button.topAnchor.constraint(equalTo: user_password_text_field.bottomAnchor, constant: 10).isActive = true
        login_button.leadingAnchor.constraint(equalTo: user_password_text_field.leadingAnchor).isActive = true
        login_button.trailingAnchor.constraint(equalTo: user_password_text_field.trailingAnchor).isActive = true
        login_button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        login_button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        // Setting for register button
        self.view.addSubview(New_member_btn)
        New_member_btn.topAnchor.constraint(equalTo: login_button.bottomAnchor, constant: 20).isActive = true
        New_member_btn.leadingAnchor.constraint(equalTo: login_button.leadingAnchor).isActive = true
        New_member_btn.trailingAnchor.constraint(equalTo: login_button.trailingAnchor).isActive = true
        
        user_email_text_field.delegate = self
        user_password_text_field.delegate = self
        
        observe_text_field()
    }
    
    func observe_text_field(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjust_frame_1), name: .MDCKeyboardWatcherKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjust_frame_2), name: .MDCKeyboardWatcherKeyboardWillShow, object: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if user_email_text_field == textField{
            user_email_text_field.resignFirstResponder()
            return true
        }else if user_password_text_field == textField{
            user_password_text_field.resignFirstResponder()
            return true
        }else{
            return false
        }
    }
    
    @objc func adjust_frame_1(){
        if(self.view.frame.origin.y != 0){
            self.view.frame.origin.y = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func adjust_frame_2(){
        if(self.view.frame.origin.y == 0){
            self.view.frame.origin.y -= 100
            self.view.layoutIfNeeded()
        }
    }
}

