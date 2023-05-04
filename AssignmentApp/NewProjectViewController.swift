import UIKit

class NewProjectViewController: UIViewController {
    //Outlets that store the project name, description, start date, end date and label.
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Action that is run when the add project button is pressed.
    @IBAction func addProjectButtonPressed(_ sender: UIButton) {
        //Ensuring that all the data is captured by the form.
        guard let name = projectName.text, !name.isEmpty,
              let description = projectDescription.text, !description.isEmpty,
              let start_date = startDate?.date.description,
              let end_date = endDate?.date.description else {
            return
        }
        //Creating the object from the constants.
        let parameters: [String: Any] = ["user_id": UserData.shared.currentUser?.id ?? "", "name": name, "description": description, "start_date": start_date, "end_date": end_date]
        //Setting the URL to the api endpoint.
        guard let url = URL(string: "http://127.0.0.1:5000/api/projects/add") else {
            return
        }
        //Creating the request and setting the method to POST.
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
            //If the request is successful then set a success bool and take the user to the user view controller.
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dict = json as? [String: Any],
                    let addSuccess = dict["Add_Success"] as? Bool,
                    addSuccess == true {
                    print("New Project Added")
                    
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Project Added!"
                        let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                        self.navigationController?.pushViewController(uservc, animated: true)
                    }
                } else {
                    print("Failed To Add New Project ")
                    DispatchQueue.main.async {
                        self.errorLabel.text = "Error!"
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
