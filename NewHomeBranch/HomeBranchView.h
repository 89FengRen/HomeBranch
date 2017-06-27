//
//  HomeBranchView.h
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/14.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBranchView : UIView


/**
 代的数组
 */
@property (nonatomic, strong)NSArray * generaArray;


/**
 一共有几代
 */
@property (nonatomic, assign)NSInteger generation_count;

/** 最大代的成员个数 **/
@property (nonatomic,assign)NSInteger max_member_count;

@end
