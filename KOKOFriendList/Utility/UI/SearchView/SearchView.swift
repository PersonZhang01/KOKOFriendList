//
//  SearchView.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/6.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchButtonPressed()
}

class SearchView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bodyView: UIView!
    
    weak var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    private func loadXib() {
        let nib = SearchView.nib
        let xibView = nib.instantiate(withOwner: self)[0] as! UIView
        addSubview(xibView)
        
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        configureUI()
    }
    
    func configureUI() {
        self.bodyView.setView(withCornerRadius: CornerRadiusSize.large)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.searchButtonPressed()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

