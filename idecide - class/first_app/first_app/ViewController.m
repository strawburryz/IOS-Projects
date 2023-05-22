//
//  ViewController.m
//  first_app
//
//  Created by csuftitan on 1/28/23.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@end


@implementation ViewController
@synthesize button=button;
- (IBAction)buttonPressed:(id)sender {
  NSLog(@"Button was pressed!");       // don't forget the @ sign!
  [button setTitle:@"Button was pressed" forState: UIControlStateNormal];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

@end
