# HRFBoardView

Customizable board for iOS games

<img src="http://i.giphy.com/yoJC2KugJ3k0cIuG08.gif" />

## Usage

```objc
#import "HRFBoardView.h"
```

```objc
@interface ViewController : UIViewController <HRFBoardViewDelegate>
```

```objc
NSArray *data = @[@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"],
                @[@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19"],
                @[@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29"]];
HRFBoardView *boardView = [[HRFBoardView alloc] initWithFrame:boardFrame padding:5 
    data:[self.data mutableCopy] numberOfColumns:3 paddingBetweenButtons:2 delegate:self];
[self.view addSubview:self.boardView];
```

```objc
#pragma mark HRFBoardViewDelegate

- (void)boardView:(HRFBoardView *)boardView didSelectButton:(UIButton *)button atIndex:(NSInteger)index {
    NSLog(@"Button press at index: %ld", index);
    
    BOOL success = [self randomSuccess]; //Use the business logic that you prefer
    
    [boardView defineButtonStateCorrect:success atIndex:index successBlock:^{
        NSLog(@"Success");
            //Next board
            [boardView next];
        } else {
            [self.boardView removeFromSuperview];
            self.boardView = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"You WIN" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    } failBlock:^{
        //Customize the wrong answer behaviour
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

```
##Dependencies
<a href="https://github.com/facebook/pop">facebook POP</a>

Pop is an extensible animation engine for iOS and OS X. In addition to basic static animations, it supports spring and decay dynamic animations, making it useful for building realistic, physics-based interactions. The API allows quick integration with existing Objective-C codebases and enables the animation of any property on any object. It's a mature and well-tested framework that drives all the animations and transitions in Paper.
