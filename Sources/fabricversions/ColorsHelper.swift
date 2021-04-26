fileprivate let BG = 40
fileprivate let FG = 30
fileprivate let BRIGHT = 60

public typealias Attrs = TextAttributes
public typealias Color = ColorRepresentation

public enum TerminalColors: Int {
  case black = 0
  case red = 1
  case green = 2
  case yellow = 3
  case blue = 4
  case magenta = 5
  case cyan = 6
  case white = 7

  case none = -1
}

public enum TextAttributes: Int {
  case reset = 0
  case bold = 1
  case dim = 2
  case italic = 3
  case underline = 4
  case slow_blink = 5
  case rapid_blink = 6
  case invert = 7
  case hide = 8
  case strikethrough = 9

  case default_font = 10
  case font_1 = 11
  case font_2 = 12
  case font_3 = 13
  case font_4 = 14
  case font_5 = 15
  case font_6 = 16
  case font_7 = 17
  case font_8 = 18
  case font_9 = 19
  case blackletter = 20

  case doubly_underlined = 21
  case normal_weight = 22

  case no_italic_no_blackletter = 23
  case no_underline = 24
  case no_blink = 25

  case proportional_spacing = 26

  case not_reverse = 27
  case reveal = 28
  case not_strikethrough = 29

  case default_fg = 39
  case deault_bg = 49

  case no_proportional_spacing = 50

  case framed = 51
  case encircled = 52
  case overline = 53

  case no_frame_or_circle = 54
  case no_overline = 55
}

public struct ColorRepresentation { // Gotta use those value types
  public static let RESET: ColorRepresentation = ColorRepresentation(.black).reset()

  public static prefix func !(operand: ColorRepresentation) -> String {
    return operand.toString()
  }

  public func brighten() -> ColorRepresentation {
    var newNumbers = self.numbers
    newNumbers[2] = BRIGHT

    return ColorRepresentation(newNumbers)
  }

  public func darken() -> ColorRepresentation {
    var newNumbers = self.numbers
    newNumbers[2] = 0

    return ColorRepresentation(newNumbers)
  }

  public func fg() -> ColorRepresentation {
    var newNumbers = self.numbers
    newNumbers[1] = FG

    return ColorRepresentation(newNumbers)
  }

  public func bg() -> ColorRepresentation {
    var newNumbers = self.numbers
    newNumbers[1] = BG

    return ColorRepresentation(newNumbers)
  }

  public func attr(_ attribute: Attrs) -> ColorRepresentation {
    var newNumbers = self.numbers
    newNumbers.append(attribute.rawValue)

    return ColorRepresentation(newNumbers)
  }

  public func reset() -> ColorRepresentation {
    return attr(.reset)
  }

  public func paint(_ text: String, if condition: Bool = true) -> String {
    return (condition ? !self : "") + text + (condition ? !.RESET : "")
  }

  fileprivate func toString() -> String {
    let firstNum = numbers[0...2].reduce(0, +)
    var initialString = "\u{001B}[" + (
      firstNum != 0 ? String(firstNum) : ""
    )

    for num in numbers[3...] {
      if initialString.last != ";" {
        initialString += ";"
      }
      initialString += String(num)
    }

    return initialString + "m"
  }

  private var numbers: [Int]

  private init(_ numbers: [Int]) {
    self.numbers = numbers
  }

  public init(_ color: TerminalColors) {
    self.init(color == .none ? [0, 0, 0] : [color.rawValue, FG, 0])
  }
}

public extension String {
  init(_ value: ColorRepresentation) {
    self = value.toString()
  }
}
