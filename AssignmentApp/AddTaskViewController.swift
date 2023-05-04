import UIKit

class AddTaskViewController: UIViewController {
    //Outlets for the name, description, due date and error label.
    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var dueDateField: UIDatePicker!
    @IBOutlet var errorLabel: UILabel!
    //Variable to store the project id.
    var projectId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Action that is called when the add button is pressed.
    @IBAction func addTask(_ sender: Any) {
        //Need to pass in a name, description, due date, status and a project id.
        guard let name = nameField.text, !name.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let due_date = dueDateField?.date.description
              else {
            return
        }
        //Create the object.
        let parameters: [String: Any] = ["project_id": projectId ?? "", "name": name, "description": description, "due_date": due_date, "status": "In Progress"]
        //Create the url string.
        guard let url = URL(string: "http://127.0.0.1:5000/api/tasks/add") else {
            return
        }
        //Create the request.
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
        //Run the request.
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
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dict = json as? [String: Any],
                    let addSuccess = dict["Add_Success"] as? Bool,
                    //make the bool true.
                    addSuccess == true {
                    print("New Task Added")
                    
                    DispatchQueue.main.async {
                        //Display the correct information and change the view to the project screen.
                        self.errorLabel.text = "Task Added!"
                        let ProjectVC = (self.storyboard?.instantiateViewController(withIdentifier: "ProjectVC"))!
                        self.navigationController?.pushViewController(ProjectVC, animated: true)
                    }
                } else {
                    print("Failed To Add New Task ")
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
