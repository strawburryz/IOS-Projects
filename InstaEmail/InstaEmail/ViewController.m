//
//  ViewController.m
//  InstaEmail
//
//  Created by csuftitan on 2/1/23.
//

#import "ViewController.h"

@interface ViewController (){
    UIPickerView* emailpicker;
    NSArray* activities;
    NSArray* feelings;
    UITextField* notesField;
}
@property (strong, nonatomic) IBOutlet UIPickerView *emailpicker;
@property (strong, nonatomic) IBOutlet UITextField *notesField;

@end

@implementation ViewController

//@synthesize activities = activities;
//@synthesize feelings = feelings;

@synthesize notesField=notesField;
@synthesize emailpicker=emailpicker;


- (void)viewDidLoad {
    [super viewDidLoad];
    activities = [[NSArray alloc] initWithObjects:@"sleeping", @"eating", @"crying", @"showering", @"running", @"painting", @"swimming", @"singing", @"reading", @"cooking",  nil];
    feelings = [[NSArray alloc] initWithObjects:@"awesome", @"sad", @"happy", @"ambivalent", @"nauseous", @"psyched", @"confused", @"hopeful", @"anxious", @"excited", nil];
}


#pragma mark - PickerDataSource Protocol

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0? [activities count] : [feelings count];
}

#pragma mark - PickerDelegate Protocol

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component > 1){ return nil;}
    return [(component == 0 ? activities : feelings) objectAtIndex:row];
}

- (IBAction)sendPressed:(id)sender {
    NSLog(@"send button pressed");
    NSNumber* aNumber = [NSNumber numberWithInteger:999];
    NSLog(@"%@", aNumber);
    
    NSLog(@"%@",@"is the way");
    
    NSString* desc = [aNumber description];
    NSLog(@"%@", desc);
    NSString *activity = [activities objectAtIndex:[emailpicker selectedRowInComponent:0]];
    NSString *feeling = [feelings objectAtIndex: [emailpicker selectedRowInComponent:1]];
    
    NSString *notes = [notesField text];
    
    NSString* theMessage = [NSString stringWithFormat:@"%@ I'm %@ and feeling %@ about it!", notes, activity, feeling];
    
    NSLog(@"%@", theMessage);
    
    if(![MFMailComposeViewController canSendMail]){
        NSLog(@"%@", @"Sorry, you need set up the mail first!");
        return;
    }
MFMailComposeViewController* mailController =[[MFMailComposeViewController alloc]init];
mailController.mailComposeDelegate = self;
[mailController setToRecipients:[[NSArray alloc] initWithObjects:@"vjparry414@gmail.com", nil]];
[mailController setSubject:@"Hello Victoria!"];
[mailController setMessageBody:theMessage isHTML:NO];
[self presentViewController:mailController animated:YES completion:nil];
//        [mailController release];
}

- (IBAction)doneEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

#pragma mark - Mail composer delegate method

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
