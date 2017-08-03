//
//  M_DeleteBar.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "M_DeleteBar.h"

@implementation M_DeleteBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self makeNewBar];
    }
    return self;
}

-(void)makeNewBar{
    self.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = @"我的频道";
    [self addSubview:label];
    
    if (!self.hitText) {
        self.hitText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, 10, 120, 11)];
        self.hitText.font = [UIFont systemFontOfSize:11];
        self.hitText.text = @"点击可直接进入频道";
        self.hitText.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        self.hitText.hidden = YES;
        [self addSubview:self.hitText];
    }
    
    if (!self.sortBtn) {
        self.sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sortBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 5, 50, 20);
        [self.sortBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.sortBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.sortBtn.layer.cornerRadius = 5;
        self.sortBtn.layer.masksToBounds = YES;
        self.sortBtn.layer.borderWidth = 0.5;
        self.sortBtn.layer.borderColor = [UIColor redColor].CGColor;
        [self.sortBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sortBtn];
    }
}

-(void)sortBtnClick:(UIButton *)sender{
    if (sender.selected) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.hitText.hidden = YES;
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.hitText.hidden = NO;
    }
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sortBtnClick" object:sender];
}

@end
