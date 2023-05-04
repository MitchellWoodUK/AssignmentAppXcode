import UIKit

class ProjectDetailsViewController: UIViewController {
    //Variable to set the project.
    var project: Project?
    //Outlets to store the project name, description, start date, end date, title and label.
    @IBOutlet var projectName: UILabel!
    @IBOutlet var editName: UITextField!
    @IBOutlet var editStartDate: UIDatePicker!
    @IBOutlet var editDescription: UITextField!
    @IBOutlet var editEndDate: UIDatePicker!
    @IBOutlet var errorMsg: UILabel!
    //Create a constant that stores the built in date formatter in.
    let dateFormatter = DateFormatter()
   
    //Function to prepare the data to pass through the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TasksSegue" {
            let ViewTasksVC = segue.destination as! ViewTasksViewController
            //Passing the project ID through the segue.
            ViewTasksVC.projectId = self.project?.id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Create the project constant.
          guard let project = project else {
              return
          }
          
        // Updating UI elements with project details
        projectName.text = "Details for: " + project.name
        editName.text = project.name
        editDescription.text = project.description
          
        //Setting the format of the date to match what is stored in the database.
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
    //Action that be called when the edit button is clicked.
    @IBAction func EditDetails(_ sender: Any) {
        //Assign variables.
        guard let nameUpdate = editName.text,
              let descUpdate = editDescription.text,
              let startdatepicked = editStartDate?.date,
              let enddatepicked = editEndDate?.date
        else{
            self.errorMsg.textColor = .red
            self.errorMsg.text = "Please ensure all fields are filled"
            return
        }
        //Assign dates to variables.
        let startdateUpdate = self.dateFormatter.string(from: startdatepicked)
        let enddateUpdate = self.dateFormatter.string(from: enddatepicked)
        //Create object.
        let project = Project( id: self.project?.id ?? 0 , name: nameUpdate, description: descUpdate, start_date: startdateUpdate, end_date: enddateUpdate, user_id: self.project?.user_id ?? 0)
        //Assign the url to a variable.
        let url = "http://127.0.0.1:5000/api/project/update"
        //Send the details to urlsession post.
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
