//
//  CustomCollectionView.swift
//  CristmasAR
//
//  Created by user on 12/5/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit

protocol CustomCollectionViewDataSource {
    func numberOfItemsInSection() -> Int
    func cellForItem(index: Int) -> UIView
}

protocol CustomCollectionViewDelegate {
    func didSelectItem(index: Int)
}

// recomend number of items in collectionView <= 10

class CustomCollectionView: UIView {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    var dataSource: CustomCollectionViewDataSource?
    var delegate: CustomCollectionViewDelegate?
    
    private func minimalSize() -> CGFloat {
        return min(self.frame.size.width, self.frame.size.height)
    }
    
    // return number of items in collection view
    func numberOfItems() -> Int {
        
        let countOfItems = dataSource?.numberOfItemsInSection()
        return countOfItems ?? 5
    }
    
    func cellForItem(index: Int) -> UIView {
        let cell = dataSource?.cellForItem(index: index)
        return cell ?? UIView()
    }
    
    //backgroundImageView
    var backGroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return backgroundImageView
    }()
    
    // Main image view in center collection view
    var infoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    var mainImageView: UIImageView = {
        let mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.backgroundColor = UIColor.green
        
        return mainImageView
    }()
    
    private func setupUI() {
        addBackGroundImageView()
        addMainImageView()
        setupItems(countOfItems: numberOfItems())
    }
    
    private func addBackGroundImageView() {
        self.addSubview(backGroundImageView)
        
        backGroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backGroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backGroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backGroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func addMainImageView() {
        self.addSubview(mainImageView)
        
        mainImageView.centerXAnchor.constraint(equalTo: backGroundImageView.centerXAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: backGroundImageView.centerYAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: minimalSize() / 3).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: minimalSize() / 3).isActive = true
        mainImageView.layer.cornerRadius = minimalSize() / 6
    }
    
    private func setupItems(countOfItems: Int) {
        
        backGroundImageView.isUserInteractionEnabled = true
        for i in 0..<countOfItems {
            let deltaCenterX = getDeltaCenterForView(currentItemNumber: i, allItemsCount: countOfItems).deltaX
            let deltaCenterY = getDeltaCenterForView(currentItemNumber: i, allItemsCount: countOfItems).deltaY
            
            let item = cellForItem(index: i)
            item.translatesAutoresizingMaskIntoConstraints = false
            item.tag = i
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(gesture)
            
            backGroundImageView.addSubview(item)
            
            item.centerXAnchor.constraint(equalTo: backGroundImageView.centerXAnchor, constant: CGFloat(deltaCenterX)).isActive = true
            item.centerYAnchor.constraint(equalTo: backGroundImageView.centerYAnchor, constant: CGFloat(deltaCenterY)).isActive = true
            item.heightAnchor.constraint(equalToConstant: minimalSize() / 4).isActive = true
            item.widthAnchor.constraint(equalToConstant: minimalSize() / 4).isActive = true
            item.layer.cornerRadius = minimalSize() / 8
//            item.backgroundColor = UIColor.red
        }
        
        self.sendSubviewToBack(mainImageView)
    }
    
    // did select item
    @objc func handleTap(sender:UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            delegate?.didSelectItem(index: tag)
        }
    }
    
    // reload collection view
    func reloadData() {
        backGroundImageView.subviews.forEach({ $0.removeFromSuperview() })
        cleanLayersFromMainImageView()
        setupItems(countOfItems: numberOfItems())
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        let startCyrcleRadius: CGFloat = 2.0
        let startCircle = UIBezierPath(ovalIn: CGRect(x: start.x - startCyrcleRadius,
                                                      y: start.y - startCyrcleRadius,
                                                      width: startCyrcleRadius * 2,
                                                      height: startCyrcleRadius * 2))
        startCircle.fill()
        
        let startCircleShapeLayer = CAShapeLayer()
        startCircleShapeLayer.fillColor = lineColor.cgColor
        startCircleShapeLayer.path = startCircle.cgPath
        
        view.layer.addSublayer(startCircleShapeLayer)
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func cleanLayersFromMainImageView() {
        if let sublayers = mainImageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    private func getDeltaCenterForView(currentItemNumber: Int, allItemsCount: Int) -> (deltaX: CGFloat, deltaY: CGFloat) {
        let radius = Double(minimalSize() / 3)
        // calculate data for item's constraints
        // angle is 360 / 7
        let deltaAngle = 2 * .pi / Double(7)
        let angle = deltaAngle * Double(currentItemNumber)
        var deltaCenterX = 0.0
        var deltaCenterY = 0.0
        switch allItemsCount {
        case 2:
            if currentItemNumber == 0 {
                deltaCenterX = cos(angle + 3 * .pi / 2 - deltaAngle) * radius
                deltaCenterY = sin(angle + 3 * .pi / 2 - deltaAngle) * radius
            } else {
                deltaCenterX = cos(angle + 3 * .pi / 2) * radius
                deltaCenterY = sin(angle + 3 * .pi / 2) * radius
            }
        case 3, 4:
            deltaCenterX = cos(angle + 3 * .pi / 2 - deltaAngle) * radius
            deltaCenterY = sin(angle + 3 * .pi / 2 - deltaAngle) * radius
        case 5:
            deltaCenterX = cos(angle + 3 * .pi / 2 - deltaAngle * 2) * radius
            deltaCenterY = sin(angle + 3 * .pi / 2 - deltaAngle * 2) * radius
        default:
            deltaCenterX = cos(angle + 3 * .pi / 2) * radius
            deltaCenterY = sin(angle + 3 * .pi / 2) * radius
        }
        return(CGFloat(deltaCenterX), CGFloat(deltaCenterY))
    }
}
