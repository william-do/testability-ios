//
//  TestableViewController.swift
//  TestabilityAppStoryboard
//
//  Created by William Do on 11/05/2020.
//  Copyright © 2020 William Do. All rights reserved.
//

import UIKit

class TestableTableViewController: UITableViewController {
    
    let cellReuseIdentifier = "tubeLineCell"
    
    let viewModel = TubeStatusViewModel(queue: .main, urlSession: .shared, statusUrl: URL(string: "https://api.tfl.gov.uk/Line/Mode/tube/Status")!)
    
    var tubeStatus: [Line] = []
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.downloadStatusFromTfl(
            onError: showAlert,
            onSuccess: reloadView
        )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tubeStatus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TubeLineTableViewCell
        
        let line = tubeStatus[indexPath.row]
        cell.lineNameLabel.text = line.name
        cell.lineStatusLabel.text = statusIndicatorFor(line.lineStatuses)
        
        return cell
    }
    
    fileprivate func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Networking error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func reloadView(_ json: [Line]) {
        self.tubeStatus = json
        self.tableView.reloadData()
    }
        
}

class TubeStatusViewModel {
    
    var statusUrl: URL
    var urlSession: URLSession
    var queue: DispatchQueue
    
    init(queue: DispatchQueue, urlSession: URLSession, statusUrl: URL) {
        self.queue = queue
        self.urlSession = urlSession
        self.statusUrl = statusUrl
    }
    
    func downloadStatusFromTfl(
        onError: @escaping (String) -> Void,
        onSuccess: @escaping ([Line]) -> Void
    ){
        urlSession.dataTask(with: statusUrl) { data, response, error in
            if let err = error {
                self.queue.async { onError(err.localizedDescription) }
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200, let responseData = data else {
                self.queue.async { onError("Unable to handle response.") }
                return
            }
            
            do {
                let tubeStatus = try JSONDecoder().decode([Line].self, from: responseData)
                self.queue.async { onSuccess(tubeStatus) }
            } catch {
                self.queue.async { onError("Unable to decode response.") }
            }
            
        }.resume()
    }
    
}
