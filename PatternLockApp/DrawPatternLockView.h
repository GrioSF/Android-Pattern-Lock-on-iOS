//
//  DrawPatternLockView.h
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPatternLockView : UIView {
  NSValue *_trackPointValue;
  NSMutableArray *_dotViews;
}


- (void)clearDotViews;
- (void)addDotView:(UIView*)view;
- (void)drawLineFromLastDotTo:(CGPoint)pt;
@end
