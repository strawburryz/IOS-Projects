//
//  DetailViewController.m
//  drinkmixer
//
//  Created by William McCarthy on 2/16/23.
//

#import "DetailViewController.h"


#pragma mark - Detail View Controller Interface

@interface DetailViewController() { }

@end



@implementation DetailViewController

@synthesize drink=drink, drinkName=drinkName, ingredients=ingredients, directions=directions;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSLog(@"the detail view did load");
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //  NSLog(@"the detail view will appear");
  //  NSLog(@"%@", [NSString stringWithFormat: @"drink is %@\n", self.drink]);
  
//  NSString *drinkName = [self.drink objectForKey:NAME_KEY];
//  NSString *ingredients = [self.drink objectForKey:INGREDIENTS_KEY];
//  NSString *directions = [self.drink objectForKey:DIRECTIONS_KEY];
  //  NSLog(@"%@", [NSString stringWithFormat: @"name in DVC is %@\n", drinkName]);
  //  NSLog(@"%@", [NSString stringWithFormat: @"ingredients in DVC is %@\n", ingredients]);
  //  NSLog(@"%@", [NSString stringWithFormat: @"directions in DVC is %@\n", directions]);
  
//  self.drinkName.text = drinkName;
//  self.ingredients.text = ingredients;
//  self.directions.text = directions;
  
  self.drinkName.text = [self.drink objectForKey:NAME_KEY];
  self.ingredients.text = [self.drink objectForKey:INGREDIENTS_KEY];
  self.directions.text = [self.drink objectForKey:DIRECTIONS_KEY];
}

@end




