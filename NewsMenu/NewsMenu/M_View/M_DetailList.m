//
//  M_DetailList.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "M_DetailList.h"
#import "M_ListItem.h"

@interface M_DetailList ()

/**<#object#>*/
@property (nonatomic,strong) UIView *sectionHeaderView;
/**<#object#>*/
@property (nonatomic,strong) NSMutableArray *allItems;
/**<#object#>*/
@property (nonatomic,strong) M_ListItem *itemSelect;

@end

@implementation M_DetailList

-(void)setListAll:(NSMutableArray *)listAll{
    _listAll = listAll;
    self.showsVerticalScrollIndicator = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray* listTop = listAll[0];
    NSArray* listBottom = listAll[1];
    
    //更多频道标签
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, padding + (padding + kItemH) * ((listTop.count - 1)/itemPerLine + 1), kScreenW, 30)];
    self.sectionHeaderView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    UILabel* moreText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    moreText.text = @"点击添加频道";
    moreText.font = [UIFont systemFontOfSize:14];
    [self.sectionHeaderView addSubview:moreText];
    [self addSubview:self.sectionHeaderView];
    
    __weak typeof(&*self) weakSelf = self;
    NSInteger count1 = listTop.count;
    for (int i = 0;  i < count1; i++) {
        M_ListItem* item = [[M_ListItem alloc] initWithFrame:CGRectMake(padding + (padding + kItemW) * (i%itemPerLine), padding + (kItemH + padding) * (i/itemPerLine), kItemW, kItemH)];
        item.longPressBlock = ^(){
            if (weakSelf.longPressedBlock) {
                weakSelf.longPressedBlock();
            }
        };
        item.operationBlock = ^(animateType type, NSString *itemName, int index) {
            if (weakSelf.operationFromItemBlock) {
                weakSelf.operationFromItemBlock(type, itemName, index);
            }
        };
        item.itemName = listTop[i];
        item.location = top;
        [self.topView addObject:item];
        item->locationView = self.topView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        item.hitTextLabel = self.sectionHeaderView;
        [self addSubview:item];
        [self.allItems addObject:item];
        
        if (!self.itemSelect) {
            [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.itemSelect = item;
        }
    }
    
    NSInteger count2 = listBottom.count;
    for (int i = 0; i< count2; i++) {
        M_ListItem* item = [[M_ListItem alloc] initWithFrame:CGRectMake(padding + (padding + kItemW) * (i%itemPerLine), CGRectGetMaxY(self.sectionHeaderView.frame) + padding + (padding + kItemH) * (i/itemPerLine), kItemW, kItemH)];
        item.operationBlock = ^(animateType type, NSString *itemName, int index) {
            if (weakSelf.operationFromItemBlock) {
                weakSelf.operationFromItemBlock(type, itemName, index);
            }
        };
        item.itemName = listBottom[i];
        item.location = bottom;
        item.hitTextLabel = self.sectionHeaderView;
        [self.bottomView addObject:item];
        item->locationView = self.bottomView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        [self addSubview:item];
        [self.allItems addObject:item];
    }
    
    self.contentSize = CGSizeMake(kScreenW, CGRectGetMaxY(self.sectionHeaderView.frame) + padding + (kItemH + padding) * ((count2 - 1)/4 + 1) + 50);
}

-(void)itemResponseFromListBarClickWithItemName:(NSString *)itemName{
    for (int i = 0; i < self.allItems.count; i++) {
        M_ListItem* item = (M_ListItem*)self.allItems[i];
        if ([itemName isEqualToString:item.itemName]) {
            [self.itemSelect setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.itemSelect = item;
        }
    }
}

-(NSMutableArray *)allItems{
    if (!_allItems) {
        _allItems = [NSMutableArray array];
    }
    return _allItems;
}

-(NSMutableArray *)topView{
    if (!_topView) {
        _topView = [NSMutableArray array];
    }
    return _topView;
}

-(NSMutableArray *)bottomView{
    if (!_bottomView) {
        _bottomView = [NSMutableArray array];
    }
    return _bottomView;
}

@end
