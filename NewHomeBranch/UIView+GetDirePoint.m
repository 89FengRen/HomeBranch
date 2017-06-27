//
//  UIView+GetDirePoint.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/17.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "UIView+GetDirePoint.h"

@implementation UIView (GetDirePoint)

- (CGPoint)topPoint:(UIView * )view
{
    CGFloat minY = CGRectGetMinY(view.frame);
    
    CGFloat centerX = view.centerX;
    
    return CGPointMake(centerX, minY);
}




- (CGPoint)leftPoint:(UIView *)view
{
    CGFloat minX = CGRectGetMinX(view.frame);
    
    CGFloat centerY = view.centerY;
    
    return CGPointMake(minX, centerY);
}


- (CGPoint)rightPoint:(UIView *)view
{
    CGFloat maxX = CGRectGetMaxX(view.frame);
    
    CGFloat centerY = view.centerY;
    
    return CGPointMake(maxX, centerY);
}

- (CGPoint)bottomPoint:(UIView *)view
{
    CGFloat maxY = CGRectGetMaxY(view.frame);
    
    CGFloat centerX = view.centerX;
    
    return CGPointMake(centerX, maxY);
}

- (CGFloat)x
{
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

- (CGFloat)y
{
    
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}

- (CGFloat)width
{
    
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint point = self.center;
    
    point.x = centerX;
    
    self.center = point;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint point = self.center;
    
    point.y = centerY;
    
    self.center = point;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}


@end
