//
//  NYCParkingAppDelegate.h
//  NYCParking
//
//  Created by Stephen Koch on 4/25/11.
//  Copyright 2011 Big Spaceship. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface NYCParkingAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
