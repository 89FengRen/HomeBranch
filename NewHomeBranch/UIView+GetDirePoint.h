//
//  UIView+GetDirePoint.h
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/17.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetDirePoint)

- (CGPoint)bottomPoint:(UIView *)view;

- (CGPoint)rightPoint:(UIView *)view;

- (CGPoint)leftPoint:(UIView *)view;

- (CGPoint)topPoint:(UIView * )view;


@property (nonatomic, assign)CGFloat x;

@property (nonatomic, assign)CGFloat y;

@property (nonatomic, assign)CGFloat width;

/**
 在分类中声明@property，只会生成getter方法和setter方法的声明，并不会生成方法的实现和带有_线的成员变量
 只相当于写了setter方法和getter方法的声明
 */
@property (nonatomic, assign)CGFloat height;

@property (nonatomic, assign)CGFloat centerX;

@property (nonatomic, assign)CGFloat centerY;

@property (nonatomic, assign)CGSize size;

@end
