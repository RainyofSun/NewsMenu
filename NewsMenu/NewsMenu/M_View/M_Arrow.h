//
//  M_Arrow.h
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 倒三角下拉菜单
 */
@interface M_Arrow : UIButton

@property (nonatomic,copy) void(^arrowBtnClick)();

@end
