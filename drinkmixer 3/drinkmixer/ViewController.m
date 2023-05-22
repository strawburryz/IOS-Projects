//
//  ViewController.m
//  drinkmixer
//
//  Created by William McCarthy on 2/13/23.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "DrinkConstants.h"
#import "AddDrinkViewController.h"


#pragma mark - ViewController interface

@interface ViewController () {
  IBOutlet UIBarButtonItem *addButton;
  NSMutableArray* drinks;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, retain) NSMutableArray* drinks;

@end



#pragma mark - ViewController implementation

@implementation ViewController

@synthesize tableView=tableView, drinks=drinks;


#pragma mark - View life cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
//  self.navigationItem.rightBarButtonItem = self.addButton;

  
  NSString* path = [[NSBundle mainBundle] pathForResource:@"DrinkDirections" ofType:@"plist"];
  drinks = [[NSMutableArray alloc] initWithContentsOfFile:path];
  
  // Do any additional setup after loading the view.
}

- (void)applicationDidEnterBackground:(NSNotification *)notif {
  NSString* path = [[NSBundle mainBundle] pathForResource:@"DrinkDirections" ofType:@"plist"];
  [drinks writeToFile:path atomically:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [drinks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//- (UITableViewCell *)tableView:(UITableView *)tableView
//                     cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.text = [[drinks objectAtIndex:indexPath.row] objectForKey:NAME_KEY];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  NSLog(@"%@", cell.textLabel.text);
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView
        canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"in didSelectViewRowAtIndexPath");
  
  if (!self.editing) {
//    DetailViewControl *detailVC =
//    [[DetailViewControl alloc] initWithNibName:@"DetailViewControl" bundle:nil];
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"DrinkDirections" ofType:@"plist"];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewControl"];
    
    detailVC.drink = [drinks objectAtIndex:indexPath.row];
//    NSLog(@"%@", [NSString stringWithFormat: @"drink in VC is %@\n", detailVC.drink]);
//    NSLog(@"%@", [NSString stringWithFormat: @"ingredients in VC is %@\n\n", [detailVC.drink objectForKey:INGREDIENTS_KEY]]);
    [self.navigationController pushViewController:detailVC animated:YES];
    //    [detailVC view];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
  }
}


#pragma mark - Table Editing

- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {

  [self setEditing:true animated:true];
  [[self tableView] reloadData];

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // delete the row from the data source
    [drinks removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
               withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // TODO: still to come
  }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:!editing];
}

#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender {
  NSLog(@"Add drink button pressed");
  
  AddDrinkViewController *addDrinkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addDrinkViewControl"];
  
  UINavigationController *addNavController = [[UINavigationController alloc] initWithRootViewController:addDrinkVC];

  addDrinkVC.drinks = drinks;
  
  NSLog(@"creating NSNotification for ReloadNotification");

  [[NSNotificationCenter defaultCenter]
      addObserver:self
      selector:@selector(receiveNotification:)
      name:@"ReloadNotification"
      object:nil];
  
  addDrinkVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//  [self presentViewController:addNavController animated:YES completion:nil];
  [self presentViewController:addNavController animated:YES completion:nil];

  NSLog(@"after presenting the addNavController");
}

@end
