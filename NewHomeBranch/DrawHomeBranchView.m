//
//  DrawHomeBranchView.m
//  NewHomeBranch
//
//  Created by LQMacBookPro on 17/4/19.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "DrawHomeBranchView.h"
#import "PersonButton.h"
#import "GenerationModel.h"

@interface DrawHomeBranchView ()

@property (nonatomic, strong)NSMutableArray * totalEndPointArray;

@end

@implementation DrawHomeBranchView

- (NSMutableArray *)totalEndPointArray
{
    if (!_totalEndPointArray) {
        _totalEndPointArray = [NSMutableArray array];
    }
    return _totalEndPointArray;
}

- (void)setGeneraArray:(NSArray *)generaArray
{
    _generaArray = generaArray;
}

- (void)drawRect:(CGRect)rect
{
    [self soreBtn];
    
    NSLog(@"%@",self.totalEndPointArray);
    
    NSMutableArray * temTotalArray = [NSMutableArray array];
    //在这里画最后的线
    
    //遍历数组，将相同key的线添加到相同数组
    for (NSDictionary * dict in self.totalEndPointArray) {
        
        NSString * keyStr = dict.allKeys[0];
        
        NSMutableArray * temLastArray = [NSMutableArray array];
        
        for (NSDictionary * myDic in self.totalEndPointArray) {
            
            if ([myDic.allKeys[0] isEqualToString:keyStr]&&![temLastArray containsObject:myDic]) {
                [temLastArray addObject:myDic];
            }
            
        }
        
        [temTotalArray addObject:temLastArray];
        
    }
    
    NSLog(@"%@",temTotalArray);
    
    
    for (NSMutableArray * bigArray in temTotalArray) {
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        
        for (int i = 0; i< bigArray.count; i++) {
            
            //先取出数组里的字典
            NSDictionary * myDict = bigArray[i];
            
            NSString * pointValueStr = myDict.allValues[0];
            
            //取出其中的点
            CGPoint point = CGPointFromString(pointValueStr);
            
            if (bigArray.count == 1) {
                
                [path moveToPoint:point];
                
                [path addLineToPoint:point];
                
                [path stroke];
                
            }else{
                
                if (i == 0) {
                    [path moveToPoint:point];
                }else{
                    [path addLineToPoint:point];
                }
                
                [path stroke];
            }
            
        }
        
    }
    
    
}

- (void)soreBtn{
    
    CGFloat oneCollection = (kBtnWidth + kBtnBoard);
    
    //排布按钮布局
    
    //遍历数组，创建按钮
    
    //创建数组，存储与上级属血缘关系
    
    NSMutableArray * totalBtnArray = [NSMutableArray array];
    
    //创建个数组表示上一代的人数
    NSMutableArray * lastDaiArray = [NSMutableArray array];
    
    for (int i = 0; i< _generaArray.count; i++) {
        
        //遍历每一代
        NSArray * temDiyArr = _generaArray[i];
        
        NSMutableArray * temBtnArray = [NSMutableArray array];
        
        for (int j = 0; j<temDiyArr.count; j++) {
            
            CGFloat btnX = 0;
            
            PersonButton * btn = [[PersonButton alloc]init];
            
            if (lastDaiArray.count > temDiyArr.count) {
                //在这里判读btnX的坐标
                btnX = [self compareLastDai:lastDaiArray WithCurrent:temDiyArr[j] index:j];

            }else{
                btnX = (_totalPerCount - temDiyArr.count) * oneCollection * 0.5 + j * oneCollection + kBtnBoard;
            }
            
            CGFloat btnY = oneCollection * i + kBtnBoard;
            
            btn.frame = CGRectMake(btnX, btnY, 0, 0);
            
//            btn.backgroundColor = [UIColor redColor];
            
            btn.generaModel = temDiyArr[j];
            
            [self addSubview:btn];
            
            [temBtnArray addObject:btn];
        }
        
        lastDaiArray = temBtnArray;
        
        [totalBtnArray addObject:temBtnArray];
        
    }
    
        //开始画线
    
        //1.倒序遍历
    for (NSInteger i = totalBtnArray.count -1; i>=0; i--) {
        
        NSArray * daiArray = totalBtnArray[i];
        
        //创建直属血缘数组
        NSMutableArray * childArray = [NSMutableArray array];
        
        //遍历最后一代
        for (PersonButton * btn in daiArray) {
            
            //如果是子代,(有父母的id都有，可排除妻子，如果是兄弟姐妹则在上面先画条竖线)
            if (![btn.generaModel.fathor_id isEqualToString:@""] || ![btn.generaModel.mathor_id isEqualToString:@""]) {
                
                [childArray addObject:btn];
                
            }
            
            //画夫妻之间的线
            [self drawWifeLine:btn];
            
        }
        
        //遍历完数组之后开始画线，这条线是跟上级有血缘关系时向上的一段短线
        [self commonParent:childArray];
        
        
    }
    
}


