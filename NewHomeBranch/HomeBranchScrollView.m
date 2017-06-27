//
//  HomeBranchScrollView.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/19.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "HomeBranchScrollView.h"
#import "PersonButton.h"
#import "GenerationModel.h"
#import "UIView+GetDirePoint.h"

@interface HomeBranchScrollView()

@property (nonatomic, strong)NSMutableArray * finishArray;

@end

@implementation HomeBranchScrollView

- (NSMutableArray *)finishArray
{
    if (!_finishArray) {
        _finishArray = [NSMutableArray array];
    }
    return _finishArray;
}

- (void)drawRect:(CGRect)rect {
    
    [self soreBtn];
    
}


- (void)setGeneraArray:(NSArray *)generaArray
{
    _generaArray = generaArray;
}


- (void)soreBtn{
    
    //创建按钮时排布，先要把按钮添加到数组中，之后再逐个取出按钮，再画线
    NSMutableArray * totalBtnArray = [NSMutableArray array];
    
    //首先创建按钮,把按钮排布出来
    
    for (int j = 0; j<_generaArray.count; j++) {
        
        //取出第一代
        NSArray * temArry = _generaArray[j];
        
        //创建每一代对应的按钮数组
        NSMutableArray * temBtnArray = [NSMutableArray array];
        
        for (int i = 0; i<temArry.count; i++) {
            
            //给每个按钮设置对象
            PersonButton * btn =[[PersonButton alloc]init];
            
            //给按钮设置对应的对象
            btn.generaModel = temArry[i];
            
            
            CGFloat btnX = (kBtnWidth + kBtnBoard) * ([btn.generaModel.y integerValue] -1) + kBtnBoard;
            
            CGFloat btnY = (kBtnBoard + kBtnWidth) * j + kBtnBoard;
            
            
            btn.frame = CGRectMake(btnX, btnY, 0, 0);
            
            btn.backgroundColor = [UIColor redColor];
            
            //在这里判断scrollView的内容要不要扩展
            CGFloat btnMaxX = CGRectGetMaxX(btn.frame);
            
            if (btnMaxX - kScreenWidth) {
                self.contentSize = CGSizeMake(btnMaxX + kBtnBoard, 0);
                
                self.scrollEnabled = YES;
            }
            
            [self addSubview:btn];
            
            
            
            [temBtnArray addObject:btn];
            
        }
        
        //添加到按钮的总数组中
        [totalBtnArray addObject:temBtnArray];
        
    }
    
    //倒序取出数组中的按钮，再进行画线
    
    for (NSInteger i = (_generation_count -1); i>= 0; i--) {
        
        //取出最后一代的按钮
        NSArray * temArray = totalBtnArray[i];
        
        //遍历是否是上一代的子代，如果是画线，如果不是，不画线
        
        NSMutableArray * temCapArray = [NSMutableArray array];
        
        //创建一个数组里面全放的是跟上级有血缘关系的子代
        NSMutableArray * chilidArray = [NSMutableArray array];
        
        for (PersonButton * btn in temArray) {
            
            //条件一：兄妹的连起来，还要判断是否相同父母
            //如果是子代,(有父母的id都有，可排除妻子，如果是兄弟姐妹则在上面先画条竖线)
            if (![btn.generaModel.fathor_id isEqualToString:@""] || ![btn.generaModel.mathor_id isEqualToString:@""]) {
                
                [chilidArray addObject:btn];
                
            }
            
            
            //这里是在链接夫妻之间的线,这根线是必然的，必然是两口
            //设置男性的cid为key，以坐标值为value，设置到字典中
            NSString * matherId = @"";
            if (temCapArray.count < 2) {
                [temCapArray addObject:btn];
                
                if (temCapArray.count ==2) {
                    
                    UIBezierPath * caplePath = [UIBezierPath bezierPath];
                    
                    PersonButton * btn1 = temCapArray[0];
                    
                    NSString * coup1PointStr = NSStringFromCGPoint([btn1 rightPoint:btn1]);
                    
                    [caplePath moveToPoint:[btn1 rightPoint:btn1]];
                    
                    PersonButton * btn2 = temCapArray[1];
                    
                    if ([btn2.generaModel.gender isEqualToString:@"F"]) {
                        matherId = btn2.generaModel.cid;
                    }else{
                        matherId = btn1.generaModel.cid;
                    }
                    
                    [caplePath addLineToPoint:[btn2 leftPoint:btn2]];
                    
                    NSString * coup2PointStr = NSStringFromCGPoint([btn2 leftPoint:btn2]);
                    
                    [caplePath stroke];
                    
                    //判断是否有子女
                    if (btn1.generaModel.child_id.count > 0) {
                        //画往下伸展的线
                        CGPoint tmeCp = [self getHorizonCenterPoint:@[coup1PointStr,coup2PointStr]];
                        UIBezierPath * coupDownPath = [UIBezierPath bezierPath];
                        
                        [coupDownPath moveToPoint:tmeCp];
                        
                        CGPoint cuopDownEndP = CGPointMake(tmeCp.x, tmeCp.y + kBtnWidth * 0.5 + 5);
                        
                        [coupDownPath addLineToPoint:cuopDownEndP];
                        
                        [coupDownPath stroke];
                        
                        NSString * coupDownPathStr = NSStringFromCGPoint(cuopDownEndP);
                        
                        NSMutableDictionary * finishPointDict = [NSMutableDictionary dictionary];
                        
                        [finishPointDict setObject:coupDownPathStr forKey:matherId];
                        
                        [self.finishArray addObject:finishPointDict];
                    }
                    
                    [temCapArray removeAllObjects];
                    
                }
                
            }
            
        }
        
        //是否同父母
        [self commonParent:chilidArray];
        
    }
    
    //开始连接最后的线
    [self.finishArray sortUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary *  obj2) {
        
        if ([obj1.allKeys[0] isEqualToString:obj2.allKeys[0]]) {
            //如果两个字典的key是一样的，那么开始画线
            UIBezierPath * finalPath = [UIBezierPath bezierPath];
            
            NSString * startPStr = obj1.allValues[0];
            
            CGPoint startP = CGPointFromString(startPStr);
            
            NSString * endPStr = obj2.allValues[0];
            
            CGPoint endP = CGPointFromString(endPStr);
            
            [finalPath moveToPoint:startP];
            
            [finalPath addLineToPoint:endP];
            
            [finalPath stroke];
            
        }
        return [obj1.allKeys[0] compare:obj2.allKeys[0]];
        
    }];
    
}


