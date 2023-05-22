//
//  DetailViewController.h
//  drinkmixer
//
//  Created by William McCarthy on 2/16/23.
//


#import <UIKit/UIKit.h>
#import "DrinkConstants.h"


//NS_ASSUME_NONNULL_BEGIN


@interface DetailViewController : UIViewController {
  UITextField* drinkName;
  UITextView* ingredients;
  UITextView* directions;
  
  NSDictionary *drink;
}

@property (strong, nonatomic) IBOutlet UITextField *drinkName;
@property (strong, nonatomic) IBOutlet UITextView *ingredients;
@property (strong, nonatomic) IBOutlet UITextView *directions;

@property (strong, retain) NSDictionary* drink;

@end


//NS_ASSUME_NONNULL_END

