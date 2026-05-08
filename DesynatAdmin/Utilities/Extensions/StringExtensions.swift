//
//  StringExtensions.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation

extension String {
  
  func trimmed() -> String {
    return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }
  
  var roundedIntString: String {
    if let value = Double(self) {
      return "\(Int(value.rounded()))"
    }
    return self
  }
  
}

extension String {
  func formattedPlacedDate() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
//    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
      if AppLanguageManager.shared.currentLanguage == .ar {
          inputFormatter.locale = Locale(identifier: "ar")
         } else {
             inputFormatter.locale = Locale(identifier: "en_US")
         }
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    guard let date = inputFormatter.date(from: self) else {
      return ""
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd/MM/yy 'at' h:mm a"
    outputFormatter.locale = Locale.current
    outputFormatter.timeZone = TimeZone.current
    
    return outputFormatter.string(from: date)
  }
}

