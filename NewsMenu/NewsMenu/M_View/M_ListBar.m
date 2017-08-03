//
//  M_ListBar.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "M_ListBar.h"

#define KDistanceBetweenItem    32
#define KExtraPadding           20
#define ItemFont                13

@interface M_ListBar ()

/** item的最大宽度 */
@property (nonatomic,assign) CGFloat maxWidth;
/** item的背景 */
@property (nonatomic,strong) UIView *btnBackView;
/** 被选中的Item */
@property (nonatomic,strong) UIButton *btnSelect;
/** item数组 */
@property (nonatomic,strong) NSMutableArray *btnLists;

@end

@implementation M_ListBar

-(NSMutableArray *)btnLists{
    if (!_btnLists) {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}

-(void)setVisibleItemList:(NSMutableArray *)visibleItemList{
    _visibleItemList = visibleItemList;
    
    if (!self.btnBackView) {
        self.btnBackView = [[UIView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 20)/2, 46, 20)];
        self.btnBackView.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:51.0/255.0 blue:54.0/255.0 alpha:1];
        self.btnBackView.layer.cornerRadius = 5;
        [self addSubview:self.btnBackView];
        
        self.maxWidth = 20;
        self.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < visibleItemList.count;  i ++) {
            [self makeItemWithTitle:visibleItemList[i]];
        }
        self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }
}

-(void)makeItemWithTitle:(NSString*)title{
    CGFloat itemW = [self calculateSizeWithFont:ItemFont Text:title].size.width;
    UIButton* item = [[UIButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
    item.titleLabel.font = [UIFont systemFontOfSize:ItemFont];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateHighlighted];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.maxWidth += itemW + KDistanceBetweenItem;
    [self.btnLists addObject:item];
    [self addSubview:item];
    
    if (!self.btnSelect) {
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnSelect = item;
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

-(void)itemClick:(UIButton*)sender{
    if (self.btnSelect != sender) {
        [self.btnSelect setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnSelect = sender;
        if (self.listBarItemClickBlock) {
            self.listBarItemClickBlock(sender.titleLabel.text,[self findIndexOfListWithTitle:sender.titleLabel.text]);
        }
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect btnBackViewRect = self.btnBackView.frame;
        btnBackViewRect.size.width = sender.frame.size.width + KExtraPadding;
        self.btnBackView.frame = btnBackViewRect;
        CGFloat changW = sender.frame.origin.x - (btnBackViewRect.size.width - sender.frame.size.width)/2 - 10;
        self.btnBackView.transform = CGAffineTransformMakeTranslation(changW, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;
            if (sender.frame.origin.x >= [UIScreen mainScreen].bounds.size.width - 150 &&
                sender.frame.origin.x < self.contentSize.width - 200) {
                changePoint = CGPointMake(sender.frame.origin.x - 200, 0);
            } else if (sender.frame.origin.x >= self.contentSize.width - 200) {
                changePoint = CGPointMake(self.contentSize.width - 350, 0);
            } else {
                changePoint = CGPointMake(0, 0);
            }
            self.contentOffset = changePoint;
        }];
    }];
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index{
    UIButton* item = (UIButton*)self.btnLists[index];
    [self itemClick:item];
}

-(void)operationFromBlock:(animateType)type itemName:(NSString *)itemName index:(int)index{
    switch (type) {
        case topViewClick:
            [self itemClick:self.btnLists[[self findIndexOfListWithTitle:itemName]]];
            if (self.arrowChange) {
                self.arrowChange();
            }
            break;
        case FromTopToTop:
            [self switchPositionWithItemName:itemName index:index];
            break;
        case FromTopToTopLast:
            [self switchPositionWithItemName:itemName index:self.visibleItemList.count - 1];
            break;
        case FromTopToBottomHead:
            if ([self.btnSelect.titleLabel.text isEqualToString:itemName]) {
                [self itemClick:self.btnLists[0]];
            }
            [self removeItemWithTitle:itemName];
            [self resetFrame];
            break;
        case FromBottomToTopLast:
            [self.visibleItemList addObject:itemName];
            [self makeItemWithTitle:itemName];
            break;
        default:
            break;
    }
}

-(void)switchPositionWithItemName:(NSString*)itemName index:(NSInteger)index{
    UIButton* button = self.btnLists[[self findIndexOfListWithTitle:itemName]];
    [self.visibleItemList removeObject:itemName];
    [self.btnLists removeObject:button];
    [self.visibleItemList insertObject:itemName atIndex:index];
    [self.btnLists insertObject:button atIndex:index];
    [self itemClick:self.btnSelect];
    [self resetFrame];
}

-(void)removeItemWithTitle:(NSString*)title{
    NSInteger index = [self findIndexOfListWithTitle:title];
    UIButton* select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:title];
}

-(void)resetFrame{
    self.maxWidth = 20;
    for (int i = 0; i < self.visibleItemList.count; i ++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat itemW = [self calculateSizeWithFont:ItemFont Text:self.visibleItemList[i]].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += KDistanceBetweenItem + itemW;
        } completion:^(BOOL finished) {
            
        }];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

//找到被点击item的下标
-(int)findIndexOfListWithTitle:(NSString*)title{
    for (int i = 0; i < _visibleItemList.count; i ++) {
        if ([title isEqualToString:_visibleItemList[i]]) {
            return i;
            break;
        }
    }
    return 0;
}

//计算title的宽度
-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}

@end
