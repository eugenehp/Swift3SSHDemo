import UIKit
import Foundation
import NMSSH
import CFNetwork

class ViewController: UIViewController, NMSSHChannelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let host = "10.10.10.10:22"
        let username = "root"
        let password = "password"
        let session = NMSSHSession(host: host, andUsername: username)
        print("Trying to connect now..")
        session?.connect()
        if session?.isConnected == true
        {
            print("Session connected")
            //Mac requires this kind of authentication
            session?.authenticateByKeyboardInteractive({ (request: String?) -> String? in
                return password
            })
            
            session?.channel.delegate = self;
            
            do{
                try session?.channel.execute("ls")
                print(session?.channel.lastResponse ?? "no respone of last command")
            }catch{
                print("Error ocurred!!")
            }
            
            //For other types
            //session.authenticateByPassword(password)
        }
        //session?.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func channel(_ channel: NMSSHChannel!, didReadRawData data: Data!) {
        let str = String(data: data, encoding: .isoLatin1)!
        print(str)
    }

}

