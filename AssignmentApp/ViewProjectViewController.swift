
import UIKit

class ViewProjectViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchProjectDetails(forUserId: UserData.shared.currentUser!.id)

        // Do any additional setup after loading the view.
    }
    
    func fetchProjectDetails(forUserId userId: Int) {
        let url = URL(string: "https://example.com/api/projects/get/details/byuserid?userid=\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let exerciseDetails = json?["exercise_details"] as? [[String: Any]] {
                        for exercise in exerciseDetails {
                            let exerciseName = exercise["exercise_name"] as? String
                            let userName = exercise["user_name"] as? String
                            let durationMinutes = exercise["duration_minutes"] as? Int
                            let dateCompleted = exercise["date_completed"] as? String
                            // Handle the exercise details here
                        }
                    }
                } catch {
                    print("Error decoding JSON response: \(error.localizedDescription)")
                }
            } else {
                print("Unexpected response: \(response.debugDescription)")
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
    }
}



