//
//  M_ListItem.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "M_ListItem.h"

#define kDeleteW        6
#define KItemFont       13
#define KItemSizeChangeAdded    2

@implementation M_ListItem

-(void)setItemName:(NSString *)itemName{
    _itemName = itemName;
    
    [self setTitle:itemName forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:KItemFont];
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addTarget:self action:@selector(operationWithoutHidBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureOperation:)];
    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    self.longGesture.minimumPressDuration = 1;
    self.longGesture.allowableMovement = 20;
    [self addGestureRecognizer:self.longGesture];
    
    if (![itemName isEqualToString:@"推荐"]) {
        if (!self.deleteBtn) {
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(-kDeleteW + 2, -kDeleteW + 2, kDeleteW * 2, kDeleteW * 2);
            self.deleteBtn.userInteractionEnabled = NO;
            [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width/2;
            self.deleteBtn.backgroundColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1];
            [self addSubview:self.deleteBtn];
        }
    }
    
    if (!self.hiddenBtn) {
        self.hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hiddenBtn.frame = self.bounds;
        self.hiddenBtn.hidden = YES;
        [self.hiddenBtn addTarget:self action:@selector(operationWithHidbtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hiddenBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortButtonClick:) name:@"sortBtnClick" object:nil];
}

-(void)longPress{
    if (self.hiddenBtn.hidden == NO) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
        if (self.location == top) {
            [self addGestureRecognizer:self.gesture];
        }
    }
}

-(void)sortButtonClick:(NSNotification*)notification{
    if (self.location == top) {
        self.deleteBtn.hidden = !self.deleteBtn.hidden;
    }
    self.hiddenBtn.hidden = !self.hiddenBtn.hidden;
    if (self.gestureRecognizers) {
        [self removeGestureRecognizer:self.gesture];
    }
    if (self.deleteBtn.hidden && self.location == top) {
        [self addGestureRecognizer:self.gesture];
    }
}

-(void)operationWithHidbtn{
    if (!self.hiddenBtn.hidden) {
        if (self.location == top) {
            [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            if (self.operationBlock) {
                self.operationBlock(topViewClick, self.titleLabel.text, 0);
            }
            [self animationForWholeView];
        } else if (self.location == bottom) {
            [self changeFromBottomToTop];
        }
    }
}

-(void)operationWithoutHidBtn{
    if (self.location == top) {
        [self changeFromTopToBottom];
        self.deleteBtn.hidden = !self.deleteBtn.hidden;
    } else if (self.location == bottom) {
        self.deleteBtn.hidden = NO;
        [self addGestureRecognizer:self.gesture];
        [self changeFromBottomToTop];
    }
}

-(void)panGestureOperation:(UIPanGestureRecognizer*)pan{
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex:self.superview.subviews.count - 1];
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            CGRect itemFrame = self.frame;
            [self setFrame:CGRectMake(itemFrame.origin.x - KItemSizeChangeAdded, itemFrame.origin.y - KItemSizeChangeAdded, itemFrame.size.width + KItemSizeChangeAdded*2, itemFrame.size.height + KItemSizeChangeAdded*2)];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            BOOL inTopView = [self whetherInAreaWithArray:topView point:center];
            if (inTopView) {
                NSInteger indexX = (center.x <= kItemW + 2 * padding) ? 0 : (center.x - kItemW - 2 * padding)/(padding + kItemW) + 1;
                NSInteger indexY = (center.y <= kItemH + 2 * padding) ? 0 : (center.y - kItemH - 2 * padding)/(padding + kItemH) + 1;
                NSInteger index = indexX + indexY * itemPerLine;
                index = (index == 0) ? 1 : index;
                
                [locationView removeObject:self];
                [topView insertObject:self atIndex:index];
                locationView = topView;
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTop, self.titleLabel.text, (int)index);
                }
            } else if (!inTopView && center.y < [self TopViewMaxY] + 50 ){
                [locationView removeObject:self];
                [topView insertObject:self atIndex:topView.count];
                locationView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTopLast, self.titleLabel.text, 0);
                }
            } else if (center.y > [self TopViewMaxY] + 50) {
                [self changeFromTopToBottom];
            }
            break;
        }
            case UIGestureRecognizerStateEnded:
            [self animationForWholeView];
            break;
        default:
            break;
    }
}

-(void)changeFromTopToBottom{
    [locationView removeObject:self];
    [bottomView insertObject:self atIndex:0];
    locationView = bottomView;
    self.location = bottom;
    self.deleteBtn.hidden = YES;
    [self removeGestureRecognizer:self.gesture];
    if (self.operationBlock) {
        self.operationBlock(FromTopToBottomHead, self.titleLabel.text, 0);
    }
    [self animationForWholeView];
}

-(void)changeFromBottomToTop{
    [locationView removeObject:self];
    [topView insertObject:self atIndex:topView.count];
    locationView = topView;
    self.location = top;
    if (self.operationBlock) {
        self.operationBlock(FromBottomToTopLast, self.titleLabel.text, 0);
    }
    [self animationForWholeView];
}

-(BOOL)whetherInAreaWithArray:(NSMutableArray*)array point:(CGPoint)point{
    int row = (array.count%itemPerLine == 0) ? itemPerLine : array.count%itemPerLine;
    int column = (int)(array.count - 1)/itemPerLine + 1;
    if ((point.x > 0 && point.x <= kScreenW && point.y > 0 && point.y <= (kItemH + padding) * (column - 1) + padding) ||
        (point.x > 0 && point.x <= (row * (padding + kItemW) + padding) && point.y > (kItemH + padding) * (column - 1) + padding && point.y <= (kItemH + padding) * column + padding)) {
        return YES;
    }
    return NO;
}

-(unsigned long)TopViewMaxY{
    unsigned long y = 0;
    y = ((topView.count - 1)/itemPerLine + 1) * (kItemH + padding) + padding;
    return y;
}

-(void)animationForTopView{
    for (int i = 0; i < topView.count; i ++ ) {
        if ([topView objectAtIndex:i] != self) {
            [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding + (padding + kItemW) * (i%itemPerLine), padding + (kItemH + padding) * (i/itemPerLine), kItemW, kItemH)];
        }
    }
}

-(void)animationForBottomView{
    for (int i = 0; i < topView.count; i++) {
        [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding + (padding + kItemW) * (i%itemPerLine), [self TopViewMaxY] + 50 + (kItemH + padding) * (i/itemPerLine), kItemW, kItemH)];
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0, [self TopViewMaxY], kScreenW, 30)];
}

-(void)animationForWholeView{
    for (int i = 0; i < topView.count; i++) {
        [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding + (kItemW + padding) * (i%itemPerLine), padding + (padding + kItemH) * (i/itemPerLine), kItemW, kItemH)];
    }
    for (int i = 0; i < bottomView.count; i ++) {
        [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding + (kItemW + padding) * (i%itemPerLine), [self TopViewMaxY] + 50 + (kItemH + padding) * (i/itemPerLine), kItemW, kItemH)];
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0, [self TopViewMaxY], kScreenW, 30)];
}

-(void)animationWithView:(UIView*)view frame:(CGRect)frame{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [view setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
