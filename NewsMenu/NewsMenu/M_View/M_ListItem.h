//
//  M_ListItem.h
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    top = 0,
    bottom = 1
}itemLocation;

@interface M_ListItem : UIButton
{
    @public
    NSMutableArray* locationView;
    NSMutableArray* topView;
    NSMutableArray* bottomView;
}

/**<#object#>*/
@property (nonatomic,strong) UIView *hitTextLabel;
/**<#object#>*/
@property (nonatomic,strong) UIButton *deleteBtn;
/**<#object#>*/
@property (nonatomic,strong) UIButton *hiddenBtn;
/**<#object#>*/
@property (nonatomic,assign) itemLocation location;
/**<#object#>*/
@property (nonatomic,copy) NSString *itemName;

/**<#object#>*/
@property (nonatomic,copy) void(^longPressBlock)();
/**<#object#>*/
@property (nonatomic,copy) void(^operationBlock)(animateType type,NSString* itemName,int index);

/**<#object#>*/
@property (nonatomic,strong) UIPanGestureRecognizer *gesture;
/**<#object#>*/
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;

@end
