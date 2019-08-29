//
//  SPDropItem.m
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import "SPDropItem.h"
#import <CoreText/CoreText.h>

@interface SPDropItem ()

@property (nonatomic, strong) UIView *displayView;

@end

@implementation SPDropItem

@synthesize handler, selected;

- (UIView *)displayView
{
    if (_displayView == nil) {
        
        CGFloat margin = 5.f;
        /**
         最大宽度
         */
        CGFloat maxWidth = 180.f;
        /**
         图片最大宽度占整体30%
         */
        CGFloat maxIconWidth = 0;
        CGFloat maxTextWidth = 0;
        if (self.icon) {
            maxIconWidth = maxWidth*0.3f-margin*1.5;
            maxTextWidth = maxWidth - maxIconWidth - margin*3;
        } else {
            maxTextWidth = maxWidth - margin*2;
        }
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithRed:39/255.0 green:35/255.0 blue:35/255.0 alpha:0.8f];
        /**
         计算文字高度
         */
        UIFont *font = [UIFont systemFontOfSize:17.f];
        NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
        CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attribString;
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [attribString length]), NULL, CGSizeMake(maxTextWidth, CGFLOAT_MAX), NULL);
        CFRelease(framesetter);
        
        
        
        
        CGFloat x = 0;
        // icon
        if (self.icon) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:self.icon];
            imageView.frame = CGRectMake(x+margin, margin, maxIconWidth, maxIconWidth);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageView];
            x = CGRectGetMaxX(imageView.frame);
        }
        // title
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x+margin, margin, textSize.width, textSize.height)];
            label.attributedText = attribString;
            [view addSubview:label];
            x = CGRectGetMaxX(label.frame);
        }
        
        view.frame = CGRectMake(0, 0, x+margin, MAX(maxIconWidth, textSize.height)+margin);
        
        _displayView = view;
    }
    return _displayView;
}

@end
