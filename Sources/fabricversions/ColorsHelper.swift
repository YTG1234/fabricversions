fileprivate let BG = 40
fileprivate let FG = 30
fileprivate let TRUECOLOR_ADDITION = 8
fileprivate let TRUECOLOR_MODIFIER = 2
fileprivate let BRIGHT = 60

public typealias Attrs = TextAttributes
public typealias Color16 = Color16Representation
public typealias ColorRgb = ColorRgbRepresentation

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

public protocol ColorRepresentation {
    func toString() -> String
    func fg() -> Self
    func bg() -> Self
    func attr(attr: Attrs) -> Self
    static prefix func !(operand: Self) -> String
}

/**
 Only works in TrueColor terminals!
*/
public struct ColorRgbRepresentation: Equatable, ColorRepresentation {
    public func attr(attr: Attrs) -> ColorRgbRepresentation {
        var newAttrs = attributes
        newAttrs.append(attr)
        return ColorRgbRepresentation(with: color, and: newAttrs)
    }

    public func toString() -> String {
        var initial = "\u{001B}[\(colorType + TRUECOLOR_ADDITION);\(TRUECOLOR_MODIFIER);\(color.red);\(color.green);\(color.blue)"
        for attr in attributes {
            if initial.last != ";" { initial += ";" }
            initial += "\(attr.rawValue)"
        }
        return initial + "m"
    }

    public func fg() -> ColorRgbRepresentation {
        var c = ColorRgbRepresentation(with: color, and: attributes)
        c.colorType = FG
        return c
    }

    public func bg() -> ColorRgbRepresentation {
        var c = ColorRgbRepresentation(with: color, and: attributes)
        c.colorType = BG
        return c
    }

    public static prefix func !(operand: ColorRgbRepresentation) -> String {
        operand.toString()
    }

    public struct RGB: Equatable {
        public let red: Int
        public let green: Int
        public let blue: Int
    }

    public let color: RGB
    public var colorType: Int
    public let attributes: [Attrs]

    public init(with color: RGB, and attributes: Attrs...) {
        self.init(with: color, and: attributes)
    }

    public init(with color: RGB, and attributes: [Attrs]) {
        self.color = color
        self.attributes = attributes
        self.colorType = FG
    }

    public init(r red: Int, g green: Int, b blue: Int, and attributes: Attrs...) {
        self.init(r: red, g: green, b: blue, and: attributes)
    }

    public init(r red: Int, g green: Int, b blue: Int, and attributes: [Attrs]) {
        self.color = RGB(red: red, green: green, blue: blue)
        self.attributes = attributes
        self.colorType = FG
    }
}

public struct Color16Representation: Equatable, ColorRepresentation { // Gotta use those value types
  public static let RESET: Color16Representation = Color16Representation(.black).reset()

  public static prefix func !(operand: Color16Representation) -> String {
    return operand.toString()
  }

  public func brighten() -> Color16Representation {
    var newNumbers = self.numbers
    newNumbers[2] = BRIGHT

    return Color16Representation(newNumbers)
  }

  public func darken() -> Color16Representation {
    var newNumbers = self.numbers
    newNumbers[2] = 0

    return Color16Representation(newNumbers)
  }

  public func fg() -> Color16Representation {
    var newNumbers = self.numbers
    newNumbers[1] = FG

    return Color16Representation(newNumbers)
  }

  public func bg() -> Color16Representation {
    var newNumbers = self.numbers
    newNumbers[1] = BG

    return Color16Representation(newNumbers)
  }

  public func attr(_ attribute: Attrs) -> Color16Representation {
    var newNumbers = self.numbers
    newNumbers.append(attribute.rawValue)

    return Color16Representation(newNumbers)
  }

  public func reset() -> Color16Representation {
    return attr(.reset)
  }

  public func paint(_ text: String, if condition: Bool = true) -> String {
    return (condition ? !self : "") + text + (condition ? !.RESET : "")
  }

  public func toString() -> String {
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
  init(_ value: Color16Representation) {
    self = value.toString()
  }
}
