//
//  SPDropMenu.h
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDropItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPDropMenu : NSObject

+ (BOOL)isOnShow;

+ (void)showInView:(UIView *)view items:(NSArray <id <SPDropItemProtocol>>*)items;
+ (void)showFromPoint:(CGPoint)point items:(NSArray <id <SPDropItemProtocol>>*)items;

+ (void)dismiss;


@end

NS_ASSUME_NONNULL_END
