

import UIKit

class NewProjectViewController: UIViewController {


    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var descriptionField: UITextField!
    
    @IBOutlet var startDateField: UIDatePicker!
    
    @IBOutlet var endDateField: UIDatePicker!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let start_date = startDateField?.date.description,
              let end_date = endDateField?.date.description
               else {
            return
        }
        
        
        let object = ["user_id" : UserData.shared.currentUser?.id ?? "", "name" : name, "description": description, "start_date": start_date, "end_date": end_date] as [String : Any]
        
        
     
         
    
        //Create the url object with the API endpoint.
        let url = "http://127.0.0.1:5000/api/projects/add"
        //Pass in the URL that will be executed when the fetch completes. Outputs a result if successful.
        URLSession.shared.postData(object, urlString: url){ (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                //appends the results to the array.
                print(results)
            case .failure(let error):
                print(error)
            }
        }
    }
}
