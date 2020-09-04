//
//  TickMarkCircleView.swift
//  TickMarkCircleViewDemoKit
//
//  Created by Robert Ryan on 9/4/20.
//

import UIKit

@IBDesignable
public class TickMarkCircleView: UIView {

    @IBInspectable public var lineWidth: CGFloat = 3             { didSet { setNeedsLayout() } }
    @IBInspectable public var tickLength: CGFloat = 10           { didSet { setNeedsLayout() } }
    @IBInspectable public var tickCount: Int = 180               { didSet { setNeedsLayout() } }
    @IBInspectable public var startAngle: CGFloat = -.pi / 2     { didSet { setNeedsLayout() } }
    @IBInspectable public var endAngle: CGFloat = 3 * .pi / 2    { didSet { setNeedsLayout() } }
    @IBInspectable public var percent: CGFloat = 1               { didSet { didUpdatePercent() } }

    private let strokeLayer: CAShapeLayer = CAShapeLayer()

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        updateMask()
        updateStrokePath()
    }
}

private extension TickMarkCircleView {

    func configure() {
        strokeLayer.lineCap = .butt
        strokeLayer.strokeColor = UIColor.red.cgColor
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeStart = strokeStart
        strokeLayer.lineWidth = tickLength
        layer.addSublayer(strokeLayer)
    }

    func updateMask() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor // note, color doesn't matter; only alpha
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }

    func didUpdatePercent() {
        strokeLayer.strokeStart = strokeStart
    }

    func updateStrokePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - tickLength) / 2

        strokeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: startAngle < endAngle).cgPath
    }

    var strokeStart: CGFloat {
        return 1 - percent
    }

    var maskPath: UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath()
        let maxRadius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let minRadius = maxRadius - tickLength + lineWidth

        for i in 0 ..< tickCount {
            let angle = startAngle + (endAngle - startAngle) * CGFloat(i) / CGFloat(tickCount)
            let startPoint = center.point(at: angle, distance: minRadius)
            let endPoint = center.point(at: angle, distance: maxRadius)
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }

        return path
    }

}

private extension CGPoint {
    func point(at angle: CGFloat, distance: CGFloat) -> CGPoint {
        return CGPoint(x: x + distance * cos(angle), y: y + distance * sin(angle))
    }
}

