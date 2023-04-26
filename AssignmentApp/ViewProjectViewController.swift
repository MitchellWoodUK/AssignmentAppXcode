
import UIKit

class ViewProjectViewController: UICollectionViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
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
            case .failure(let error):
                print(error)
            }
        }
        
    }
    

    
}
    

    


