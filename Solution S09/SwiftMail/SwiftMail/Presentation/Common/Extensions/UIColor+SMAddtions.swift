import UIKit

extension UIColor {
    class var smTUMBlue: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 152.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0)
    }
    
    //To always return the same color for the same string, we map its' length to a rawvalue on the ColorEnum
    static func fromString(name: String) -> UIColor {
        let colorIndex = name.characters.count % 7
        guard let color = ColorEnum(rawValue: colorIndex)?.toColor() else {
            return UIColor.lightGray
        }
        return color
    }
    
    enum ColorEnum: Int {
        case turquoise   // = "0"
        case emerald // = "1"
        case blue  // = "2"
        case sunflower  // = "3"
        case carrot  // = "4"
        case red  // = "5"
        case amethyst // = 6
        
        func toColor() -> UIColor {
            switch self {
            case .turquoise:
                return UIColor(red: 26.0 / 255.0, green: 188.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
            case .emerald:
                return UIColor(red: 46.0 / 255.0, green: 204.0 / 255.0, blue: 113.0 / 255.0, alpha: 1.0)
            case .blue:
                return UIColor(red: 53.0 / 255.0, green: 152.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0)
            case .sunflower:
                return UIColor(red: 241.0 / 255.0, green: 196.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
            case .carrot:
                return UIColor(red: 230.0 / 255.0, green: 126.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
            case .red:
                return UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
            case .amethyst:
                return UIColor(red: 155.0 / 255.0, green: 89.0 / 255.0, blue: 182.0 / 255.0, alpha: 1.0)
            }
        }
    }
}
