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
	UIWebView *webView;
	
@private
	NSInteger depth;
	NSString *currentElement;
	
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableString* status;
@property (nonatomic, retain) UIWebView* webView;

- (IBAction)showInfo:(id)sender;
- (void)loadRSS:(NSString *)url;
- (void)update;
- (void)removeWebView;
@end