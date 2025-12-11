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
  
  func localiz(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  var roundedIntString: String {
    if let value = Double(self) {
      return "\(Int(value.rounded()))"
    }
    return self
  }
  
}
