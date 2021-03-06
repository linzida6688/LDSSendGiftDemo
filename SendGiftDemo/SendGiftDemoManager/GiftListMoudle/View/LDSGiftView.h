//
//  LDSGiftView.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LDSGiftView,LDSGiftCellModel;
@protocol LDSGiftViewDelegate <NSObject>
@optional
/**
 赠送礼物

 @param giftView 礼物的选择的view
 @param model 礼物展示的数据
 */
- (void)giftViewSendGiftInView:(LDSGiftView *)giftView data:(LDSGiftCellModel *)model;
@end

@interface LDSGiftView : UIView

/** data */
@property(nonatomic,strong) NSArray *dataArray;

- (void)showGiftView;

- (void)hiddenGiftView;

@property(nonatomic,weak)id<LDSGiftViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
