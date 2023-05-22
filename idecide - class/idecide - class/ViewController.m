//
//  ViewController.m
//  idecide - class
//
//  Created by csuftitan on 1/30/23.
//

#import "ViewController.h"
//
@interface ViewController (){
    NSMutableArray* answers;
    int answerIndex;
    int lastAnswerIndex;
    BOOL questionShowing;
}

-(int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex;

//@property (strong, nonatomic) IBOutlet UIButton *decisionText;
@property (strong, nonatomic) IBOutlet UILabel *decisionText;
@property (getter=lengthGet, setter=lengthSet:) int length;

@end

@implementation ViewController

@synthesize decisionText=decisionText;

#pragma mark - Action Items

- (IBAction)buttonPressed:(id)sender {
    if (questionShowing){
        int count = (int)[answers count];
        
        BOOL newAnswer = false;
        while(!newAnswer){
            answerIndex = [self generateRandomNumberWithLower:0 andUpper: count];
            newAnswer = answerIndex != lastAnswerIndex;
        }
        lastAnswerIndex = answerIndex;
        decisionText.text = answers[answerIndex];
        NSLog(@"index is: %i\n", answerIndex);
        NSString *name = @"Mike";
        NSLog(@"%@", name);
        NSString *string = @"777";
        int variable = [string integerValue];
        NSLog(@"%d", variable);
        NSLog(@"%@,", answers);
    }else {
        decisionText.text = @"What should I do?";
    }
    questionShowing = !questionShowing;
}

-(int)generateRandomNumberWithLower:(int)lowerIndex andUpper:(int)upperIndex{
    return lowerIndex + arc4random() % (upperIndex - lowerIndex);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    questionShowing = true;
    answerIndex = 0;
    
    answers = [NSMutableArray arrayWithObjects:@"Go for it!", @"Unclear at this time.", @"Sleep on it.", @"Ask the Oracle.", nil];
}


//-(void)dealloc {
//    [decisionText release];
//    [super dealloc];
//}


@end
