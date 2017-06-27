//
//  PersonButton.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/14.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "PersonButton.h"
#import "GenerationModel.h"

@implementation PersonButton

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat btnW = (kScreenWidth - (5 * kBtnBoard))/4;
    
    CGFloat btnH = btnW;
    
    CGFloat btnX = frame.origin.x;
    
    CGFloat btnY = frame.origin.y;
    
    CGRect temFram = CGRectMake(btnX, btnY, btnW, btnH);
    
    self.backgroundColor = [UIColor redColor];
    
    if (self = [super initWithFrame:temFram]) {
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = rect.size.width * 0.5;
    
    self.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    CGRect temF = frame;
    
    temF.size.width = kBtnWidth;
    
    temF.size.height = kBtnWidth;
    
    frame = temF;
    
    [super setFrame:frame];
    
}

- (void)setGeneraModel:(GenerationModel *)generaModel
{
    _generaModel = generaModel;
    
    [self setTitle:_generaModel.cust_name forState:UIControlStateNormal];
    
    if ([_generaModel.gender isEqualToString:@"M"]) {
        self.backgroundColor = [UIColor blueColor];
    }else{
        self.backgroundColor = [UIColor redColor];
    }
}


@end
