//
//  ViewController.m
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import "ViewController.h"
#import "LDSGiftView.h"
#import "LDSGiftCellModel.h"
#import "YYModel.h"
#import "LDSGiftModel.h"
#import "LDSGiftShowManager.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <LDSGiftViewDelegate>

@property(nonatomic,strong) LDSGiftView *giftView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.giftView.dataArray = [NSArray yy_modelArrayWithClass:[LDSGiftCellModel class] json:[self _getData]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.giftView showGiftView];
}

#pragma mark - LDSGiftViewDelegate

- (void)giftViewSendGiftInView:(LDSGiftView *)giftView data:(LDSGiftCellModel *)model {
    
    NSLog(@"点击-- %@",model.name);
    LDSGiftModel *giftModel = [[LDSGiftModel alloc] init];
    giftModel.userIcon = model.icon;
    giftModel.userName = model.username;
    giftModel.giftName = model.name;
    giftModel.giftImage = model.icon;
    giftModel.giftGifImage = model.icon_gif;
    giftModel.giftId = model.id;
    giftModel.defaultCount = 0;
    giftModel.sendCount = 1;
    
    [[LDSGiftShowManager shareInstance] showGiftViewWithBackView:self.view info:giftModel completeBlock:^(BOOL finished) {
        //结束
    }];
}

- (LDSGiftView *)giftView {
    if (_giftView == nil) {
        _giftView = [[LDSGiftView alloc] init];
        _giftView.delegate = self;
    }
    return _giftView;
}

- (NSMutableArray *)_getData {
    NSString *filePath=[[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSArray *data = [responseObject objectForKey:@"data"];
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:data];
    return dataArr;
}

@end
