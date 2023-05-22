//
//  ViewController.m
//  iDecide 8 ball
//
//  Created by csuftitan on 1/28/23.
//

#import "ViewController.h"

@interface ViewController () {
  UILabel* decisionText;
    BOOL questionShowing;
    
    int answerIndex;
    NSArray * answers;
}

- (int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex;

@property (strong, nonatomic) IBOutlet UILabel *decisionText;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController
- (IBAction)buttonPresseed:(id)sender {
    
    if (questionShowing){
        int count = (int)[answers count];
        
        BOOL newAnswer = false;
        while (!newAnswer){
            answerIndex = [self generasteRandomNumberwithLower:0 andUpper: count];
            newAnswer = asnwerIndex != lastAnswerIndex;
        }
        lastAnswerIndex = answerIndex;
        decisionText.text = answers[answersIndex];
    } else {
        decisionText.text = @"what should I do?";
    }
    
    questionShowing = !questionShowing;
}
@synthesize decisionText=decisionText;

- (int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex {
  return lowerIndex + arc4random() % (upperIndex - lowerIndex);
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
    questionShowing = true;
    answerIndex = 0;
    
    answers = @[@"Go for it!", @"Sleep on it", @"Don't do it", @"Ask again later",
    @"Go for a run", @"Just wait", @"Walk your dog", @"Ask the oracle"];
  // Do any additional setup after loading the view.
}

#pragma mark - Action Items

- (IBAction)buttonPressed:(id)sender {
  NSLog(@"Button was pressed!");
    if (questionShowing)
    int count = (int)[answers count];    // answers is the NSMutableArray*
        answerIndex = [self generateRandomNumberWithLower:0 andUpper: count];
    
  decisionText.text = answers[answerIndex];
    
}

@end
