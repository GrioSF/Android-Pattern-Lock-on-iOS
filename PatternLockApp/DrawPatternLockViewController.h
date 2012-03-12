//
//  ViewController.h
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPatternLockViewController : UIViewController {
  NSMutableArray* _paths;
  
  // after pattern is drawn, call this:
  id _target;
  SEL _action;
}

// get key from the pattern drawn
- (NSString*)getKey;

- (void)setTarget:(id)target withAction:(SEL)action;


@end
