//
//  ViewController.swift
//  KillSwitch
//
//  Created by Emre Kurubas on 07/01/17.
//  Copyright © 2017 Emre Kurubas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let urlStr: String = "https://freegeoip.net/xml/"
    
    var status = WifiStatus.off
    var ip = ""
    var connected = false
    
    @IBOutlet weak var cityLabel: NSTextField!
    @IBOutlet weak var countryLabel: NSTextField!
    @IBOutlet weak var ipLabel: NSTextField!
    @IBOutlet weak var switchButton: NSButton!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var responseTimeLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 0.5, target:self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }

    @IBAction func buttonClicked(_ sender: Any) {
        if connected {
            if status == .on {
                status = .off
            }
            else {
                status = .on
                ip = ipLabel.stringValue
            }
        }
    }
    
    func update() {
        let terminate = (status == .on && ip != ipLabel.stringValue)
        if terminate {
            status = .off
            switchWifi(to: status)
        }
        
        if status == .on {
            switchButton.title = "Stop"
            ipLabel.font = NSFont.boldSystemFont(ofSize: 13)
        }
        else {
            switchButton.title = "Start"
            ipLabel.font = NSFont.systemFont(ofSize: 13)
        }
        
        guard let myURL = URL(string: urlStr) else {
            return
        }
        
        do {
            // reference date before retrievin the IP.
            let referenceDate = currentTimeMillis()
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            let elapsed = currentTimeMillis() - referenceDate
            let duration = Int(elapsed)
            responseTimeLabel.stringValue = String(duration) + " ms"
            let parser = IpXmlParser();
            parser.parse(xmlString: myHTMLString)
            
            ipLabel.stringValue = parser.Ip
            countryLabel.stringValue = parser.CountryName
            cityLabel.stringValue = parser.City
            
            connected = true
        } catch {
            ipLabel.stringValue = "<Not Connected>"
            countryLabel.stringValue = "..."
            cityLabel.stringValue = "..."
            connected = false
        }
        
        timeLabel.stringValue = getCurrentTimeAsString()
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble * 1000)
    }
    
    private func getCurrentTimeAsString() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(String(format: "%02d", hour)).\(String(format: "%02d", minutes)).\(String(format: "%02d", seconds))"
    }
    
    @discardableResult
    func switchWifi(to: WifiStatus) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["networksetup", "-setairportpower", "en0", to == .on ? "on" : "off"]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
