//
//  LDSGiftView.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "LDSGiftView.h"
#import "LDSGiftCollectionViewCell.h"
#import "LDSGiftCellModel.h"
#import "LDSHorizontalLayout.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define Nav_Bar_HEIGHT (iPhoneX ? 88.f : 64.f)
// 导航+状态
#define Nav_Status_Height (STATUS_BAR_HEIGHT+Nav_Bar_HEIGHT)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
//距离底部的间距
#define Bottom_Margin(margin) ((margin)+HOME_INDICATOR_HEIGHT)

static NSString *cellID = @"LDSGiftCollectionViewCell";

@interface LDSGiftView()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 底部功能栏 */
@property(nonatomic,strong) UIView *bottomView;
/** 礼物显示 */
@property(nonatomic,strong) UICollectionView *collectionView;
/** ccb余额 */
@property(nonatomic,strong) UILabel *ccbLabel;
/** 上一次点击的model */
@property(nonatomic,strong) LDSGiftCellModel *preModel;
/** pagecontro */
@property(nonatomic,strong) UIPageControl *pageControl;

@end

@implementation LDSGiftView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);

        [self p_SetUI];
    }
    return self;
}


#pragma mark -设置UI
- (void)p_SetUI {
    
    UIView *bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, self.frame.size.height-Bottom_Margin(44), self.frame.size.width, Bottom_Margin(44))];
    bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    self.pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(CGRectGetWidth(bottomView.frame)*0.5-15, 0, 30, CGRectGetHeight(bottomView.frame))];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.hidden = YES;
    [bottomView addSubview:self.pageControl];
    
    UIImageView *ccbImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 20, 20)];
    //ccbImage.image = [UIImage imageNamed:@"Live_Red_ccb"];
    [bottomView addSubview:ccbImage];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-60, 2, 60, 40)];
    [sendBtn setBackgroundColor:[UIColor grayColor]];
    [sendBtn setTitle:@"send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(p_ClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
    
    //110*125
    CGFloat itemW = SCREEN_WIDTH/4.0;
    CGFloat itemH = itemW*125/110.0;
    LDSHorizontalLayout *layout = [[LDSHorizontalLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(bottomView.frame)-1-2*itemH, SCREEN_WIDTH, 2*itemH) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    [collectionView registerClass:[LDSGiftCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;

    self.pageControl.numberOfPages = (dataArray.count-1)/8+1;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden =  !((dataArray.count-1)/8);
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LDSGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        LDSGiftCellModel *model = self.dataArray[indexPath.item];
        cell.model = model;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < self.dataArray.count) {
        LDSGiftCellModel *model = self.dataArray[indexPath.item];
        model.isSelected = !model.isSelected;
        if ([self.preModel isEqual:model]) {
            [collectionView reloadData];
        }else {
            self.preModel.isSelected = NO;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }];

        }
        self.preModel = model;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    self.pageControl.currentPage = x/SCREEN_WIDTH+0.5;
}

#pragma mark -发送
- (void)p_ClickSendBtn {
    
    //找到已选中的礼物
    BOOL isBack = NO;
    for (LDSGiftCellModel *model in self.dataArray) {
        if (model.isSelected) {
            isBack = YES;
            if ([self.delegate respondsToSelector:@selector(giftViewSendGiftInView:data:)]) {
                [self.delegate giftViewSendGiftInView:self data:model];
            }
        }
    }
    if (!isBack) {
        //提示选择礼物
        NSLog(@"没有选择礼物");
    }

}



- (void)showGiftView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];

}

- (void)hiddenGiftView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenGiftView];
}

@end

