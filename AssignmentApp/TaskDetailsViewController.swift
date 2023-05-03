import UIKit

class TaskDetailsViewController: UIViewController {
    var task: Task?
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var nameField: UILabel!
    @IBOutlet var dateField: UILabel!
    @IBOutlet var descriptionField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let task = task else {
              return
        }
        
        // Updating UI elements with project details
        titleText.text = "Details for: " + task.name
        nameField.text = task.name
        descriptionField.text = task.description
        dateField.text = task.due_date
    }
    
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        let taskId = self.task?.id
        let apiUrl = URL(string: "http://127.0.0.1:5000/api/tasks/delete/\(taskId ?? 0)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "DELETE"
        // Create a URLSession data task to send the DELETE request to the API endpoint
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
         if let error = error {
             print("Error: \(error.localizedDescription)")
             
             return
         }
         if let response = response as? HTTPURLResponse {
             if response.statusCode == 200 {
                 print("Task deleted successfully.")
                 
                 DispatchQueue.main.async {
                     
                     
                     let ProjectVC = (self.storyboard?.instantiateViewController(withIdentifier: "ProjectVC"))!
                     self.navigationController?.pushViewController(ProjectVC, animated: true)
                 }
             }
             else {
                 print("Error: HTTP status code \(response.statusCode)")
                                 
             }
         }
        }
        task.resume()
    }
}
