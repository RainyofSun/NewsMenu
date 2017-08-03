//
//  MainController.m
//  NewsMenu
//
//  Created by 刘冉 on 2017/8/2.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "MainController.h"
#import "M_ListBar.h"
#import "M_Arrow.h"
#import "M_DetailList.h"
#import "M_DeleteBar.h"
#import "M_SController.h"

#define kListBarH       30
#define kArrow          40  
#define kAnimationTime  0.8

@interface MainController ()<UIScrollViewDelegate>

/**<#object#>*/
@property (nonatomic,strong) M_ListBar *listBar;
/**<#object#>*/
@property (nonatomic,strong) M_DeleteBar *deleteBar;
/**<#object#>*/
@property (nonatomic,strong) M_DetailList *detailList;
/**<#object#>*/
@property (nonatomic,strong) M_Arrow *arrow;
/**<#object#>*/
@property (nonatomic,strong) UIScrollView *mainSController;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeContent];
}

-(void)makeContent{
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"推荐",@"热点",@"杭州",@"社会",@"娱乐",@"科技",@"汽车",@"体育",@"订阅",@"财经",@"军事",@"国际",@"正能量",@"段子",@"趣图",@"美女",@"健康",@"教育",@"特卖",@"彩票",@"辟谣"]];
    NSMutableArray *listBottom = [[NSMutableArray alloc] initWithArray:@[@"电影",@"数码",@"时尚",@"奇葩",@"游戏",@"旅游",@"育儿",@"减肥",@"养生",@"美食",@"政务",@"历史",@"探索",@"故事",@"美文",@"情感",@"语录",@"美图",@"房产",@"家居",@"搞笑",@"星座",@"文化",@"毕业生",@"视频"]];
    
    __weak typeof(&*self)weakSelf = self;
    if (!self.detailList) {
        self.detailList = [[M_DetailList alloc] initWithFrame:CGRectMake(0, kListBarH - kScreenH, kScreenW, kScreenH - kListBarH)];
        self.detailList.listAll = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        self.detailList.longPressedBlock = ^{
            [weakSelf.deleteBar sortBtnClick:weakSelf.deleteBar.sortBtn];
        };
        self.detailList.operationFromItemBlock = ^(animateType type, NSString *itemName, int index) {
            [weakSelf.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailList];
    }
    
    if (!self.listBar) {
        self.listBar = [[M_ListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^{
            if (weakSelf.arrow.arrowBtnClick) {
                weakSelf.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName, NSInteger itemIndex) {
            //添加到scrollView
            [weakSelf.detailList itemResponseFromListBarClickWithItemName:itemName];
            //移动到该位置
            weakSelf.mainSController.contentOffset = CGPointMake(itemIndex * weakSelf.mainSController.frame.size.width, 0);
        };
        
        [self.view addSubview:self.listBar];
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[M_DeleteBar alloc] initWithFrame:self.listBar.frame];
        [self.view addSubview:self.deleteBar];
    }
    
    if (!self.arrow) {
        self.arrow = [[M_Arrow alloc] initWithFrame:CGRectMake(kScreenW - kArrow, 0, kArrow, kListBarH)];
        self.arrow.arrowBtnClick = ^{
            weakSelf.deleteBar.hidden = !weakSelf.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = weakSelf.arrow.imageView.transform;
                weakSelf.arrow.imageView.transform = CGAffineTransformRotate(rotation, M_PI);
                weakSelf.detailList.transform = (weakSelf.detailList.frame.origin.y < 0) ? CGAffineTransformMakeTranslation(0, kScreenH) : CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        
        [self.view addSubview:self.arrow];
    }
    
    if (!self.mainSController) {
        self.mainSController = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW, kScreenH - kListBarH - 64)];
        self.mainSController.backgroundColor = [UIColor yellowColor];
        self.mainSController.bounces = NO;
        self.mainSController.pagingEnabled = YES;
        self.mainSController.showsHorizontalScrollIndicator = NO;
        self.mainSController.showsVerticalScrollIndicator = NO;
        self.mainSController.delegate = self;
        self.mainSController.contentSize = CGSizeMake(kScreenW * 10, self.mainSController.frame.size.height);
        [self.view insertSubview:self.mainSController atIndex:0];
        
        //预加载、清除防止内存过大等操作
        [self addScrollViewWithItemName:@"推荐" index:0];
        [self addScrollViewWithItemName:@"测试" index:1];
    }
    
}

-(void)addScrollViewWithItemName:(NSString*)itemName index:(NSInteger)index{
    UIScrollView* scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(index * self.mainSController.frame.size.width, 0, self.mainSController.frame.size.width, self.mainSController.frame.size.height)];
    scroller.backgroundColor = [UIColor colorWithRed:arc4random()%255 green:arc4random()%255 blue:arc4random()%255 alpha:1];
    [self.mainSController addSubview:scroller];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainSController.frame.size.width];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
