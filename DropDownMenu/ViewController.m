//
//  ViewController.m
//  DropDownMenu
//
//  Created by TsanFeng Lam on 2019/8/29.
//  Copyright © 2019 SampleProjectsBooth. All rights reserved.
//

#import "ViewController.h"
#import "SPDropMenu.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *leftBottomButton;

@property (weak, nonatomic) IBOutlet UIButton *rightBottomButton;

@property (nonatomic, strong) NSArray *menuSources;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"leftTopButton" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftTopOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"rightTopButton" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(leftTopOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    /** 单击的 Recognizer */
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singlePressed:)];
    /** 点击的次数 */
    singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    /** 给view添加一个手势监测 */
    [self.view addGestureRecognizer:singleTapRecognizer];
}

#pragma mark - 创建菜单列表
- (NSArray <id <SPDropItemProtocol>>*)createMenuSource
{
    if (_menuSources == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger i=0; i<10; i++) {
            SPDropItem *item = [[SPDropItem alloc] init];
            item.title = [NSString stringWithFormat:@"测试_%d", (int)i];
            [item setImage:[self iconWithName:@"icon.png"] forState:SPDropItemStateNormal];
            [item setImage:[self iconWithName:@"icon_HL.png"] forState:SPDropItemStateSelected];
            [item setTitleColor:[UIColor whiteColor] forState:SPDropItemStateNormal];
            [item setTitleColor:[UIColor colorWithRed:(26/255.0) green:(173/255.0) blue:(25/255.0) alpha:1.0] forState:SPDropItemStateSelected];
            if (i == 0) {
                item.selected = YES;
            }
            item.tapHandler = ^(SPDropItem * _Nonnull item) {
                NSLog(@"onClick %@", item.title);
            };
            [array addObject:item];
        }
        _menuSources = [array copy];
    }
    return _menuSources;
}

#pragma mark - 手势点击事件
- (void)singlePressed:(UITapGestureRecognizer *)sender
{
    CGPoint touchPt = [sender locationInView:self.view];
    [SPDropMenu setDirection:SPDropMainMenuDirectionAuto];
    [SPDropMenu showFromPoint:touchPt items:[self createMenuSource]];
}

- (void)leftTopOnClick:(id)sender {
    [SPDropMenu setDirection:SPDropMainMenuDirectionBottom];
    [SPDropMenu showInView:sender items:[self createMenuSource]];
}

- (void)rightTopOnClick:(id)sender {
    [SPDropMenu setDirection:SPDropMainMenuDirectionBottom];
    [SPDropMenu showInView:sender items:[self createMenuSource]];
}

- (IBAction)leftBottomOnClick:(id)sender {
    [SPDropMenu setDirection:SPDropMainMenuDirectionTop];
    [SPDropMenu showInView:sender items:[self createMenuSource]];
}

- (IBAction)rightBottomOnClick:(id)sender {
    [SPDropMenu setDirection:SPDropMainMenuDirectionTop];
    [SPDropMenu showInView:sender items:[self createMenuSource]];
}

- (IBAction)testLeftAndTopBottomOnClick:(id)sender
{
    [SPDropMenu setDirection:SPDropMainMenuDirectionBottom];
    [SPDropMenu showInView:sender items:[self createMenuSource]];
}

- (IBAction)testLeftAndTopBottomOnClick2:(id)sender
{
    [self testLeftAndTopBottomOnClick:sender];
}
#pragma mark - private
- (UIImage *)iconWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

@end
