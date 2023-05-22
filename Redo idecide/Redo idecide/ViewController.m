//
//  ViewController.m
//  Redo idecide
//
//  Created by csuftitan on 3/12/23.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *answers;
    int answerIndex;
    int lastAnswerIndex;
    BOOL questionShowing;
    
}

-(int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex;

@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

@synthesize button=button;

#pragma mark - Action Items

- (IBAction)buttonPressed:(id)sender {
    if (questionShowing){
        int count = (int)[answers count];
        
        BOOL
    }
    
    
}

-(int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex{
    
    return lowerIndex + arc4random() % (upperIndex - lowerIndex);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
