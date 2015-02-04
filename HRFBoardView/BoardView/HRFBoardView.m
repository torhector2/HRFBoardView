//
//  HRFBoardView.m
//  mathfighters
//
//  Created by Héctor Rodríguez Forniés on 29/04/14.
//  Copyright (c) 2014 Petit Beaucoup Solutions. All rights reserved.
//

#import "HRFBoardView.h"

@interface HRFBoardView ()

@property(nonatomic, strong) UIView *buttonsViewA;
@property(nonatomic, strong) UIView *buttonsViewB;

@property(nonatomic, strong) NSMutableArray *buttonsArrayA;
@property(nonatomic, strong) NSMutableArray *buttonsArrayB;
@property(nonatomic, strong) NSMutableArray *currentButtonsArray;

@property(nonatomic, strong) NSValue *buttonCalculatedSize;

@property(nonatomic) NSInteger columns;
@property(nonatomic) NSInteger padding;
@property(nonatomic) NSInteger paddingBetweenButtons;

@end

#define DegreesToRadians(x) (M_PI * x / 180.0)

@implementation HRFBoardView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame padding:10 data:nil numberOfColumns:3 paddingBetweenButtons:5 delegate:nil];
}

- (id)initWithFrame:(CGRect)theFrame padding:(NSUInteger)thePadding data:(NSMutableArray *)theData numberOfColumns:(NSInteger)theNumberOfColumns paddingBetweenButtons:(NSInteger)paddingButtons delegate:(id<HRFBoardViewDelegate>)theDelegate{
    
    NSAssert(theData != nil, @"The data array cannot be nil");
    NSAssert(theData.count > 0, @"The data array cannot be empty");
    
    self = [super initWithFrame:theFrame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.boardData = theData;
        self.currentDataArray = [theData firstObject];
        
        self.delegate = theDelegate;

        self.columns = theNumberOfColumns;
        self.padding = thePadding;
        self.paddingBetweenButtons = paddingButtons;

        //Generate the buttons arrays
        self.buttonsArrayA = [NSMutableArray array];
        self.buttonsArrayB = [NSMutableArray array];
        self.currentButtonsArray = self.buttonsArrayA;
        
        //Generate the buttonsView
        self.buttonsViewA = [self generateButtonsViewForDataArray:self.currentDataArray];
        [self addSubview:self.buttonsViewA];
        
        if (self.boardData.count >= 2) {
            self.buttonsViewB = [self generateButtonsViewForDataArray:self.boardData[1]];
            [self addSubview:self.buttonsViewB];
        }
        self.currentButtonsView = self.buttonsViewA;
        
    }
    return self;
}

- (void)next {
    
    self.buttonsViewA.userInteractionEnabled = NO;
    self.buttonsViewB.userInteractionEnabled = NO;
    
    __block NSInteger indexArray = [self.boardData indexOfObject:self.currentDataArray];
    if (indexArray == self.boardData.count - 1) {
        return;
    }
    
    CGRect hiddenViewFrame = self.buttonsViewB.frame;
    CGRect currentViewFrame = self.currentButtonsView.frame;
    
    CGFloat ANIM_SPEED = 20.0f;
    CGFloat ANIM_BOUNCINESS = 5.0f;
    
    POPSpringAnimation *animA = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animA.delegate = self;
    animA.toValue = [NSNumber numberWithFloat: self.bounds.origin.x - self.currentButtonsView.bounds.size.width - 20];
    animA.springSpeed = ANIM_SPEED;
    animA.springBounciness = ANIM_BOUNCINESS;
    animA.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        self.buttonsViewA.userInteractionEnabled = YES;
        self.buttonsViewB.userInteractionEnabled = YES;
        
        self.currentButtonsView = self.buttonsViewB;
        self.buttonsViewB = self.buttonsViewA;
        self.buttonsViewA = self.currentButtonsView;

        self.currentButtonsArray = self.buttonsArrayB;
        self.buttonsArrayB = self.buttonsArrayA;
        self.buttonsArrayA = self.currentButtonsArray;
        
        self.currentButtonsView.frame = currentViewFrame;
        self.buttonsViewB.frame = hiddenViewFrame;
        
        //Update data source
        if (indexArray < self.boardData.count - 1) {
            self.currentDataArray = self.boardData[++indexArray];
        }
        
        if (indexArray < self.boardData.count - 1) {
            [self updateButtonsView:self.buttonsViewB withDataArray:self.boardData[++indexArray] buttonsArray:self.buttonsArrayB];
        }

    };
    
    POPSpringAnimation *animB = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animB.delegate = self;
    animB.toValue = [NSNumber numberWithFloat: self.currentButtonsView.frame.origin.x + (self.currentButtonsView.bounds.size.width / 2)];
    animB.springSpeed = ANIM_SPEED;
    animB.springBounciness = ANIM_BOUNCINESS;
    
    [self.currentButtonsView.layer pop_addAnimation:animA forKey:@"desplazaA"];
    [self.buttonsViewB.layer pop_addAnimation:animB forKey:@"desplazaB"];
}

#pragma mark Generate Buttons methods

