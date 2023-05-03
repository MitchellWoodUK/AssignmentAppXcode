import UIKit

class ProjectDetailsViewController: UIViewController {

    var project: Project?
    
    @IBOutlet var projectName: UILabel!
    @IBOutlet var editName: UITextField!
    @IBOutlet var editStartDate: UIDatePicker!
    @IBOutlet var editDescription: UITextField!
    @IBOutlet var editEndDate: UIDatePicker!
    @IBOutlet var errorMsg: UILabel!
    
 
    
    let dateFormatter = DateFormatter()
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TasksSegue" {
            let ViewTasksVC = segue.destination as! ViewTasksViewController
            ViewTasksVC.projectId = self.project?.id
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          guard let project = project else {
              return
          }
          
          // Updating UI elements with project details
        projectName.text = "Details for: " + project.name
        editName.text = project.name
        editDescription.text = project.description
          
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
          
          // Convert the start date string to a Date and set the UIDatePicker
          if let defaultStartDate = dateFormatter.date(from: project.start_date) {
              print("defaultStartDate: \(defaultStartDate)")
              editStartDate.setDate(defaultStartDate, animated: false)
          } else {
              print("Error: Invalid start date format")
          }
          
          // Convert the end date string to a Date and set the UIDatePicker
          if let defaultEndDate = dateFormatter.date(from: project.end_date) {
              editEndDate.setDate(defaultEndDate, animated: false)
          } else {
              print("Error: Invalid end date format")
          }

    }
    
    @IBAction func EditDetails(_ sender: Any) {
        guard let nameUpdate = editName.text,
              let descUpdate = editDescription.text,
              let startdatepicked = editStartDate?.date,
              let enddatepicked = editEndDate?.date
        else{
            self.errorMsg.textColor = .red
            self.errorMsg.text = "Please ensure all fields are filled"
            return
        }
        
        let startdateUpdate = self.dateFormatter.string(from: startdatepicked)
        
        let enddateUpdate = self.dateFormatter.string(from: enddatepicked)
        
    
              
        let project = Project( id: self.project?.id ?? 0 , name: nameUpdate, description: descUpdate, start_date: startdateUpdate, end_date: enddateUpdate, user_id: self.project?.user_id ?? 0)
    
        
        // ... (code to get the updated project details and create an updatedProject object)
        
            let url = "http://127.0.0.1:5000/api/project/update"
                
            URLSession.shared.postData(project, urlString: url) {(result: Result<Project, Error>) in
            switch result {
            case .success(let updatedProject):
                DispatchQueue.main.async {
                    self.project = updatedProject
                    self.errorMsg.textColor = .green
                    self.errorMsg.text = "Project updated successfully"
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.errorMsg.textColor = .red
                    self.errorMsg.text = "Failed to update project"
                }
            }
        }

    }
}
