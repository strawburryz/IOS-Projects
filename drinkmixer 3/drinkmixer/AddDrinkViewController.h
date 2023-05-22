//
//  AddDrinkViewController.h
//  drinkmixer
//
//  Created by William McCarthy on 2/22/23.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"


//NS_ASSUME_NONNULL_BEGIN

@interface AddDrinkViewController : DetailViewController {
  NSMutableArray* drinks;
  BOOL keyboardVisible;

}

@property (strong, retain) NSMutableArray* drinks;

@end

//NS_ASSUME_NONNULL_END
