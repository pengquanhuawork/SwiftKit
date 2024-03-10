//
//  SKSwitch.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/3.
//

import UIKit

open class SKSwitch: UIControl {
    
    private var circle: UIView!
    private var p_isOn: Bool = false
    
    public var tapAction: (() -> Void)?
    
    public var circleInset: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var isOn: Bool {
        set {
            setIsOn(newValue, animated: false)
            setNeedsLayout()
        }
        get {
            return p_isOn
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public var onColor: UIColor = .blue {
        didSet {
            updateSwitchColors()
        }
    }
    
    public var offColor: UIColor = UIColor(hex: "#999999") {
        didSet {
            updateSwitchColors()
        }
    }
    
    private func updateSwitchColors() {
        backgroundColor = p_isOn ? onColor : offColor
    }
    
    private func configureCircleFrame() {
        let circleSize = CGSize(width: bounds.height - 2 * circleInset, height: bounds.height - 2 * circleInset)
        if p_isOn {
            circle.frame = CGRect(x: bounds.width - circleSize.width - circleInset, y: circleInset, width: circleSize.width, height: circleSize.height)
        } else {
            circle.frame = CGRect(x: circleInset, y: circleInset, width: circleSize.width, height: circleSize.height)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        configureCircleFrame()
        layer.cornerRadius = bounds.height / 2
        circle.layer.cornerRadius = circle.bounds.height / 2
    }
    
    private func setupUI() {
        circle = UIView(frame: CGRect.zero)
        circle.backgroundColor = .white
        addSubview(circle)
        configureCircleFrame()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        isOn = p_isOn // 默认关闭
    }
    
    public func setIsOn(_ isOn: Bool, animated: Bool) {
        self.p_isOn = isOn
        updateSwitchColors()
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.configureCircleFrame()
            }
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        setIsOn(!isOn, animated: true)
        sendActions(for: .touchUpInside)
    }
}
