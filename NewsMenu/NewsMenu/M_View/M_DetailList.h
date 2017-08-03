//
//  M_DetailList.h
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M_DetailList : UIScrollView

/**<#object#>*/
@property (nonatomic,strong) NSMutableArray *topView;
/**<#object#>*/
@property (nonatomic,strong) NSMutableArray *bottomView;
/**<#object#>*/
@property (nonatomic,strong) NSMutableArray *listAll;

/**<#object#>*/
@property (nonatomic,copy) void(^longPressedBlock)();
/**<#object#>*/
@property (nonatomic,copy) void(^operationFromItemBlock)(animateType type,NSString* itemName,int index);

-(void)itemResponseFromListBarClickWithItemName:(NSString*)itemName;

@end
