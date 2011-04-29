//
//  MainViewController.h
//  NYCParking
//
//  Created by Stephen Koch on 4/25/11.
//  Copyright 2011 Big Spaceship. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, NSXMLParserDelegate> {
	NSURLConnection *connection;
	NSMutableData* data;
	NSMutableString *status;
	NSString *todaysDate;
	NSString *tomorrowsDate;
	IBOutlet UILabel *todayStatus;
	IBOutlet UILabel *tomorrowStatus;
	IBOutlet UILabel *todayDate;
	IBOutlet UILabel *tomorrowDate;
	
@private
	NSInteger depth;
	NSString *currentElement;
	
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSMutableString *status;
@property (nonatomic, retain) NSString *todaysDate;
@property (nonatomic, retain) NSString *tomorrowsDate;
@property(nonatomic, retain) IBOutlet UILabel *todayStatus;
@property(nonatomic, retain) IBOutlet UILabel *tomorrowStatus;
@property(nonatomic, retain) IBOutlet UILabel *todayDate;
@property(nonatomic, retain) IBOutlet UILabel *tomorrowDate;

- (IBAction)showInfo:(id)sender;
- (void)loadRSS:(NSString *)url;
- (void)update;

@end