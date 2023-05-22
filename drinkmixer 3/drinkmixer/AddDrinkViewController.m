//
//  AddDrinkViewController.m
//  drinkmixer
//
//  Created by William McCarthy on 2/22/23.
//

#import "ViewController.h"
#import "AddDrinkViewController.h"


@interface AddDrinkViewController() {
  
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end



@implementation AddDrinkViewController

@synthesize drinks=drinks, scrollView=scrollView;

//-------------------------------------------------------------------------
#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
    
  self.scrollView.contentSize = self.view.frame.size;

  self.navigationItem.leftBarButtonItem
      = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
      target:self
      action:@selector(cancel:)];
  self.navigationItem.rightBarButtonItem
      = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemSave
      target:self
      action:@selector(save:)];
    
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"Registering for keyboard events");

  [[NSNotificationCenter defaultCenter]
      addObserver:self
      selector:@selector(keyboardDidShow:)
      name:UIKeyboardDidShowNotification
      object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
      selector:@selector(keyboardDidHide:)
      name:UIKeyboardDidShowNotification
      object:nil];
  keyboardVisible = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
  NSLog(@"Unregistering for keyboard events");
  [[NSNotificationCenter defaultCenter]
   removeObserver:self];
}


//------------------------------------------------------------------------
#pragma mark - Keyboard Handlers

- (void)keyboardDidShow:(NSNotification *)notif {
  NSLog(@"Received UIKeyboardDidShowNotification !!!!!!!!!!!!!!!!!!!!!!!!!");
  if (keyboardVisible) {
    NSLog(@"Keyboard is already visible... Ignoring notification");
    return;
  }
  NSLog(@"Resizing smaller for keyboard");
  NSDictionary *info = [notif userInfo];
  NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];

  CGRect keyboardRect = [aValue CGRectValue];
  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  CGFloat keyboardTop = keyboardRect.origin.y;

  CGRect viewFrame = self.view.bounds;
  viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;

//  self.scrollView.frame = viewFrame;
  keyboardVisible = YES;
}

- (void)keyboardDidHide:(NSNotification *)notif {
  NSLog(@"Received UIKeyboardDidHideNotification");
  if (!keyboardVisible) {
    NSLog(@"Keyboard already hidden... Ignoring notification");
    return;
  }
  NSLog(@"Resizing bigger with no keyboard");
//  self.scrollView.frame = self.view.bounds;
  keyboardVisible = NO;
}

#pragma mark - Action Items save and cancel

- (IBAction)save:(id)sender {
  NSLog(@"Save pressed!");

  if (self.drink != nil) {
    // working with existing drink -- remove it, then create new (edited) one
    [self.drinks removeObject:self.drink];
    self.drink = nil;
  }

  NSMutableDictionary *newDrink = [[NSMutableDictionary alloc] init];

  UITextField *name = self.drinkName;
  UITextView *ing = self.ingredients;
  UITextView *dir = self.directions;

  NSString *namey = name.text;
  NSString *ingy = ing.text;
  NSString *diry = dir.text;

  [newDrink setValue:namey forKey:NAME_KEY];
  [newDrink setValue:ingy forKey:INGREDIENTS_KEY];
  [newDrink setValue:diry forKey:DIRECTIONS_KEY];

//  NSString *drinkName = name.text;
//  [newDrink setValue:drinkName forKey:NAME_KEY];
//  [newDrink setValue:[super.drink.drinkName].text forKey:NAME_KEY];

//  [newDrink setValue:[super.drink.drinkName].text forKey:NAME_KEY];
//  [newDrink setValue:[super.drink.ingredients].text forKey:INGREDIENTS_KEY];
//  [newDrink setValue:[super.drink.directions].text forKey:DIRECTIONS_KEY];

  NSLog(@"newDrink is: %@", newDrink);
  
  [drinks addObject:newDrink];

  NSSortDescriptor *nameSorter
      = [[NSSortDescriptor alloc] initWithKey:NAME_KEY
                                  ascending:YES
                                  selector:@selector(caseInsensitiveCompare:)];

  [drinks sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNotification" object:self];

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
  NSLog(@"Cancel pressed!");
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end

