//
//  IpXmlParser.swift
//  KillSwitch
//
//  Created by Emre Kurubas on 08/01/17.
//  Copyright © 2017 Emre Kurubas. All rights reserved.
//

import Cocoa

class IpXmlParser : NSObject, XMLParserDelegate {
    var Ip = "";
    var CountryName = "";
    var City = "";
    
    var foundCharacters = "";
    
    func parse(xmlString: String) {
        let xmlData = xmlString.data(using: .utf8)!
        let parser = XMLParser(data: xmlData)
        
        parser.delegate = self;
        
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "IP") {
            self.Ip = foundCharacters.trimmingCharacters(in: .newlines)
        }
        else if elementName == "CountryName" {
            self.CountryName = foundCharacters.trimmingCharacters(in: .newlines)
        }
        else if elementName == "City" {
            self.City = foundCharacters.trimmingCharacters(in: .newlines)
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string;
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error: ", parseError)
    }
}

