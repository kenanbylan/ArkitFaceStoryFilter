
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var offsetBeforeShowKeyboard: CGPoint?
    //var scrollView : UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // self.scrollView.isScrollEnabled = false
        
        
    }
    
    
    /*
     public func textFieldDidBeginEditing(_ textField: UITextField) {
     self.scrollView.isScrollEnabled = true
     if (self.offsetBeforeShowKeyboard == nil) {
     self.offsetBeforeShowKeyboard = self.scrollView.contentOffset
     }
     }
     */
    
    @IBAction func loginClicked(_ sender: Any) {
        if usernameTextField.text != nil  && passwordTextField.text != nil && emailTextField.text != nil  {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                
            }
        }else {
            self.makeAlert(title: "Error", message: "Email or Password is Empty.")
        }
    }
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
        if emailTextField.text != nil  && passwordTextField.text != nil && usernameTextField.text !=  nil  {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                
                let firestore = Firestore.firestore()
                let userDictionary = ["email" : self.emailTextField.text!, "username" : self.usernameTextField.text!] as? [String : Any]
                firestore.collection("UserData").addDocument(data: userDictionary!) { error in
                    
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    }
                }
                
                
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                
            }
        }else {
            
            self.makeAlert(title: "Error", message: "Email or Password or Username is Empty.")
        }
    }
    
    func makeAlert(title:String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
