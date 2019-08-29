//
//  SPDropItem.h
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPDropItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPDropItem : NSObject <SPDropItemProtocol>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, nullable) UIImage *icon;

@end

NS_ASSUME_NONNULL_END
