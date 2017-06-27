//
//  GenerationModel.h
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/14.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenerationModel : NSObject

/** 年龄 **/
@property (nonatomic,copy)NSString * age;

@property (nonatomic, strong)NSArray * child_id;

/** id **/
@property (nonatomic,copy)NSString * cid;


/** 配偶id **/
@property (nonatomic,copy)NSString * couple_id;

/** 名字 **/
@property (nonatomic,copy)NSString * cust_name;


/** 父亲id **/
@property (nonatomic,copy)NSString * fathor_id;

/** 母亲id **/
@property (nonatomic,copy)NSString * mathor_id;


/** 性别 **/
@property (nonatomic,copy)NSString * gender;

/** x坐标 **/
@property (nonatomic,copy)NSString * x;

/** y坐标 **/
@property (nonatomic,copy)NSString * y;

@end
