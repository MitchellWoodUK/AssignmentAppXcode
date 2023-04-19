
import UIKit

class ViewProjectViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchProjectDetails(forUserId: UserData.shared.currentUser!.id)

        // Do any additional setup after loading the view.
    }
    /*
    func fetchProjectDetails(forUserId userId: Int) {
        let apiUrl = "http://127.0.0.1:5000/api/projects/get/details/byuserid?userid=\(userId)"
        
        guard let url = URL(string: apiUrl) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let projectDetails = json?["project_details"] as? [[String: Any]] {
                    let projects = projectDetails.compactMap { ProjectData(json: $0) }
                    
                    DispatchQueue.main.async {
                        self.addTextForProjects(projects: projects)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.textView.text = "No projects found for the specified user ID!"
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func addTextForProjects(projects: [ProjectData]) {
        var projectText = ""
        var projectDescription = ""
        //recentactivities
        for project in projects {
            //if exercise within this week, recent + 1
            projectText += "Project Name: \(project.name)\n"
            projectDescription += "Project Description: \(project.description)\n"
        }
        
        
        
        
      

        
        

        textView.text = projectText
    }
}

struct ProjectData {
    let name: String
    let description: String
    let start_date: Date
    let end_date: Date
    let user_name: String
    
    init?(json: [String: Any]) {
        guard let start_date = json["start_date"] as? Date,
              let end_date = json["end_date"] as? Date,
              let name = json["name"] as? String,
              let description = json["description"] as? String,
              let userName = json["user_name"] as? String else {
            return nil
        }
        
        self.name = name
        self.description = description
        self.start_date = start_date
        self.end_date = end_date
        self.user_name = userName
    }*/
}



