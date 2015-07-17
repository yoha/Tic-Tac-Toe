//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Yohannes Wijaya on 7/11/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    // MARK: - Stored properties
    
    var tileSelector = 1 // 1 for cross, 2 for circle
    var tileState = [Int](count: 9, repeatedValue: 0)
    var winningCombinations = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    var tileImage: UIImage?
    var isWinningCombinationFound = false
    var howManyTurns = 0
    let animationDelay: NSTimeInterval = 0.5
    var scoreOnCross = 0
    var scoreOnCircle = 0
    let addFunc: (CGFloat, CGFloat) -> CGFloat = (+)
    let substractFunc: (CGFloat, CGFloat) -> CGFloat = (-)
    
    // MARK: - Outlet properties
    
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet var tappedTiles: [UIButton]!
    @IBOutlet weak var winningTileImageView: UIImageView!
    @IBOutlet weak var winningLabel: UIButton!
    @IBOutlet weak var resetTilesButton: UIButton!
    @IBOutlet var whoseTurnIndicatorLabel: [UILabel]!
    @IBOutlet var whoseTurnIndicatorImageView: [UIImageView]!
    @IBOutlet weak var scoreOnCrossLabel: UILabel!
    @IBOutlet weak var scoreOnCircleLabel: UILabel!
    
    // MARK: - Action properties
    
    @IBAction func tapTile(sender: UIButton) {
        implementTileState(sender)
    }
    @IBAction func resetTilesButton(sender: UIButton) {
        self.showWhoseTurnIndicator(false, isCircleHidden: true)
        self.returnAllTilesDefaultState(true, isSetImageNil: true)
        /* Alternatively to enumerate all the buttons using tag
        without connecting each and every tile to this controller
        
        var eachTile: UIButton
        for var i = 0;  i < 9; i++ {
            eachTile = view.viewWithTag(i)
            eachTile.setImage(nil, forState: .Normal)
        }
        
        */
        self.winningTileImageView.image = nil
        self.winningLabel.setTitle(".", forState: UIControlState.Normal)
        self.tileState = [Int](count: 9, repeatedValue: 0)
        self.howManyTurns = 0
        self.tileSelector = 1
        self.dimAllWhoseTurnIndicator(false)
        UIView.animateWithDuration(animationDelay) { () -> Void in
            self.slideGameoverAssets(self.addFunc, isHidden: true)
        }
    }
    @IBAction func resetGameAndScores(sender: UIButton) {
        self.returnAllTilesDefaultState(true, isSetImageNil: true)
        self.updateScores()
    }

    // MARK: - Local methods
    
    func determineWinningCombinations() {
        for possibleCombination in winningCombinations {
            if self.tileState[possibleCombination[0]] != 0 && self.tileState[possibleCombination[0]] == self.tileState[possibleCombination[1]] && self.tileState[possibleCombination[1]] == self.tileState[possibleCombination[2]] {
                if self.tileState[possibleCombination[0]] == 1 {
                    self.updateScores(1, scoreCircle: 0)
                    self.winningTileImageView.image = UIImage(named: "cross")!
                    self.winningLabel.setTitle("has won", forState: UIControlState.Normal)
                }
                else {
                    self.updateScores(0, scoreCircle: 1)
                    self.winningTileImageView.image = UIImage(named: "circle")!
                    self.winningLabel.setTitle("has won", forState: UIControlState.Normal)
                }
                self.returnAllTilesDefaultState(false)
                self.dimAllWhoseTurnIndicator(true)
                UIView.animateWithDuration(self.animationDelay) { () -> Void in
                    self.slideGameoverAssets(self.substractFunc, isHidden: false)
                }
                self.showWhoseTurnIndicator()
            }
        }
        howManyTurns++
        if self.howManyTurns == 9 && self.winningLabel.titleLabel!.text! == "." {
            self.winningTileImageView.image = UIImage(named: "tie")!
            self.winningLabel.setTitle("Yup it is!", forState: UIControlState.Normal)
            self.returnAllTilesDefaultState(false)
            self.dimAllWhoseTurnIndicator(true)
            UIView.animateWithDuration(0.5) { () -> Void in
                self.slideGameoverAssets(self.substractFunc, isHidden: false)
            }
            self.showWhoseTurnIndicator()
        }
    }
    
    func dimAllWhoseTurnIndicator(choice: Bool) {
        for indicator in self.whoseTurnIndicatorImageView {
            if choice { indicator.alpha = 0.3 }
            else { indicator.alpha = 1.0 }
        }
    }
    
    func implementTileState(sender: UIButton) {
        if self.tileState[sender.tag] == 0 {
            self.tileState[sender.tag] = tileSelector
            self.setTileSelector()
        }
        sender.setImage(self.tileImage, forState: UIControlState.Normal)
        sender.userInteractionEnabled = false
        self.determineWinningCombinations()
    }
    
    func returnAllTilesDefaultState(isTileEnabled: Bool, isSetImageNil: Bool = false) {
        for (_, tile) in tappedTiles.enumerate() {
            tile.enabled = isTileEnabled
            tile.userInteractionEnabled = true
            if isSetImageNil { tile.setImage(nil, forState: .Normal) }
            if isTileEnabled {
                tile.alpha = 1.0
                self.boardImageView.alpha = 1.0
            }
            else {
                tile.alpha = 0.3
                self.boardImageView.alpha = 0.3
            }
        }
    }
    
    func setTileSelector() {
        if tileSelector == 1 {
            self.tileImage = UIImage(named: "cross")!
            self.showWhoseTurnIndicator(true, isCircleHidden: false)
            self.tileSelector = 2
        }
        else {
            self.tileImage = UIImage(named: "circle")!
            self.showWhoseTurnIndicator(false, isCircleHidden: true)
            self.tileSelector = 1
        }
    }
    
    func setGameoverAssetsBorderProperties(args: UIButton...) {
        for arg in args {
            arg.layer.borderColor = UIColor.blackColor().CGColor
            arg.layer.borderWidth = 3
            arg.layer.cornerRadius = 7
        }
    }
    
    func showWhoseTurnIndicator(isCrossHidden: Bool = true, isCircleHidden: Bool = true) {
        self.whoseTurnIndicatorLabel[0].hidden = isCrossHidden
        self.whoseTurnIndicatorLabel[1].hidden = isCircleHidden
    }
    
    func slideGameoverAssets(operation: (CGFloat, CGFloat) -> CGFloat, isHidden: Bool) {
        self.winningLabel.hidden = isHidden
        self.winningTileImageView.hidden = isHidden
        self.resetTilesButton.hidden = isHidden
        self.winningLabel.center = CGPoint(x: self.winningLabel.center.x, y: operation(self.winningLabel.center.y, 400))
        self.winningTileImageView.center = CGPoint(x: self.winningTileImageView.center.x, y: operation(self.winningTileImageView.center.y, 400))
        self.resetTilesButton.center = CGPoint(x: self.resetTilesButton.center.x, y: operation(self.resetTilesButton.center.y, 400))
    }
    
    func updateScores(scoreCross: Int = 0, scoreCircle: Int = 0) {
        if scoreCross == 0 && scoreCircle == 0 {
            self.scoreOnCross = scoreCross
            self.scoreOnCircle = scoreCircle
        }
        else {
            self.scoreOnCross += scoreCross
            self.scoreOnCircle += scoreCircle
        }
        self.scoreOnCrossLabel.text = String(self.scoreOnCross)
        self.scoreOnCircleLabel.text = String(self.scoreOnCircle)
    }
    
    
    // MARK: - UIViewController override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideGameoverAssets(self.addFunc, isHidden: true)
        self.showWhoseTurnIndicator(false, isCircleHidden: true)
        self.setGameoverAssetsBorderProperties(self.winningLabel, self.resetTilesButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

