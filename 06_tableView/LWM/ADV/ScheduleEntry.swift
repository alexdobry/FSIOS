//
//  ScheduleEntry.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

class ScheduleEntry: NSObject, NSCoding {
    let date: Date
    let start: Date
    let end: Date
    let room: String
    let labwork: String
    let course: String
    let degree: String
    let group: String
    
    init(date: Date, start: Date, end: Date, room: String, labwork: String, course: String, degree: String, group: String) {
        self.date = date
        self.start = start
        self.end = end
        self.room = room
        self.labwork = labwork
        self.course = course
        self.degree = degree
        self.group = group
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(start, forKey: "start")
        aCoder.encode(end, forKey: "end")
        aCoder.encode(room, forKey: "room")
        aCoder.encode(labwork, forKey: "labwork")
        aCoder.encode(course, forKey: "course")
        aCoder.encode(degree, forKey: "degree")
        aCoder.encode(group, forKey: "group")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let date = aDecoder.decodeObject(forKey: "date") as? Date,
            let start = aDecoder.decodeObject(forKey: "start") as? Date,
            let end = aDecoder.decodeObject(forKey: "end") as? Date,
            let room = aDecoder.decodeObject(forKey: "room") as? String,
            let labwork = aDecoder.decodeObject(forKey: "labwork") as? String,
            let course = aDecoder.decodeObject(forKey: "course") as? String,
            let degree = aDecoder.decodeObject(forKey: "degree") as? String,
            let group = aDecoder.decodeObject(forKey: "group") as? String
            else { return nil }
        
        self.init(
            date: date,
            start: start,
            end: end,
            room: room,
            labwork: labwork,
            course: course,
            degree: degree,
            group: group
        )
    }
}

extension ScheduleEntry {
    
    static func parseJson(json: [Json]) -> [ScheduleEntry] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2017-06-29
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSS" // 12:00:00.000
        
        return json.flatMap { j -> ScheduleEntry? in
            /*var date: Date
             
             let stringDate = j["date"] as? String
             if let stringDate = stringDate {
             if let safeDate = dateFormatter.date(from: stringDate) {
             date = safeDate
             }
             }*/
            
            guard let date = (j["date"] as? String).flatMap(dateFormatter.date),
                let start = (j["start"] as? String).flatMap(timeFormatter.date),
                let end = (j["end"] as? String).flatMap(timeFormatter.date),
                let room = (j["room"] as? Json)?["label"] as? String,
                let labworkJson = j["labwork"] as? Json,
                let labwork = labworkJson["label"] as? String,
                let course = (labworkJson["course"] as? Json)?["abbreviation"] as? String,
                let degree = (labworkJson["degree"] as? Json)?["abbreviation"] as? String,
                let group = (j["group"] as? Json)?["label"] as? String
                else { return nil }
            
            return ScheduleEntry(date: date, start: start, end: end, room: room, labwork: labwork, course: course, degree: degree, group: group)
        }
    }
}
