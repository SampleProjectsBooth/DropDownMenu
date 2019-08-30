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

const NSString *SPDropMainMenu_autoDismiss = @"SPDropMainMenu_autoDismiss";

static NSMutableDictionary *_SPDrapMainMenuPropertys;

@implementation SPDropMenu

+ (void)setAutoDismiss:(BOOL)isAutoDismiss
{
    self.SPDrapMainMenuPropertys[SPDropMainMenu_autoDismiss] = @(isAutoDismiss);
    _SPDropMainMenu.autoDismiss = isAutoDismiss;
}

+ (BOOL)isOnShow
{
    return (BOOL)_SPDropMainMenu;
}

+ (void)showInView:(UIView *)view items:(NSArray <id <SPDropItemProtocol>>*)items
{
    [self dismiss];
    _SPDropMainMenu = [self SPDropMainMenuWithItems:items];
    [_SPDropMainMenu showInView:view];
}
+ (void)showFromPoint:(CGPoint)point items:(NSArray <id <SPDropItemProtocol>>*)items
{
    [self dismiss];
    _SPDropMainMenu = [self SPDropMainMenuWithItems:items];
    [_SPDropMainMenu showFromPoint:point];
}

+ (void)dismiss
{
    if (_SPDropMainMenu) {
        [_SPDropMainMenu dismiss];
        _SPDropMainMenu = nil;
    }
}

#pragma mark - private
+ (NSMutableDictionary *)SPDrapMainMenuPropertys
{
    if (_SPDrapMainMenuPropertys == nil) {
        _SPDrapMainMenuPropertys = [NSMutableDictionary dictionary];
    }
    return _SPDrapMainMenuPropertys;
}

+ (SPDropMainMenu *)SPDropMainMenuWithItems:(NSArray <id <SPDropItemProtocol>>*)items
{
    SPDropMainMenu *dropMainMenu = [[SPDropMainMenu alloc] init];
    id value = self.SPDrapMainMenuPropertys[SPDropMainMenu_autoDismiss];
    if (value) {
        dropMainMenu.autoDismiss = [value boolValue];
    }
    for (id <SPDropItemProtocol> item in items) {
        [dropMainMenu addItem:item];
    }
    return dropMainMenu;
}

@end
