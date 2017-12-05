//
//  LDStickerView.swift
//  LDStickerView
//
//  Created by Vũ Trung Thành on 1/18/15.
//  Copyright (c) 2015 V2T Multimedia. All rights reserved.
//

import UIKit

@objc protocol LDStickerViewDelegate{
    @objc optional func stickerViewDidBeginEditing(sticker:LDStickerView)
    @objc optional func stickerViewDidChangeEditing(sticker:LDStickerView)
    @objc optional func stickerViewDidEndEditing(sticker:LDStickerView)
    @objc optional func stickerViewDidClose(sticker:LDStickerView)
    @objc optional func stickerViewDidShowEditingHandles(sticker:LDStickerView)
    @objc optional func stickerViewDidHideEditingHandles(sticker:LDStickerView)
}
class LDStickerView: UIView, UIGestureRecognizerDelegate, LDStickerViewDelegate {
    private var _globalInset: CGFloat!
    
    private var _initialBounds: CGRect!
    private var _initialDistance: CGFloat!
    
    private var _beginningPoint: CGPoint!
    private var _beginningCenter: CGPoint!
    
    private var _prevPoint: CGPoint!
    private var _touchLocation: CGPoint!
    
    private var _deltaAngle: CGFloat!
    
    private var _startTransform: CGAffineTransform!
    private var _beginBounds: CGRect!
    
    private var _resizeView: UIImageView!
    private var _rotateView: UIImageView!
    private var _closeView: UIImageView!
    private var _isShowingEditingHandles: Bool!
    private var _contentView: UIView!
    private var _delegate: LDStickerViewDelegate?
    private var _showContentShadow: Bool! //Default is YES.
    private var _showCloseView: Bool! //Default is YES. If set to NO, user can't delete the view
    private var _showResizeView: Bool! //Default is YES. If set to NO, user can't resize the view
    private var _showRotateView: Bool! //Default is YES. If set to NO, user can't rotate the view
    
    private var lastTouchedView: LDStickerView!
    
    func refresh(){
        if (superview != nil)
        {
            var scale: CGSize  = CGAffineTransformGetScale(t: transform)
                //CGAffineTransformGetScale(transform)
            var t: CGAffineTransform = CGAffineTransform(scaleX: scale.width, y: scale.height)
            _closeView.transform = t.inverted()
            _resizeView.transform = t.inverted()
            _rotateView.transform = t.inverted()
            if ((_isShowingEditingHandles) != false){
                _contentView.layer.borderWidth = 1/scale.width
            } else {
                _contentView.layer.borderWidth = 0.0
            }
        }
    }
    
    override func didMoveToSuperview(){
        super.didMoveToSuperview()
        refresh()
    }
    
