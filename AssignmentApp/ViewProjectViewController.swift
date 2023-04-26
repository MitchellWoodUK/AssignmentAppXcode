
import UIKit

class ViewProjectViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create the url object with the API endpoint.
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/all")!
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
        projects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = projects[indexPath.row].name
        return cell
    }
}
    
    


    

    


