#if os(OSX)
    import Cocoa
#elseif os(watchOS)
    import WatchKit
#else
    import UIKit
#endif

/**
 A component of a `VisualInstruction` that represents a single run of similarly formatted text or an image with a textual fallback representation.
 */
@objc(MBVisualInstructionComponent)
open class VisualInstructionComponent: Component {
    /**
    The URL to an image representation of this component.
 
    The URL refers to an image that uses the device’s native screen scale.
    */
    @objc public var imageURL: URL?
    
    /**
     An abbreviated representation of the `text` property.
     */
    @objc public var abbreviation: String?
    
    /**
     The priority for which the component should be abbreviated.
     
     A component with a lower abbreviation priority value should be abbreviated before a component with a higher abbreviation priority value.
     */
    @objc public var abbreviationPriority: Int = NSNotFound
    
    /**
     Initializes a new visual instruction component object based on the given JSON dictionary representation.
     
     - parameter json: A JSON object that conforms to the [banner component](https://www.mapbox.com/api-documentation/#banner-instruction-object) format described in the Directions API documentation.
     */
    @objc(initWithJSON:)
    public convenience init(json: [String: Any]) {
        let text = json["text"] as? String
        let type = VisualInstructionComponentType(description: json["type"] as? String ?? "") ?? .text
        
        let abbreviation = json["abbr"] as? String
        let abbreviationPriority = json["abbr_priority"] as? Int ?? NSNotFound
        
        var imageURL: URL?
        if let baseURL = json["imageBaseURL"] as? String {
            let scale: CGFloat
            #if os(OSX)
                scale = NSScreen.main?.backingScaleFactor ?? 1
            #elseif os(watchOS)
                scale = WKInterfaceDevice.current().screenScale
            #else
                scale = UIScreen.main.scale
            #endif
            imageURL = URL(string: "\(baseURL)@\(Int(scale))x.png")
        }
        
        self.init(type: type, text: text, imageURL: imageURL, abbreviation: abbreviation, abbreviationPriority: abbreviationPriority)
    }
    
    /**
     Initializes a new visual instruction component object that displays the given information.
     
     - parameter type: The type of visual instruction component.
     - parameter text: The plain text representation of this component.
     - parameter imageURL: The URL to an image representation of this component.
     - parameter abbreviation: An abbreviated representation of `text`.
     - parameter abbreviationPriority: The priority for which the component should be abbreviated.
     */
    @objc public init(type: VisualInstructionComponentType, text: String?, imageURL: URL?, abbreviation: String?, abbreviationPriority: Int) {
        self.imageURL = imageURL
        self.abbreviation = abbreviation
        self.abbreviationPriority = abbreviationPriority
        super.init(text: text, type: type)
    }

    @objc public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        guard let imageURL = decoder.decodeObject(of: NSURL.self, forKey: "imageURL") as URL? else {
            return nil
        }
        self.imageURL = imageURL
        
        guard let abbreviation = decoder.decodeObject(of: NSString.self, forKey: "abbreviation") as String? else {
            return nil
        }
        self.abbreviation = abbreviation
        
        abbreviationPriority = decoder.decodeInteger(forKey: "abbreviationPriority")
    }
    
    public override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(abbreviation, forKey: "abbreviation")
        coder.encode(abbreviationPriority, forKey: "abbreviationPriority")
    }
}

