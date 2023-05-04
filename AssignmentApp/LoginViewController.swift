import UIKit

class LoginViewController: UIViewController {
    //Outlets for the username, password and label fields.
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Action that is run when the login button is pressed.
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //Variable that changes to confirm whether or not the login is successful.
        var loggedIn = false
        //Ensure the fields have been entered.
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        //Create the object.
        let parameters = ["username": username, "password": password]
        //Create the URL.
        guard let url = URL(string: "http://127.0.0.1:5000/api/users/login") else {
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
                      return
                  }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            //If the request is successful then decode the JSON and changed the logged in variable to true.
            do {
                let userData = try JSONDecoder().decode([User].self, from: data)
                if userData.count > 0 {
                    //Set the userdata to the logged in user.
                    UserData.shared.currentUser = userData[0]
                    
                    DispatchQueue.main.async{
                        loggedIn = true
                        //Adjust the label to say that they are logged in.
                        self.notificationLabel.text = "Logged in \(userData[0].username)"
                    }
                    print("User logged in successfully")
                } else {
                    print("Invalid username or password")
                    self.notificationLabel.text = "Invalid username or password"
                }
            } catch {
                print("Error: \(error)")
                self.notificationLabel.text = "Invalid username or password"
            }
            
            // Check the value of loggedIn here
            if loggedIn {
                DispatchQueue.main.async {
                    //Move the user to the user page.
                    let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                    self.navigationController?.pushViewController(uservc, animated: true)
                }
            }
        }.resume()
    }
}
//Struct for the user with id, email, username and password properties.
struct User: Codable {
    let id: Int
    let email: String
    let username: String
    let password: String
}
