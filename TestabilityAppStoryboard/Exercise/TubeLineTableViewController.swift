//
//  ViewController.swift
//  TestabilityAppStoryboard
//
//  Created by William Do on 06/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import UIKit

class TubeLineTableViewController: UITableViewController {
    
    let statusUrl: URL = URL(string: "https://api.tfl.gov.uk/Line/Mode/tube/Status")!
    
    let cellReuseIdentifier = "tubeLineCell"
    
    var tubeStatus: [Line] = []
    
    override func viewDidAppear(_ animated: Bool) {
        URLSession.shared.dataTask(with: statusUrl) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Networking error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200, let responseData = data else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Networking error", message: "Unable to handle response.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            do {
                let json = try JSONDecoder().decode([Line].self, from: responseData)
                DispatchQueue.main.async {
                    self.tubeStatus = json
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Networking error", message: "Unable to decode response.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tubeStatus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TubeLineTableViewCell
        
        let line = tubeStatus[indexPath.row]
        cell.lineNameLabel.text = line.name
        
        if let mostSevereStatus = line.lineStatuses.max(by: {$0.statusSeverity < $1.statusSeverity}) {
            switch mostSevereStatus.statusSeverity {
            case 0:
                cell.lineStatusLabel.text = "🟢"
            case 20:
                cell.lineStatusLabel.text = "🔴"
            default:
                cell.lineStatusLabel.text = "❓"
            }
        } else {
            cell.lineStatusLabel.text = "🤷"
        }
        
        return cell
    }
        
}
