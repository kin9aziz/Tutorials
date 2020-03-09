/*
 Abstract:
 The data model object describing the product displayed in both main and results tables.
 */

import Foundation

class Product: NSObject {
  
  // MARK: - Properties
  
  /** These properties need @objc to make them key value compliant when filtering using NSPredicate,
   and so they are accessible and usable in Objective-C to interact with other frameworks.
   */
  @objc let title: String
  
  // MARK: - Initializers
  
  init(title: String) {
    self.title = title
  }
  
}
