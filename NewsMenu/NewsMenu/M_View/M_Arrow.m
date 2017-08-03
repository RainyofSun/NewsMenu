//
//  M_Arrow.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "M_Arrow.h"

@implementation M_Arrow

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateHighlighted];
        
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self addTarget:self action:@selector(arrowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)arrowClick{
    if (self.arrowBtnClick) {
        self.arrowBtnClick();
    }
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageSize = 18;
    return CGRectMake((contentRect.size.width - imageSize) / 2, (30 - imageSize) / 2, imageSize, imageSize);
}

@end