/**
 是否是夫妻
 */
- (BOOL)isCouple:(NSArray *)btnArray
{
    PersonButton * btn1 = btnArray[0];
    
    GenerationModel * couple1 = btn1.generaModel;
    
    PersonButton * btn2 = btnArray[1];
    
    GenerationModel * couple2 = btn2.generaModel;
    
    return [couple1.couple_id isEqualToString:couple2.cid] ? NO : YES;
    
}


/**
 在兄弟姐妹之间画线
 */
- (void)commonParent:(NSArray * )childArray
{
    
    NSMutableArray * bigArray = [NSMutableArray array];
    
    //判断是否同父母
    for (PersonButton * btn in childArray) {
        
        NSString * parentsId = btn.generaModel.fathor_id;
        
        NSMutableArray * temArray = [NSMutableArray array];
        
        for (PersonButton * tem in childArray) {
            if ([tem.generaModel.fathor_id isEqualToString:parentsId]) {
                [temArray addObject:tem];
            }
        }
        
        if (![bigArray containsObject:temArray]) {
            [bigArray addObject:temArray];
        }
        
        
    }
    
    NSLog(@"%@",bigArray);
    
    NSString * matherId = @"";
    //遍历大数组
    for (int i = 0; i< bigArray.count; i++) {
        
        //取出单个数组
        NSArray * array1 = bigArray[i];
        
        //创建多个兄弟之间竖直方向上线的顶点坐标
        NSMutableArray * endPointArray = [NSMutableArray array];
        
        for (PersonButton * pBtn in array1) {
            //在这里开始画竖线
            matherId = pBtn.generaModel.mathor_id;
            //以下这几行是给子代的上一代有父母的画向上的竖线
            UIBezierPath * path = [UIBezierPath bezierPath];
            CGPoint beginPoint = [pBtn topPoint:pBtn];
            
            [path moveToPoint:beginPoint];
            
            CGPoint endPoint = CGPointMake(pBtn.centerX, pBtn.centerY - kBtnWidth * 0.5 - 10);
            
            [path addLineToPoint: endPoint];
            
            [endPointArray addObject:NSStringFromCGPoint(endPoint)];
            
            [path stroke];
            
            
        }
        
        //链接兄弟姐妹之间顶点之间的线
        //把各个有竖线的点连接起来
        UIBezierPath * temPath = [UIBezierPath bezierPath];
        
        for (int i = 0; i < endPointArray.count; i ++) {
            
            //连线
            CGPoint temPoint = CGPointFromString(endPointArray[i]);
            
            if (i < endPointArray.count -1) {
                [temPath moveToPoint:temPoint];
            }else{
                [temPath addLineToPoint:temPoint];
            }
            
        }
        [temPath stroke];
        
        //在这里开始画节点之上的线
        UIBezierPath * upPath = [UIBezierPath bezierPath];
        
        CGPoint centerPoint = [self getHorizonCenterPoint:endPointArray];
        
        [upPath moveToPoint:centerPoint];
        
        CGPoint upPoint = CGPointMake(centerPoint.x, centerPoint.y -15);
        
        [upPath addLineToPoint:upPoint];
        
        [upPath stroke];
        
        NSString * upPointStr = NSStringFromCGPoint(upPoint);
        
        NSMutableDictionary * finishPointDict = [NSMutableDictionary dictionary];
        
        //以fatherId为key，以坐标值为value，添加到数组中，最后连线
        [finishPointDict setObject:upPointStr forKey:matherId];
        
        //添加到数组中
        [self.finishArray addObject:finishPointDict];
    }
    
    
    
}


/**
 获取同一直线上的点之间的中心点
 */
- (CGPoint)getHorizonCenterPoint:(NSArray *)pointArray
{
    NSArray * array = [pointArray sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        
        return [obj1 compare:obj2];
        
    }].mutableCopy;
    
    NSLog(@"%@",array);
    
    CGPoint firstPoint = CGPointFromString(pointArray[0]);
    
    CGPoint lastPoint = CGPointFromString(pointArray.lastObject);
    
    CGFloat centerX = (lastPoint.x - firstPoint.x)*0.5 + firstPoint.x;
    
    CGPoint centerPoint = CGPointMake(centerX, firstPoint.y);
    
    return centerPoint;
    
}

@end
