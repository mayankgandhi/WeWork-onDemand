//
//  Layout.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/9/21.
//

import Foundation

import UIKit

// MARK: - Layout
public extension CGFloat {
  /// CTA button height
  static var buttonHeight: CGFloat { 40 }
  /// CTA button corner radius
  static var buttonRadius: CGFloat { 4 }
  /// Radius of the outer corners of the package view
  static var packageRadius: CGFloat { 12 }
  /// Spacing between each UI elements in the package view
  static var packageSpacing: CGFloat { 24 }
  /// Spacing between each thumbnail image
  static var thumbnailSpacing: CGFloat { 4 }
  /// Height of the `primary` thumbnail image
  static var thumbnailHeight: CGFloat { 240 }
  /// Corner radius of `primary` and `secondary` thumbnail images
  static var thumbnailRadius: CGFloat { 8 }
  /// Corner border width of secondary thumbnail images
  static var thumbnailBorderWidth: CGFloat { 4 }
  /// Line height ratio between text with multiple lines
  static var lineHeightMultiple: CGFloat { 1.3 }
}
