//
//  M_ListBar.h
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 未展开时的滚动菜单
 */

@interface M_ListBar : UIScrollView

/** 倒三角被点击 */
@property (nonatomic,copy) void(^arrowChange)();
/** 滚动菜单Item被点击 */
@property (nonatomic,copy) void(^listBarItemClickBlock)(NSString* itemName,NSInteger itemIndex);
/** 滚动菜单的数组 */
@property (nonatomic,strong) NSMutableArray *visibleItemList;

-(void)operationFromBlock:(animateType)type itemName:(NSString*)itemName index:(int)index;

-(void)itemClickByScrollerWithIndex:(NSInteger)index;

@end
