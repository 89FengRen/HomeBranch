//
//  InsuraHomeBranchView.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/19.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "InsuraHomeBranchView.h"
#import "PersonButton.h"
#import "GenerationModel.h"
#import "DrawHomeBranchView.h"

@interface InsuraHomeBranchView ()

@property (nonatomic,weak)DrawHomeBranchView * myDrawView;

@end

@implementation InsuraHomeBranchView



- (void)setGeneraArray:(NSArray *)generaArray
{
    _generaArray = generaArray;
    
    //计算总人数，从而计算scrollView的contentSize
    NSInteger totolPeopleCount = 0;
    
    for (NSArray * array in _generaArray) {
        
        totolPeopleCount += array.count;
    }
    
    CGFloat scrollContWidth = totolPeopleCount * (kBtnBoard + kBtnWidth);
    
    CGFloat branchCenterX = 0;
    
    if (scrollContWidth - kScreenWidth) {
        
        self.contentSize = CGSizeMake(scrollContWidth, 0);
        
        self.scrollEnabled = YES;
        
        //确定中心的坐标offset的值
        
        branchCenterX = (totolPeopleCount) * (kBtnBoard + kBtnWidth) * 0.5;
        
        self.contentOffset = CGPointMake(branchCenterX - kScreenWidth * 0.5 + kBtnWidth *0.5 - kBtnBoard * 0.5, 0);
        
        self.myDrawView.frame = CGRectMake(0, 0, scrollContWidth, self.bounds.size.height);
        
        
    }else{
        
        self.myDrawView.frame = self.frame;
    }
    
    self.myDrawView.generaArray = _generaArray;
    
    self.myDrawView.totalPerCount = totolPeopleCount;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        DrawHomeBranchView * drawView = [[DrawHomeBranchView alloc]init];
        
        [self addSubview:drawView];
        
        self.myDrawView = drawView;
        
        self.myDrawView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}






@end
