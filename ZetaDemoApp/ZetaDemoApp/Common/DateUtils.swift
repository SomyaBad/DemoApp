import Foundation

struct DateUtils {
    
    // Function to extract the year from a date string
    static func getYear(from dateString: String, format: String = "yyyy-MM-dd", timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        } else {
            return nil
        }
    }

    // Function to convert a date string to a Date object
    static func date(from dateString: String, format: String = "yyyy-MM-dd", timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: dateString)
    }

    // Function to format a Date object to a string
    static func string(from date: Date, format: String = "yyyy-MM-dd", timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
}
