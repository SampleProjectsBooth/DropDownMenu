//
//  SPDropItemProtocol.h
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SPDropItemProtocol;

typedef void(^SPDropItemHandler)(id <SPDropItemProtocol> item);

@protocol SPDropItemProtocol <NSObject>

@required
@property (nonatomic, readonly) UIView *displayView;

@property (nonatomic, copy) SPDropItemHandler handler;

@end

NS_ASSUME_NONNULL_END
