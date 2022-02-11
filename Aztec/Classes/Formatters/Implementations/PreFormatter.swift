import Foundation
import UIKit


// MARK: - Pre Formatter
//
open class PreFormatter: ParagraphAttributeFormatter {

    /// Font to be used
    ///
    let monospaceFont: UIFont

    /// Attributes to be added by default
    ///
    let placeholderAttributes: [NSAttributedString.Key: Any]?

    /// Designated Initializer
    ///
    init(monospaceFont: UIFont = FontProvider.shared.monospaceFont, placeholderAttributes: [NSAttributedString.Key : Any]? = nil) {
        self.monospaceFont = monospaceFont
        self.placeholderAttributes = placeholderAttributes
    }


    // MARK: - Overwriten Methods

    func apply(to attributes: [NSAttributedString.Key: Any], andStore representation: HTMLRepresentation?) -> [NSAttributedString.Key: Any] {
        var resultingAttributes = attributes
        let newParagraphStyle = attributes.paragraphStyle()

        newParagraphStyle.appendProperty(HTMLPre(with: representation))

        let defaultFont = attributes[.font]

        resultingAttributes[.paragraphStyle] = newParagraphStyle
        resultingAttributes[.font] = Configuration.useDefaultFont ? defaultFont : monospaceFont

        return resultingAttributes
    }

    func remove(from attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {

        guard let paragraphStyle = attributes[.paragraphStyle] as? ParagraphStyle else {
            return attributes
        }
        let newParagraphStyle = ParagraphStyle()
        newParagraphStyle.setParagraphStyle(paragraphStyle)
        newParagraphStyle.removeProperty(ofType: HTMLPre.self)
        
        var resultingAttributes = attributes
        resultingAttributes.removeValue(forKey: .font)
        resultingAttributes[.paragraphStyle] = newParagraphStyle
        resultingAttributes[.font] = FontProvider.shared.defaultFont
        
        return resultingAttributes
    }

    func present(in attributes: [NSAttributedString.Key : Any]) -> Bool {
        guard let paragraphStyle = attributes[.paragraphStyle] as? ParagraphStyle else {
            return false
        }

        return paragraphStyle.hasProperty(where: { (property) -> Bool in
            return property.isMember(of: HTMLPre.self)
        })
    }
}