/**
 如果上代人比当前代人数多，返回当前人应该在的x坐标
 */
- (CGFloat)compareLastDai:(NSArray *)lastArray WithCurrent:(GenerationModel *)currentGen index:(NSInteger)index{
    
    CGFloat btnX = 0;
    
    CGFloat oneCollection = kBtnBoard + kBtnWidth;
    
    //首先遍历上一代，确定当前人是属于上一代哪个人的子代
    for (PersonButton * lastBtn in lastArray) {
        
        NSArray * childArray = lastBtn.generaModel.child_id;
        
        if (childArray.count == 0) {
            continue;
        }
        
        //打印出childArray元素是NSNumber类型，所以要转一下
        NSMutableArray * childStrArray = [NSMutableArray array];
        
        
        for (NSString * str in childArray) {
            
            NSString * temStr = [NSString stringWithFormat:@"%@",str];
            
            [childStrArray addObject:temStr];
        }
        
        NSLog(@"%@",childStrArray);
        
        NSString * currentCid = currentGen.cid;
        
        //当前人是否是上一代某人的子代
        if ([childStrArray containsObject:currentCid]) {
            
            //是该子代的父类，但是否为单亲
            //如果是单身
            if ([lastBtn.generaModel.couple_id isEqualToString:@""]) {
                
                //判断有几个孩子
                if (childArray.count > 1) {
                    
                    btnX = lastBtn.centerX - (oneCollection) * 0.5 + oneCollection * index + kBtnBoard *0.5;
                    
                }else{
                    btnX = [lastBtn leftPoint:lastBtn].x;
                }
                
            }else{
                //非单身
                if (![lastBtn.generaModel.gender isEqualToString:@"M"]) {
                    continue;
                }else{
                    
                    //判断有几个孩子
                    if (childArray.count > 1) {
                        
                        btnX = lastBtn.centerX - (oneCollection) * 0.5 + oneCollection * index + kBtnBoard *0.5;
                        
                    }else{
                        btnX = [lastBtn leftPoint:lastBtn].x + oneCollection * 0.5;
                    }
                    
                }
            }
            
        }
        
    }
    
    return btnX;
    
}


/**
 画夫妻之间的线
 */
- (void)drawWifeLine:(PersonButton *)btn
{
        //有妻子时画线
    if (![btn.generaModel.couple_id isEqualToString:@""]&&[btn.generaModel.gender isEqualToString:@"M"]) {
        
        //往右边画线，因为男左女右后台是分布好的
        CGPoint rightPoint = [btn rightPoint:btn];
        
        CGPoint endPoint = CGPointMake(rightPoint.x + kBtnBoard, rightPoint.y);
        
        UIBezierPath * wifePath = [UIBezierPath bezierPath];
        
        [wifePath moveToPoint:rightPoint];
        
        [wifePath addLineToPoint:endPoint];
        
        [wifePath stroke];
        
        //如果有子代，再接着画连接子代的线
        if (btn.generaModel.child_id.count > 0) {
            
            NSString * rightPstr = NSStringFromCGPoint(rightPoint);
            
            NSString * endPstr = NSStringFromCGPoint(endPoint);
            
            CGPoint childCenPoint = [self getHorizonCenterPoint:@[rightPstr,endPstr]];
            
            CGPoint childEndPoint = CGPointMake(childCenPoint.x, childCenPoint.y + kBtnWidth * 0.5 + 10);
            
            UIBezierPath * childPath = [UIBezierPath bezierPath];
            
            [childPath moveToPoint:childCenPoint];
            
            [childPath addLineToPoint:childEndPoint];
            
            [childPath stroke];
            
            NSMutableDictionary * childDict = [NSMutableDictionary dictionary];
            
            NSString * parentStr = @"";
            
            //由于方法设计的是优先用母亲id做点的key，所以在这里也要优先用妻子的id做点的key保持同步
            if (![btn.generaModel.couple_id isEqualToString:@""]) {
                parentStr = btn.generaModel.couple_id;
            }else{
                parentStr = btn.generaModel.cid;
            }
            
            [childDict setObject:[self pointToStr:childEndPoint] forKey:parentStr];
            
            [self.totalEndPointArray addObject:childDict];
            
            NSLog(@"%@",btn.generaModel.cid);
            
        }
    }else if (btn.generaModel.child_id.count > 0 && [btn.generaModel.couple_id isEqualToString:@""]){
        
            //是单身，但有孩子
            CGPoint childBottPoint = [btn bottomPoint:btn];
        
            //向下画10
            CGPoint childEndBoPoint = CGPointMake(childBottPoint.x, childBottPoint.y + 10);
        
            UIBezierPath * childBooPath = [UIBezierPath bezierPath];
        
            [childBooPath moveToPoint:childBottPoint];
        
            [childBooPath addLineToPoint:childEndBoPoint];

            [childBooPath stroke];
        
            NSMutableDictionary * childDict = [NSMutableDictionary dictionary];
        
            NSString * parentStr = @"";
            //由于方法设计的是优先用母亲id做点的key，所以在这里也要优先用妻子的id做点的key保持同步
            if (![btn.generaModel.couple_id isEqualToString:@""]) {
                parentStr = btn.generaModel.couple_id;
            }else{
                parentStr = btn.generaModel.cid;
            }
        
            [childDict setObject:[self pointToStr:childEndBoPoint] forKey:parentStr];
        
            NSLog(@"%@",btn.generaModel.cid);
        
            [self.totalEndPointArray addObject:childDict];
    }
    
    
}


