//
//  SPDropMenu.m
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import "SPDropMenu.h"
#import "SPDropMainMenu.h"

static SPDropMainMenu *_SPDropMainMenu;

@implementation SPDropMenu

+ (BOOL)isOnShow
{
    return (BOOL)_SPDropMainMenu;
}

+ (void)showInView:(UIView *)view items:(NSArray <id <SPDropItemProtocol>>*)items
{
    [self dismiss];
    _SPDropMainMenu = [[SPDropMainMenu alloc] init];
    for (id <SPDropItemProtocol> item in items) {
        [_SPDropMainMenu addItem:item];
    }
    [_SPDropMainMenu showInView:view];
}
+ (void)showFromPoint:(CGPoint)point items:(NSArray <id <SPDropItemProtocol>>*)items
{
    [self dismiss];
    _SPDropMainMenu = [[SPDropMainMenu alloc] init];
    for (id <SPDropItemProtocol> item in items) {
        [_SPDropMainMenu addItem:item];
    }
    [_SPDropMainMenu showFromPoint:point];
}

+ (void)dismiss
{
    if (_SPDropMainMenu) {
        [_SPDropMainMenu dismiss];
        _SPDropMainMenu = nil;
    }
}

@end
