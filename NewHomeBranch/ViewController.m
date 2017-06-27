//
//  ViewController.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/14.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "ViewController.h"
#import "PersonButton.h"

#import "GenerationModel.h"

//#import "HomeBranchView.h"

#import "HomeBranchScrollView.h"

#import "InsuraHomeBranchView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"MyData.plist" ofType:nil];
    
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
//    NSString * str = [dict mj_JSONString];
    
    //获取最大代的个数
    NSInteger generation_count = [dict[@"data"][@"generation_count"] integerValue];
    
    //遍历dict[@"data"]字典，创建添加到数组中
    
    NSDictionary * generaDict = dict[@"data"];
    
    //创建数组存代
    NSMutableArray * totalGeneraArray = [NSMutableArray array];
    
    for (int i = 0; i < generation_count; i++) {
        
        
        NSString * generaStr = [NSString stringWithFormat:@"generation%d",i+1];
        
        //获取代的数组
        NSArray * temArray1 = generaDict[generaStr];
        
        NSArray * temArray = [GenerationModel mj_objectArrayWithKeyValuesArray:temArray1];
        
        [totalGeneraArray addObject:temArray];
        
    }
    
//    //获取到三代
//    HomeBranchScrollView * homeBranch = [[HomeBranchScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
//    
//    homeBranch.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:homeBranch];
//    
//    //代数
//    homeBranch.generation_count = generation_count;
//    
//    //最大代的成员个数
//    homeBranch.max_member_count = [dict[@"data"][@"max_member_count"] integerValue];
//    
//    homeBranch.generaArray = totalGeneraArray;
    
    InsuraHomeBranchView * insuraHomeView = [[InsuraHomeBranchView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
    
    insuraHomeView.backgroundColor = [UIColor whiteColor];
    
    insuraHomeView.generation_count = generation_count;
    
    insuraHomeView.max_member_count = [dict[@"data"][@"max_member_count"] integerValue];
    
    insuraHomeView.generaArray = totalGeneraArray;
    
    [self.view addSubview:insuraHomeView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
