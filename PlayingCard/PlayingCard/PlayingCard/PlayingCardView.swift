//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Vasanthakumar Annadurai on 06/09/22.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    // MARK : Variables
    @IBInspectable
    var rank: Int = 5 { didSet{setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    var suit: String = "❤️" { didSet{setNeedsDisplay(); setNeedsLayout()} }
    @IBInspectable
    var isFaceUp: Bool = false { didSet{setNeedsDisplay(); setNeedsLayout()} }
    
    private var cornerString: NSAttributedString{
        return centredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    private var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet{setNeedsDisplay()} } // On change of scale, we only need to redraw & we will not affect our subViews.
    
    // MARK : Overriden Methods.
    // Method gets called to draw our view.
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp{
            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }else{
                drawPips()
            }
        }else{
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
    // Method gets called to position our SubViews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Upper Left Corner Label.
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        // Lower Right Corner Label.
        configureCornerLabel(lowerRightCornerLabel)
        // Position lower right label.
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY) // Move to lowerRight corner.
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset) // Move up by Corner offset.
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height) // Move up by its size
        // Rotate lower right label.
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .rotated(by: CGFloat.pi)
    }
    
    // Method gets called on Traits Change (like changing AccessabilitySizes etc).
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // MARK : Action Methods.
    @objc func adjustFaceCardScale(byHandlingGestureRecogonizedBy regonizer: UIPinchGestureRecognizer){
        switch regonizer.state{
        case .changed, .ended:
            faceCardScale *= regonizer.scale
            regonizer.scale = 1.0
        default: break
        }
    }
    
    // MARK : Private Methods
    // Method creates & return the AttributedString with following attributes 1. Set font & size 2. Align the text to center.
    private func centredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.font: font, .paragraphStyle: paragraphStyle])
    }
    
    // Method used to create Corner label.
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    // Method used to configure Corner label.
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    // Draws Pips.
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
}

extension PlayingCardView{
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

// Pratice Of Draw
extension PlayingCardView {
    
    //override func draw(_ rect: CGRect) {
    /* just let our know the concept
     if let context = UIGraphicsGetCurrentContext() {
     context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
     context.setLineWidth(5.0)
     UIColor.green.setFill()
     UIColor.red.setStroke()
     context.fillPath()
     }
     */
    /* pratice UIBezierPath()
     let path = UIBezierPath()
     path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
     UIColor.green.setFill()
     UIColor.red.setStroke()
     path.stroke()
     path.fill()
     */
    
    //}
}
