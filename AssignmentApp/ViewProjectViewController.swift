import UIKit

class ViewProjectViewController: UIViewController {
    //Outlet for the table view.
    @IBOutlet var tableView: UITableView!
    //Variable that will store the project in.
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //userid to find the correct projects.
        let userId = UserData.shared.currentUser!.id
        print(userId)
        //Create the url object with the API endpoint.
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/byuserid?id=\(userId)")!
        //Pass in the URL that will be executed when the fetch completes. Outputs a result if successful.
        URLSession.shared.fetchData(for: url) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                //appends the results to the array.
                self.projects.append(contentsOf: results)
                print(results)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension ViewProjectViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Sets the number of rows in the table to the amount of projects.
        projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //Finds the cell identifier from the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //Sets the text label and detail text label to the relevant information.
        cell.textLabel?.text = projects[indexPath.row].name + " - " + projects[indexPath.row].description
        cell.detailTextLabel?.text = "Due: " + projects[indexPath.row].end_date
   
        return cell
    }
    
    //When a cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected project
        let project = projects[indexPath.row]
        // Navigate to the project details view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let projectDetailsVC = storyboard.instantiateViewController(withIdentifier: "projectDetailsVC") as! ProjectDetailsViewController
        projectDetailsVC.project = project
        navigationController?.pushViewController(projectDetailsVC, animated: true)
    }
}
