//
//  ViewController.m
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawPatternLockViewController.h"
#import "DrawPatternLockView.h"

#define MATRIX_SIZE 3

@implementation DrawPatternLockViewController




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
  [super loadView];
  
  self.view = [[DrawPatternLockView alloc] init];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor darkGrayColor];

  for (int i=0; i<MATRIX_SIZE; i++) {
    for (int j=0; j<MATRIX_SIZE; j++) {
      UIImage *dotImage = [UIImage imageNamed:@"dot_off.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                 highlightedImage:[UIImage imageNamed:@"dot_on.png"]];
      imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
      imageView.userInteractionEnabled = YES;
      imageView.tag = j*MATRIX_SIZE + i + 1;
      [self.view addSubview:imageView];
    }
  }
}


- (void)viewWillLayoutSubviews {
  int w = self.view.frame.size.width/MATRIX_SIZE;
  int h = self.view.frame.size.height/MATRIX_SIZE;

  int i=0;
  for (UIView *view in self.view.subviews)
    if ([view isKindOfClass:[UIImageView class]]) {
      int x = w*(i/MATRIX_SIZE) + w/2;
      int y = h*(i%MATRIX_SIZE) + h/2;
      view.center = CGPointMake(x, y);
      i++;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  _paths = [[NSMutableArray alloc] init];
}



- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:self.view];
  UIView *touched = [self.view hitTest:pt withEvent:event];
  
  DrawPatternLockView *v = (DrawPatternLockView*)self.view;
  [v drawLineFromLastDotTo:pt];

  if (touched!=self.view) {
    NSLog(@"touched view tag: %d ", touched.tag);
    
    BOOL found = NO;
    for (NSNumber *tag in _paths) {
      found = tag.integerValue==touched.tag;
      if (found)
        break;
    }
    
    if (found)
      return;

    [_paths addObject:[NSNumber numberWithInt:touched.tag]];
    [v addDotView:touched];

    UIImageView* iv = (UIImageView*)touched;
    iv.highlighted = YES;
  }

}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // clear up hilite
  DrawPatternLockView *v = (DrawPatternLockView*)self.view;
  [v clearDotViews];

  for (UIView *view in self.view.subviews)
    if ([view isKindOfClass:[UIImageView class]])
      [(UIImageView*)view setHighlighted:NO];
  
  [self.view setNeedsDisplay];
  
  // pass the output to target action...
  if (_target && _action)
    [_target performSelector:_action withObject:[self getKey]];
}


// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString*)getKey {
  NSMutableString *key;
  key = [NSMutableString string];

  // simple way to generate a key
  for (NSNumber *tag in _paths) {
    [key appendFormat:@"%02d", tag.integerValue];
  }
  
  return key;
}


- (void)setTarget:(id)target withAction:(SEL)action {
  _target = target;
  _action = action;
}

@end