    override init(frame: CGRect) {
        /*(1+_globalInset*2)*/
        if (frame.size.width < (1+12*2)) {
            //frame.size.width = 25
            //frame = CGRectMake(frame.origin.x, frame.origin.y, 25, frame.size.height)
        }
        if (frame.size.height < (1+12*2)){
            //frame.size.height = 25
            
        }
        
        super.init(frame: frame)
        
        _globalInset = 12;
        
        backgroundColor = UIColor.clear
        
        //Close button view which is in top left corner
            _closeView = UIImageView(frame: CGRect(x:bounds.size.width - _globalInset, y: 0, width:_globalInset, height:_globalInset))
        _closeView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue)))
        _closeView.backgroundColor = UIColor.clear
        _closeView.image = UIImage(named: "delete")
        _closeView.isUserInteractionEnabled = true
        addSubview(_closeView)
        
        //Rotating view which is in bottom left corner
        _rotateView = UIImageView(frame: CGRect(x:bounds.size.width - _globalInset,y: bounds.size.height - _globalInset,width: _globalInset, height:_globalInset))
        _rotateView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue)))
        _rotateView.backgroundColor = UIColor.clear
        _rotateView.image = UIImage(named: "rotate")
        _rotateView.isUserInteractionEnabled = true
        addSubview(_rotateView)
        
        //Resizing view which is in bottom right corner
        _resizeView = UIImageView(frame: CGRect(x:0, y:bounds.size.height - _globalInset, width:_globalInset, height:_globalInset))
        _resizeView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue)))
        _resizeView.backgroundColor = UIColor.clear
        _resizeView.isUserInteractionEnabled = true
        _resizeView.image = UIImage(named: "scale")
        addSubview(_resizeView)
        
        var moveGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveGestureCalled))
        moveGesture.minimumPressDuration = 0.4
        addGestureRecognizer(moveGesture)
        
        var singleTapShowHide:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentTapped))
        addGestureRecognizer(singleTapShowHide)
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapCalled))
        _closeView.addGestureRecognizer(singleTap)
        
        var panResizeGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(resizeTranslate))
        
        panResizeGesture.minimumPressDuration = 0
        _resizeView.addGestureRecognizer(panResizeGesture)
        
        var panRotateGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotateViewPanGesture))
        
        panRotateGesture.minimumPressDuration = 0
        _rotateView.addGestureRecognizer(panRotateGesture)
        
        moveGesture.require(toFail: singleTap)
        
        setEnableClose(enableClose: true)
        setEnableResize(enableResize:true)
        setEnableRotate(enableRotate:true)
        setShowContentShadow(enableContentShadow:false)
        
        hideEditingHandles()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    @objc func contentTapped(tapGesture:UITapGestureRecognizer){
        if ((_isShowingEditingHandles) != false){
            hideEditingHandles()
            superview?.bringSubview(toFront: self)
        } else {
            showEditingHandles()
        }
    }
    
    func setEnableClose(enableClose:Bool){
        _showCloseView = enableClose;
        _closeView.isHidden = !_showCloseView
        _closeView.isUserInteractionEnabled = _showCloseView
    }
    
    func setEnableResize(enableResize:Bool){
        _showResizeView = enableResize;
        _resizeView.isHidden = !_showResizeView
        _resizeView.isUserInteractionEnabled = _showResizeView
    }
    
    func setEnableRotate(enableRotate:Bool){
        _showRotateView = enableRotate;
        _rotateView.isHidden = !_showRotateView
        _rotateView.isUserInteractionEnabled = _showRotateView
    }
    
    func setShowContentShadow(enableContentShadow:Bool){
        _showContentShadow = enableContentShadow;
        
        if ((_showContentShadow) != false){
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 4.0
        } else {
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.0
            layer.shadowRadius = 0.0
        }
    }
    
    func hideEditingHandles(){
        lastTouchedView = nil;
        
        _isShowingEditingHandles = false;
        if(_showCloseView != false){
            _closeView.isHidden = true
        }
        if(_showResizeView != false){
            _resizeView.isHidden = true
        }
        if(_showRotateView != false){
            _rotateView.isHidden = true
        }
        
        refresh()
        
        _delegate?.stickerViewDidHideEditingHandles!(sticker: self)
        
    }
    
    func showEditingHandles(){
        if (lastTouchedView != nil){
            lastTouchedView.hideEditingHandles()
        }
        _isShowingEditingHandles = true;
        
        lastTouchedView = self;
        if(_showCloseView != false){
            _closeView.isHidden = false
        }
        if(_showResizeView != false){
            _resizeView.isHidden = false
        }
        if(_showRotateView != false){
            _rotateView.isHidden = false
        }
        refresh()
        
        _delegate?.stickerViewDidShowEditingHandles!(sticker: self)
    }
    
    func setContentView(contentView: UIView){
        if _contentView != nil {
            _contentView.removeFromSuperview()
        }
        _contentView = contentView
        
        //_contentView.frame = CGRect.insetBy(dx:_globalInset,dy:_globalInset)
        _contentView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        _contentView.backgroundColor = UIColor.clear
        _contentView.layer.borderColor = UIColor.gray.cgColor
        _contentView.layer.borderWidth = 1.0;
        insertSubview(_contentView, at: 0)
    }
    
    @objc func singleTapCalled(recognizer: UITapGestureRecognizer){
        removeFromSuperview()
        if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidClose)){
            _delegate?.stickerViewDidClose!(sticker: self)
        }
    }
    @objc func moveGestureCalled(recognizer: UIPanGestureRecognizer){
        _touchLocation = recognizer.location(in: superview)
        if(recognizer.state == UIGestureRecognizerState.began){
            
            _beginningPoint = _touchLocation
            _beginningCenter = center
            center = CGPoint(x:_beginningCenter.x + (_touchLocation.x - _beginningPoint.x), y:_beginningCenter.y + (_touchLocation.y - _beginningPoint.y))
            
            _beginBounds = self.bounds
            
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidBeginEditing)){
                _delegate?.stickerViewDidBeginEditing!(sticker: self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            center = CGPoint(x:_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), y:_beginningCenter.y+(_touchLocation.y-_beginningPoint.y))
            
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidChangeEditing)){
                _delegate?.stickerViewDidChangeEditing!(sticker: self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.ended){
            center = CGPoint(x:_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), y:_beginningCenter.y+(_touchLocation.y-_beginningPoint.y))
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidEndEditing)){
                _prevPoint = _touchLocation
            }
        }
        
        _prevPoint = _touchLocation;
    }
    
    @objc func resizeTranslate(recognizer: UIPanGestureRecognizer){
        _touchLocation = recognizer.location(in: superview)
        //Reforming touch location to it's Identity transform.
        _touchLocation = CGPointRorate(point: _touchLocation, basePoint: CGRectGetCenter(rect: frame),angle: -CGAffineTransformGetAngle(t: transform))
        if (recognizer.state == UIGestureRecognizerState.began){
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidBeginEditing)){
                _delegate?.stickerViewDidBeginEditing!(sticker: self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            var wChange: CGFloat = (_prevPoint.x - _touchLocation.x); //Slow down increment
            var hChange: CGFloat = (_touchLocation.y - _prevPoint.y); //Slow down increment
            var t: CGAffineTransform = transform
            transform = CGAffineTransform.identity
            var scaleRect:CGRect = CGRect(x:frame.origin.x, y:frame.origin.y, width:max(frame.size.width + (wChange*2), 1 + _globalInset*2), height:max(frame.size.height + (hChange*2), 1 + _globalInset*2))
            /*var scaleRect:CGRect
            if (frame.size.width >= frame.size.height){
            scaleRect = CGRectMake(frame.origin.x, frame.origin.y, max(frame.size.width + (hChange*2), 1 + _globalInset*2), max(frame.size.height + (hChange*2), 1 + _globalInset*2))
            } else {
            scaleRect = CGRectMake(frame.origin.x, frame.origin.y, max(frame.size.width + (wChange*2), 1 + _globalInset*2), max(frame.size.height + (wChange*2), 1 + _globalInset*2))
            }*/
            scaleRect = CGRectSetCenter(rect: scaleRect, center: center)
            frame = scaleRect
            transform = t
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidChangeEditing)) {
                _delegate?.stickerViewDidChangeEditing!(sticker: self)
            }
        }else if (recognizer.state == UIGestureRecognizerState.ended){
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidEndEditing)){
                _delegate?.stickerViewDidEndEditing!(sticker: self)
            }
        }
        _prevPoint = _touchLocation;
    }
    
    @objc func rotateViewPanGesture(recognizer: UIPanGestureRecognizer){
        _touchLocation =  recognizer.location(in: superview)
        
        var c: CGPoint = CGRectGetCenter(rect: frame);
        if (recognizer.state == UIGestureRecognizerState.began){
            _deltaAngle = atan2(_touchLocation.y - c.y, _touchLocation.x - c.x) - CGAffineTransformGetAngle(t: transform)
            
            _initialBounds = bounds;
            _initialDistance = CGPointGetDistance(point1: c, point2: _touchLocation);//stickerViewDidBeginEditing
            if recognizer.responds(to: #selector(LDStickerViewDelegate.stickerViewDidBeginEditing)){
                _delegate?.stickerViewDidBeginEditing!(sticker: self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.changed){
            var ang:CGFloat = atan2(_touchLocation.y - c.y, _touchLocation.x - c.x)
            var angleDiff:CGFloat = _deltaAngle - ang
            transform = CGAffineTransform(rotationAngle: -angleDiff)
            setNeedsDisplay()
            var scale: CGFloat = sqrt(CGPointGetDistance(point1: c, point2: _touchLocation) / _initialDistance)
            var scaleRect: CGRect = CGRectScale(rect: _initialBounds, wScale: scale, hScale: scale);
            if (scaleRect.size.width >= (1 + _globalInset*2) && scaleRect.size.height >= (1 + _globalInset*2)){
                bounds = scaleRect
            }
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidChangeEditing)) {
                _delegate?.stickerViewDidChangeEditing!(sticker: self)
            }
        } else if (recognizer.state == UIGestureRecognizerState.ended){
            if recognizer.responds(to:#selector(LDStickerViewDelegate.stickerViewDidEndEditing)){
                _delegate?.stickerViewDidEndEditing!(sticker: self)
            }
        }
    }
    
    
    private func CGRectGetCenter(rect:CGRect) -> CGPoint{
        
        return CGPoint(x:rect.midX, y:rect.midY)
    }
    private func CGPointRorate(point: CGPoint, basePoint: CGPoint, angle: CGFloat) -> CGPoint{
        let x: CGFloat = cos(angle) * (point.x-basePoint.x) - sin(angle) * (point.y-basePoint.y) + basePoint.x;
        let y: CGFloat = sin(angle) * (point.x-basePoint.x) + cos(angle) * (point.y-basePoint.y) + basePoint.y;
        
        return CGPoint(x:x,y:y);
    }
    
    private func CGRectSetCenter(rect: CGRect, center: CGPoint) -> CGRect{
        return CGRect(x:center.x-rect.width/2, y:center.y-rect.height/2, width:rect.width, height:rect.height);
    }
    
    private func CGRectScale(rect: CGRect, wScale: CGFloat, hScale: CGFloat) -> CGRect{
        return CGRect(x:rect.origin.x * wScale, y:rect.origin.y * hScale, width:rect.size.width * wScale, height:rect.size.height * hScale);
    }
    
    private func CGPointGetDistance(point1: CGPoint, point2: CGPoint) -> CGFloat{
        let fx: CGFloat = (point2.x - point1.x);
        let fy: CGFloat = (point2.y - point1.y);
        
        return sqrt((fx*fx + fy*fy));
    }
    
    private func CGAffineTransformGetAngle(t:CGAffineTransform) -> CGFloat{
        return atan2(t.b, t.a);
    }
    
    
    private func CGAffineTransformGetScale(t:CGAffineTransform) -> CGSize{
        return CGSize(width:sqrt(t.a * t.a + t.c * t.c), height:sqrt(t.b * t.b + t.d * t.d)) ;
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
