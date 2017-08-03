//
//  M_DeleteBar.h
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M_DeleteBar : UIView

/**<#object#>*/
@property (nonatomic,strong) UILabel *hitText;
/** 排序按钮 */
@property (nonatomic,strong) UIButton *sortBtn;

-(void)sortBtnClick:(UIButton*)sender;

@end