- (UIView *)generateButtonsViewForDataArray:(NSMutableArray *)theArray {
   
    UIView *buttonsView = [[UIView alloc] init];
    CGRect btnsViewFrame;
    CGPoint btnsViewPoint;
    CGSize btnsViewSize = CGSizeMake(self.bounds.size.width - (2 * self.padding), self.bounds.size.height - (2 * self.padding));

    
    if (theArray == self.currentDataArray) {
        btnsViewPoint = CGPointMake(self.bounds.origin.x + self.padding, self.bounds.origin.y + self.padding);
    } else {
        NSInteger PADDING_BETWEEN_VIEWS = 50;
        btnsViewPoint = CGPointMake(self.bounds.origin.x + self.padding + btnsViewSize.width + PADDING_BETWEEN_VIEWS, self.bounds.origin.y + self.padding);
    }

    btnsViewFrame.size = btnsViewSize;
    btnsViewFrame.origin = btnsViewPoint;
    //Set the view frame
    buttonsView.frame = btnsViewFrame;
    
    for (NSInteger i = 0; i < theArray.count; i++) {
        UIButton *theBtn = [self generateButtonAtIndex:i forDataArray:theArray andButtonsView:buttonsView];
        [buttonsView addSubview:theBtn];
        
        if (theArray == self.currentDataArray) {
            [self.currentButtonsArray addObject:theBtn];
        } else {
            if (self.currentButtonsArray == self.buttonsArrayA) {
                [self.buttonsArrayB addObject:theBtn];
            } else {
                [self.buttonsArrayB addObject:theBtn];
            }
        }
        
    }
    
    return buttonsView;
}

- (void)updateButtonsView:(UIView *)theButtonsView withDataArray:(NSMutableArray *)theArray buttonsArray:(NSMutableArray *)theButtonsArray {
    
    //Delete the array
    [theButtonsArray removeAllObjects];
    
    //Delete all buttons from the superview
    for (UIView *removeView in theButtonsView.subviews) {
        [removeView removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < theArray.count; i++) {
        UIButton *theBtn = [self generateButtonAtIndex:i forDataArray:theArray andButtonsView:theButtonsView];
        [theButtonsView addSubview:theBtn];
        [theButtonsArray addObject:theBtn];
    }

}

- (UIButton *)generateButtonAtIndex:(NSInteger)index forDataArray:(NSMutableArray *)theArray andButtonsView:(UIView *)buttonsView {
    
    NSAssert(self.delegate != nil, @"You must define a HRFBoardViewDelegate");
    
    UIButton *theButton = [self.delegate boardView:self customizeButtonAtIndex:index withData:theArray];
    
    if (!theButton) {
        theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        theButton.backgroundColor = [UIColor yellowColor]; //test
        NSString *num = [theArray objectAtIndex:index];
        [theButton setTitle:num forState:UIControlStateNormal];
    }
    
    CGRect theButtonFrame = [self calculateButtonFrameAtIndex:index forDataArray:theArray andButtonsView:buttonsView];
    theButton.frame = theButtonFrame;
    [theButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return theButton;
}

- (CGRect)calculateButtonFrameAtIndex:(NSUInteger)index forDataArray:(NSMutableArray *)theArray andButtonsView:(UIView *)buttonsView {
    
    NSAssert(index < theArray.count, @"Index out of bounds in calculateButtonFrameAtIndex");
    
    NSUInteger totalRows = ceilf(theArray.count / self.columns);
    
    CGSize buttonSize;
    if (!self.buttonCalculatedSize) {
       
        NSUInteger buttonWidth = (buttonsView.frame.size.width - (2 * self.paddingBetweenButtons)) / self.columns;
        NSUInteger buttonHeight = (buttonsView.frame.size.height - (2 * self.paddingBetweenButtons)) / totalRows;
        
        buttonSize = CGSizeMake(buttonWidth, buttonHeight);
        self.buttonCalculatedSize = [NSValue valueWithCGSize:buttonSize];
    } else {
        
        buttonSize = [self.buttonCalculatedSize CGSizeValue];
    }
    
    NSUInteger rowForIndex = index / self.columns;
    NSUInteger columnForIndex = index % self.columns;
    NSInteger x = (columnForIndex * self.paddingBetweenButtons) + (columnForIndex * buttonSize.width);
    NSInteger y = (rowForIndex * self.paddingBetweenButtons) + (rowForIndex * buttonSize.height);
    
    CGRect buttonFrame;
    buttonFrame.size = buttonSize;
    buttonFrame.origin = CGPointMake(x, y);
    
    return buttonFrame;
    
}

#pragma mark Button Actions

- (void)buttonPressed:(UIButton *)sender {
    
    NSAssert(self.delegate != nil, @"You must define a HRFBoardViewDelegate");
    
    NSUInteger index = [self.currentButtonsArray indexOfObject:sender];
    [self.delegate boardView:self didSelectButton:sender atIndex:index];
}


- (void)defineButtonStateCorrect:(BOOL)correct atIndex:(NSUInteger)index successBlock:(void (^)(void))successBlock failBlock:(void (^)(void))failBlock {
    
    NSAssert(index < self.currentButtonsArray.count, @"Index out of bounds at defineButtonStateCorrect: ");
    
    if (correct) {
        if (successBlock) {
            successBlock();
        }
        
    } else {
        UIButton *theButton = [self.currentButtonsArray objectAtIndex:index];
        theButton.enabled = NO;
        [theButton.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        POPBasicAnimation *scaleUp = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleUp.duration = 0.2;
        scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
        [theButton.layer pop_addAnimation:scaleUp forKey:@"popScaleUp"];
        
        scaleUp.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            NSLog(@"Animation has completed.");
            POPBasicAnimation *scaleD = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            scaleD.toValue = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
            scaleD.duration = 0.1;
            scaleD.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [theButton.layer pop_addAnimation:scaleD forKey:@"popScaleD"];
        };
        
        if (failBlock) {
            failBlock();
        }
        
    }
    
}


@end
