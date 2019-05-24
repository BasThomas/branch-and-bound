import Foundation

extension Int {
  /// Returns the amount of digits of `self`.
  var digits: Int {
    // FIXME: test multiple implementations and their speed
    return String(self).count
  }

  /// Creates a `String` with the integer padded from the left, if needed.
  ///
  /// ```
  /// 1.padded(with: "_", maximumDigits: 5) // "____1"
  /// 123.padded(with: "_", maximumDigits: 2) // "123"
  /// ```
  ///
  /// - Parameters:
  ///   - padCharacter: the character to pad with. Defaults to a space (`" "`).
  ///   - maximumDigits: the maximal amount of digits/characters in the returned
  ///                    string.
  /// - Returns: The number, padded, with a `String` the length of
  /// `maximumDigits`, or the length of the number if it is more than the
  /// specified `maximumDigits`.
  func padded(
    with padCharacter: Character = " ",
    maximumDigits: Int
  ) -> String {
    let digits = self.digits
    let countOrZero = Swift.max(0, (maximumDigits - digits))
    let padCharacters = String(
      repeating: padCharacter,
      count: countOrZero
    )
    return "\(padCharacters)\(self)"
  }
}
