//
//  LDSGiftCellModel.h
//  SendGiftDemo
//
//  Created by Lindashuai on 2020/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDSGiftCellModel : NSObject

/** id */
@property(nonatomic,copy)NSString *id;
/** icon */
@property(nonatomic,copy)NSString *icon;
/** icon_gif */
@property(nonatomic,copy)NSString *icon_gif;
/** name */
@property(nonatomic,copy)NSString *name;
/** type */
@property(nonatomic,copy)NSString *type;
/** 价格 */
@property(nonatomic,copy)NSString *value;
/** 是否选中 */
@property(nonatomic,assign)BOOL isSelected;
/** username */
@property(nonatomic,copy)NSString *username;
/** cost_type 0星星 1测测币 */
@property(nonatomic,copy)NSString *cost_type;

@end

NS_ASSUME_NONNULL_END
