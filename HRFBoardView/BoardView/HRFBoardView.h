//
//  HRFBoardView.h
//  mathfighters
//
//  Created by Héctor Rodríguez Forniés on 29/04/14.
//  Copyright (c) 2014 Petit Beaucoup Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>

@class HRFBoardView;

@protocol HRFBoardViewDelegate

- (void)boardView:(HRFBoardView *)boardView didSelectButton:(UIButton *)button atIndex:(NSInteger)index; //Works like tableView:didSelectRowAtIndexPath:
- (UIButton *)boardView:(HRFBoardView *)boardView customizeButtonAtIndex:(NSInteger)index withData:(NSMutableArray *)theData; //Works like tableView:cellForRowAtIndexPath:

@end





@interface HRFBoardView : UIView <POPAnimationDelegate>

//Views
@property(nonatomic, strong) UIView *currentButtonsView; //The view that is in screen

//Delegate
@property(nonatomic, weak) id<HRFBoardViewDelegate> delegate;

//Data Source
@property(nonatomic, strong) NSMutableArray *boardData; //Array of arrays that contains the data
@property(nonatomic, strong) NSMutableArray *currentDataArray; //The current array inside the boardData

- (id)initWithFrame:(CGRect)theFrame padding:(NSUInteger)thePadding data:(NSMutableArray *)theData numberOfColumns:(NSInteger)theNumberOfColumns paddingBetweenButtons:(NSInteger)paddingButtons delegate:(id<HRFBoardViewDelegate>)theDelegate;

- (void)next;

- (void)defineButtonStateCorrect:(BOOL)correct atIndex:(NSUInteger)index successBlock:(void (^)(void))successBlock failBlock:(void (^)(void))failBlock;

@end
