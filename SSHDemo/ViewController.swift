import UIKit
import Foundation
import NMSSH
import CFNetwork

class ViewController: UIViewController, NMSSHChannelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let host = "10.0.1.15:22"
        let username = "admin"
        let password = "123"
        let session = NMSSHSession(host: host, andUsername: username)
        print("Trying to connect now..")
        session?.connect()
        if session?.isConnected == true
        {
            print("Session connected")
            session?.channel.delegate = self
            session?.channel.ptyTerminalType = .vanilla
            session?.channel.requestPty = true
            session?.authenticate(byPassword:password)
            
            do{
                try session?.channel.startShell()
                let a = try session?.channel.write("sleep\n")
                print(a)
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
        print("hello")
        print(str)
    }

}

