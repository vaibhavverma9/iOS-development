/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class OnlineUsersTableViewController: UITableViewController {
  
  // MARK: Constants
  let userCell = "UserCell"
  
  // MARK: Properties
  var currentUsers: [String] = []
  
  let usersRef = FIRDatabase.database().reference(withPath: "online")
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // listens for a new child added to the users reference
    usersRef.observe(.childAdded, with: { snap in
      
      // take value from snapshot and append it to array
      guard let email = snap.value as? String else {return }
      self.currentUsers.append(email)
      
      // current row
      let row = self.currentUsers.count - 1

      // create NSIndexPath
      let indexPath = IndexPath(row: row, section: 0)

      // insert row at the top
      self.tableView.insertRows(at: [indexPath], with: .top)
    })
    
    usersRef.observe(.childRemoved, with: { snap in // listens for child to be removed
      guard let emailToFind = snap.value as? String else { return }
      for(index, email) in self.currentUsers.enumerated(){ // go through current users
        if email == emailToFind{ // until email is found
          let indexPath = IndexPath(row: index, section: 0) // use index to specific index path
          self.currentUsers.remove(at: index) // remove user from current user list
          self.tableView.deleteRows(at: [indexPath], with: .fade) // delete row in table view by specificy index path
        }
      }})
    
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }
  
  // MARK: Actions
  
  @IBAction func signoutButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
}
