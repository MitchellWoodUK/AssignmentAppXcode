import UIKit

class ViewTasksViewController: UIViewController {
    //Outlets for the table view and the title.
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleText: UILabel!
    //Variables to store the project ID and the tasks.
    var projectId: Int?
    var tasks: [Task] = []
    
    //Prepare function to pass the project ID through a segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            let AddTaskVC = segue.destination as! AddTaskViewController
            AddTaskVC.projectId = projectId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view's dataSource and delegate properties
        tableView.dataSource = self
        tableView.delegate = self
        
        //Set the project id.
        guard let project_Id = projectId else{
            return
        }
        if  project_Id != nil{
            //Set the project title to show the ID.
            titleText.text = "Viewing tasks for Project: \(project_Id)"
            print("Viewing tasks for project \(project_Id)")
        } else {
            print("No project ID was provided")
        }
        print("HERE IS THE PROJECT ID", project_Id)
        //Create the URL to get the tasks by the project ID.
        let url = URL(string: "http://127.0.0.1:5000/api/tasks/get/byprojectid?id=\(project_Id)")!
        //Pass in the URL that will be executed when the fetch completes. Outputs a result if successful.
        URLSession.shared.fetchData(for: url) { (result: Result<[Task], Error>) in
            switch result {
            case .success(let results):
                //appends the results to the array.
                self.tasks.append(contentsOf: results)
                print("HERE ARE THE RESULTS" , results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension ViewTasksViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Sets the number of rows for the table to be the amount of tasks that are returned.
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //Get the cells from the identifier.
        let celltask = tableView.dequeueReusableCell(withIdentifier: "celltask", for: indexPath)
        print("TASKS", tasks)
        //Assign the relevant details to the text labels.
        celltask.textLabel?.text = tasks[indexPath.row].name + " - " + tasks[indexPath.row].description
        celltask.detailTextLabel?.text = "Due: " + tasks[indexPath.row].due_date
        
        return celltask
    }
     //When a cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected project
        let task = tasks[indexPath.row]
        // Navigate to the project details view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let TaskDetailsVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailsVC") as! TaskDetailsViewController
        TaskDetailsVC.task = task
        navigationController?.pushViewController(TaskDetailsVC, animated: true)
    }
}
