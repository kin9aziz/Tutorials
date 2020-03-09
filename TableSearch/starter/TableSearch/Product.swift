/*
 
 Abstract:
 The data model object describing the product displayed in both main and results tables.
 */

import Foundation

class Product: NSObject {
  
  private enum CoderKeys: String {
    case nameKey
    case yearKey
    case priceKey
  }
  
  // MARK: - Properties
  
  /** These properties need @objc to make them key value compliant when filtering using NSPredicate,
   and so they are accessible and usable in Objective-C to interact with other frameworks.
   */
  @objc let title: String
  @objc let yearIntroduced: Int
  @objc let introPrice: Double
  
  // MARK: - Initializers
  
  init(title: String, yearIntroduced: Int, introPrice: Double) {
    self.title = title
    self.yearIntroduced = yearIntroduced
    self.introPrice = introPrice
  }
  
}
