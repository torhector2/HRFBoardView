//
//  ViewController.m
//  HRFBoardView
//
//  Created by Héctor Rodríguez Forniés on 3/2/15.
//  Copyright (c) 2015 HRF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) HRFBoardView   *boardView;
@property(nonatomic)         NSInteger      currentIndexBoard;
@property(nonatomic, strong) NSArray        *data;
@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"],
                @[@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19"],
                @[@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29"]];

    CGRect boardFrame = CGRectMake(10, 40, self.view.bounds.size.width - 20, self.view.bounds.size.width - 20);
    self.boardView = [[HRFBoardView alloc] initWithFrame:boardFrame padding:5 data:[self.data mutableCopy] numberOfColumns:3 paddingBetweenButtons:2 delegate:self];
//    self.boardView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.boardView];
    
    self.currentIndexBoard = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)randomSuccess {
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0) {
        return YES;
    }
    return NO;
}

#pragma mark HRFBoardViewDelegate

- (void)boardView:(HRFBoardView *)boardView didSelectButton:(UIButton *)button atIndex:(NSInteger)index {
    NSLog(@"Button press at index: %ld", index);
    
    BOOL success = [self randomSuccess]; //Use the logig that you need
    
    [boardView defineButtonStateCorrect:success atIndex:index successBlock:^{
        NSLog(@"Success");
        if (self.currentIndexBoard < self.data.count - 1) {
            [boardView next];
            self.currentIndexBoard++;
        } else {
            [self.boardView removeFromSuperview];
            self.boardView = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"You WIN" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    } failBlock:^{
        NSLog(@"Fail");
    }];
    
}

- (UIButton *)boardView:(HRFBoardView *)boardView customizeButtonAtIndex:(NSInteger)index withData:(NSMutableArray *)theData{
    
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [theButton setBackgroundImage:[UIImage imageNamed:@"ficha_base"] forState:UIControlStateNormal];
    [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *num = [theData objectAtIndex:index];
    [theButton setTitle:num forState:UIControlStateNormal];
    
    return theButton;
}

@end
