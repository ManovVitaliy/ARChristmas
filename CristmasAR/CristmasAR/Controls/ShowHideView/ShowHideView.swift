//
//  ShowHideView.swift
//  CristmasAR
//
//  Created by user on 12/5/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit

class ShowHideView: UIView {
    var view: UIView
    
    var viewTopAnchor: NSLayoutConstraint?
    
    @IBOutlet weak var customCollectionView: CustomCollectionView!
    
    var isHide = true
    
    init(superview: UIView) {
        view = UIView()
        
        super.init(frame: .zero)
        
        view = loadViewFromNib()
        self.addSubview(view)
        superview.addSubview(self)
        setupConstraints(superview: superview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setupConstraints(superview: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        viewTopAnchor = self.topAnchor.constraint(equalTo: superview.bottomAnchor)
        
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                                     self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                                     self.heightAnchor.constraint(equalTo: superview.widthAnchor),
                                     viewTopAnchor!,
                                     
                                     view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     view.topAnchor.constraint(equalTo: self.topAnchor),
                                     view.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func toggleView(_ fullscreen: Int, superView: UIView){
        if(fullscreen == 0) {
            self.viewTopAnchor?.constant = 0 // full to zero -- 0
            self.isHide = true
        } else if(fullscreen == 1) {
            self.viewTopAnchor?.constant = -superView.frame.size.width * 0.8 // zero to full -- 1
            self.isHide = false
        }
        UIView.animate(withDuration: 0.5) {
            superView.layoutIfNeeded()
        }
    }
}