/**
 在兄弟姐妹之间画线
 */
- (void)commonParent:(NSArray * )childArray
{
    
    //创建同父母的子女的数组
    NSMutableArray * brotherArray = [NSMutableArray array];
    
    //判断fatherId和motherid
    for (PersonButton * btn in childArray) {
        
        NSString * motherId = btn.generaModel.mathor_id;
        
        NSString * fatherId = btn.generaModel.fathor_id;
        
        NSMutableArray * temBorthArray = [NSMutableArray array];
        
        for (PersonButton * temBtn in childArray) {
            
            if ([temBtn.generaModel.mathor_id isEqualToString:motherId]&&[temBtn.generaModel.fathor_id isEqualToString:fatherId]) {
                [temBorthArray addObject:temBtn];
            }
            
        }
        
        if (![brotherArray containsObject:temBorthArray]) {
            [brotherArray addObject:temBorthArray];
        }
        
    }
    //这里存的是同父母的数组
    NSLog(@"%@",brotherArray);
    
    //创建一个只存储同父母兄妹之间向上线段的顶点坐标的数组
    NSMutableArray * bortherEndPointArray = [NSMutableArray array];
    
    for (NSArray * temBroArray in brotherArray) {
        
        NSMutableArray * secEndPointArray = [NSMutableArray array];
        
        NSString * parentsId = @"";
        
        //遍历temBroArray数组，画一条向上的短线
        for (PersonButton * btn in temBroArray) {
            
                //画直属血缘关系的向上的竖线
                UIBezierPath * bsPath = [UIBezierPath bezierPath];
        
                CGPoint startPoint = [btn topPoint:btn];
        
                //向上画10
                CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y - 10);
        
                [bsPath moveToPoint:startPoint];
                
                [bsPath addLineToPoint:endPoint];
                
                [bsPath stroke];
            
                //这里是给的标识
                parentsId = [self setMatherOrFatherIdForKey:btn];
            
                if (![secEndPointArray containsObject:parentsId]) {
                    [secEndPointArray addObject:parentsId];
                }
            
                [secEndPointArray insertObject:[self pointToStr:endPoint] atIndex:0];
        }
        
            [bortherEndPointArray addObject:secEndPointArray];
        
    }

    
    NSLog(@"%@",bortherEndPointArray);
    
    
    NSString * parentsId = @"";
    
    //连接同父母的兄妹之间的点
    for (NSMutableArray * endPointArray in bortherEndPointArray) {
        
            UIBezierPath * bsrPath = [UIBezierPath bezierPath];
        
            parentsId = [endPointArray lastObject];
        
            [endPointArray removeLastObject];
        
        for (int i = 0; i< endPointArray.count; i++) {
            
            CGPoint endP = CGPointFromString(endPointArray[i]);
            
            if (i == 0) {
                [bsrPath moveToPoint:endP];
            }else{
                [bsrPath addLineToPoint:endP];
            }
            
            [bsrPath stroke];
            
        }
        
        //画兄妹之间中间点再向上画一段
        CGPoint lineCenP = [self getHorizonCenterPoint:endPointArray];
        
        //创建向上的线段的终点，再向上画5
        CGPoint linUpP = CGPointMake(lineCenP.x, lineCenP.y -10);
        
        UIBezierPath * linCenterUpP = [UIBezierPath bezierPath];
        
        [linCenterUpP moveToPoint:lineCenP];
        
        [linCenterUpP addLineToPoint:linUpP];
        

        [linCenterUpP stroke];
        
        NSMutableDictionary * childDict = [NSMutableDictionary dictionary];
        
        [childDict setObject:[self pointToStr:linUpP] forKey:parentsId];
        
        [self.totalEndPointArray addObject:childDict];
        
        NSLog(@"%@",parentsId);
        
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


/**
 生成设置要记录点对应的keyStr
 */
- (NSString * )setMatherOrFatherIdForKey:(PersonButton *)btn
{
    NSString * keyStr = @"";
    
    if (![btn.generaModel.mathor_id isEqualToString:@""]) {
        keyStr = btn.generaModel.mathor_id;
    }else{
        keyStr = btn.generaModel.fathor_id;
    }
    
    return keyStr;
}


/**
 返回点的字符串
 */
- (NSString *)pointToStr:(CGPoint)point
{
    NSString * pointStr = NSStringFromCGPoint(point);
    
    return pointStr;
}


@end
