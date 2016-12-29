/*************************************************************************
 *
 * REALM CONFIDENTIAL
 * __________________
 *
 *  [2016] Realm Inc
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Realm Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Realm Incorporated
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Realm Incorporated.
 *
 **************************************************************************/

import UIKit
import CloudKit


class CloudKitAuthViewController: UIViewController {

    @IBOutlet weak var reloadButton: UIButton?
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var settingsButton: UIButton?
    
    var completionHandler: ((_ accessToken: String?, _ error: Error?) -> ())?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beginAuthentication()
    }
    
    func beginAuthentication() {
        activityIndicator?.startAnimating()
        reloadButton?.isHidden = true
        statusLabel?.isHidden = true
        settingsButton?.isEnabled = false
        
        downloadCloudKitUserRecord()
    }
    
    func downloadCloudKitUserRecord() {
        let container = CKContainer.default()
        container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
          
            let userAccessToken = recordID?.recordName
            self.dismiss(animated: true) {
                self.completionHandler?(userAccessToken, error)
            }
        }
    }
    
    func showError(message: String) {
        OperationQueue.main.addOperation { 
            self.activityIndicator?.stopAnimating()
            self.settingsButton?.isEnabled = true
            self.reloadButton?.isHidden = false
            self.statusLabel?.isHidden = false
            self.statusLabel?.text = message
        }
    }
    
    //MARK: Button Callbacks
    @IBAction func reloadButtonTapped(sender: AnyObject?) {
        beginAuthentication()
    }
    
    @IBAction func cloudKitButtonTapped(sender: AnyObject?) {
        let url = NSURL(string: "prefs:root=CASTLE")
        UIApplication.shared.openURL(url! as URL)
    }
}
