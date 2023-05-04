import UIKit

class RegisterViewController: UIViewController {
    //All outlets needed to access the username, password, email and label.
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Action that is triggered by the register button being pressed.
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        //Guard to ensure that the relevant information has been filled out and passed to the ViewController.
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else {
            return
        }
        //Creating an object.
        let parameters = ["username": username, "password": password, "email": email]
        //Setting the URL
        guard let url = URL(string: "http://127.0.0.1:5000/api/users/register") else {
            return
        }
        //Create the request and set it to POST.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //JSON the data.
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        //Make the request.
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Error: Invalid response")
                self.registerInfoLabel.text = "Registration Unsuccessful!"
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            //If the request is a success then print a success message and move the user to the Login ViewController.
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: Any],
                       let registerSuccess = dict["Register_Success"] as? Bool,
                       registerSuccess == true {
                        print("User registration successful")
                        DispatchQueue.main.async{
                            self.registerInfoLabel.text = "User Registration Successful"
                            let loginvc = (self.storyboard?.instantiateViewController(withIdentifier: "LoginVC"))!
                            self.navigationController?.pushViewController(loginvc, animated: true)
                        }
                }
                else {
                    print("User registration failed")
                    self.registerInfoLabel.text = "Registration Unsuccessful!"
                }
                    
                }catch {
                    print("Error: \(error.localizedDescription)")
                    self.registerInfoLabel.text = "Registration Unsuccessful!"
                }
            }.resume()
        }
    }
