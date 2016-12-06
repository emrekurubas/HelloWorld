//
//  main.swift
//  Day6
//
//  Created by Emre Kurubas on 06/12/16.
//  Copyright © 2016 Emre Kurubas. All rights reserved.
//  First advent of code app with swift.

import Foundation

// change this to false if you want to calculate the result for part2.
var part1 = false

func InitializeDictionary() -> [Character: Int] {
    var array = [Character: Int]();
    
    for char in "abcdefghijklmnopqrstuvwxyz".characters {
        array[char] = 0
    }
    
    return array;
}

var path = "input.txt"
var values: String

// Read file and assign content to a string.
do {
    values = try String(contentsOfFile: path)
}
catch let x {
    print (x.localizedDescription)
    values = String()
}

// Get data into an array line by line.
var lines = values.components(separatedBy: "\n")

// This array is supposed to contain 8 elements. Each element is a dictionary of alphabet members as keys and value as integers.
var keyArray = [[Character: Int]]()

// Initialize dictionary with 0 values.
for i in 0...7 {
    keyArray.append(InitializeDictionary())
}

// Main loop for collecting column data for each line.
for line in lines {
    var index = 0
    for ch in line.characters {
        keyArray[index][ch] = keyArray[index][ch]! + 1
        index = index + 1
    }
}

// Find out which character at which column is most frequent.
var result = String()

for i in 0...7 {
    let dict = keyArray[i]
    var maxItem = dict.first { $0.value == (part1 ? dict.values.max() : dict.values.min()) }
    result.append(maxItem!.key)
}

print(result)

// end of file
