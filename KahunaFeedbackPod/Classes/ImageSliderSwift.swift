//
//  ImageSliderSwift.swift
//  FIMS
//
//  Created by Piyush Rathi on 23/01/17.
//  Copyright © 2017 Kahuna Systems. All rights reserved.
//

import UIKit
import SDWebImage

class ImageSliderSwift: UIView {

    var parentView: UIView! = nil
    var centeredView: UIView!

    var scrollViewWidth: Int = 0
    var scrollViewHeight: Int = 0

    var popupScrollView: UIScrollView!

    var imagesArray: NSArray!

    static let sharedInstance: ImageSliderSwift = {
        let instance = ImageSliderSwift()
        return instance
    }()

    func initWithFrame(frame: CGRect, parentView: UIView) -> ImageSliderSwift {

        self.parentView = parentView

        let initFrame = CGRect(x: 0, y: 0, width: self.parentView.frame.size.width, height: self.parentView.frame.size.height)
        let mainView = ImageSliderSwift.sharedInstance
        mainView.frame = initFrame

        if let translucidView1 = mainView.viewWithTag(124) {
            translucidView1.removeFromSuperview()
        }

        let translucidView = UIView(frame: initFrame)
        translucidView.tag = 124
        translucidView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)

        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideView))
        translucidView.addGestureRecognizer(singleTapGesture)
        mainView.addSubview(translucidView)

        let margin: Int = 1

        let centeredViewX: Int = Int((self.frame.size.width - frame.size.width) / 2)
        let centeredViewY: Int = Int((self.frame.size.height - frame.size.height) / 2)
        let centeredViewWidth: Int = Int(frame.size.width)
        let centeredViewHeight: Int = Int(frame.size.height)

        let scrollViewX = margin;
        let scrollViewY = margin;
        self.scrollViewWidth = centeredViewWidth - 2 * margin;
        self.scrollViewHeight = centeredViewHeight - 2 * margin;

        //CeneterView
        if let centerVw = mainView.viewWithTag(125) {
            centerVw.removeFromSuperview()
        }
        self.centeredView = UIView(frame: CGRect(x: centeredViewX, y: centeredViewY, width: centeredViewWidth, height: centeredViewHeight))
        self.centeredView.tag = 125
        self.centeredView.backgroundColor = UIColor(colorLiteralRed: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)

        // Scroll view
        self.popupScrollView = UIScrollView(frame: CGRect(x: scrollViewX, y: scrollViewY, width: scrollViewWidth, height: scrollViewHeight))
        self.popupScrollView.backgroundColor = UIColor.white
        self.popupScrollView.isPagingEnabled = true
        self.popupScrollView.bounces = false
        self.centeredView.addSubview(self.popupScrollView)
        mainView.addSubview(self.centeredView)

        //cross image
        if let crossImgVw = mainView.viewWithTag(126) {
            crossImgVw.removeFromSuperview()
        }
        let crossImgView = UIImageView(frame: CGRect(x: centeredView.frame.origin.x + centeredView.frame.size.width - 12, y: centeredView.frame.origin.y - 12, width: 25, height: 25))
        crossImgView.image = UIImage(named: "Cross_Screen.png", in: Bundle(for: ImageSliderSwift.self), compatibleWith: nil)
        crossImgView.backgroundColor = UIColor.clear
        crossImgView.tag = 126
        mainView.addSubview(crossImgView)

        //Cross BTN
        if let crossBtn = mainView.viewWithTag(127) {
            crossBtn.removeFromSuperview()
        }
        let crossButton = UIButton(type: .custom)
        let buttonFrame = CGRect(x: self.centeredView.frame.origin.x + self.centeredView.frame.size.width - 20, y: self.centeredView.frame.origin.y - 20, width: 40, height: 40)
        crossButton.frame = buttonFrame
        crossButton.backgroundColor = UIColor.clear
        crossButton.addTarget(self, action: #selector(onCrossButtonClicked(sender:)), for: .touchUpInside)
        crossButton.tag = 127
        mainView.addSubview(crossButton)

        return mainView
    }

    func hideView() {
        if let centerVw = self.viewWithTag(125) {
            centerVw.removeFromSuperview()
        }
        self.removeFromSuperview()
    }

    func showView() {
        self.parentView.addSubview(self)
    }

    //ADD IMAGES TO VIEW
    func addImagesToView(imagesArray: NSArray) {

        self.imagesArray = NSArray(array: imagesArray)
        self.popupScrollView.contentSize = CGSize(width: scrollViewWidth * self.imagesArray.count, height: scrollViewHeight)

        for i in 0..<self.imagesArray.count {

            let imageView = UIImageView(frame: CGRect(x: 0 + i * self.scrollViewWidth, y: 0, width: self.scrollViewWidth, height: self.scrollViewHeight))
            let imagePath = self.imagesArray[i] as? String

            if (imagePath?.contains("http"))! {
                imageView.sd_setImage(with: URL(string: imagePath!), placeholderImage: UIImage(named: "NoImage.png", in: Bundle(for: ImageSliderSwift.self), compatibleWith: nil))
            }
                else {
                var path = self.getDocumentDirPath()
                path = path.appendingFormat("/%@", imagePath!)
                let tempImage = UIImage(contentsOfFile: path)
                imageView.image = tempImage
            }

            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.clipsToBounds = true

            self.popupScrollView.addSubview(imageView)
        }
    }

    func getDocumentDirPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsPath
    }

    //CROSS BUTTON ACTION
    @IBAction func onCrossButtonClicked(sender: UIButton) {
        self.hideView()
    }

    func setMarginColor(marginColor: UIColor) {
        self.centeredView.backgroundColor = marginColor
    }

    func setScrollViewBackgroundColor(bgColor: UIColor) {
        self.popupScrollView.backgroundColor = bgColor
    }

    func setImageIndex(indexFloat: CGFloat) {
        let num = CGFloat(self.scrollViewWidth) * indexFloat
        self.popupScrollView?.setContentOffset(CGPoint(x: num, y: 0.0), animated: false)
    }

    func setImageIndex(indexValue: Int) {
        let num = Int(self.scrollViewWidth) * indexValue
        self.popupScrollView.setContentOffset(CGPoint(x: num, y: 0), animated: false)
    }

}
