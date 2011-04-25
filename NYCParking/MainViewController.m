//
//  MainViewController.m
//  NYCParking
//
//  Created by Stephen Koch on 4/25/11.
//  Copyright 2011 Big Spaceship. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController


@synthesize connection;
@synthesize data;
@synthesize status;
@synthesize webView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self update];
}


- (void)update
{
	[self loadRSS:@"http://www.nyc.gov/apps/311/311Today.rss"];
}

- (void)removeWebView
{
	[self.webView removeFromSuperview];
	self.webView = nil;
}

- (void)loadRSS:( NSString * )url
{
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	//ASCII Method
//    NSString *result= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
    //UTF8 Method
    NSString *result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSData *xmldata = [result dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmldata];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];	
    
	[parser parse]; // Parse that data..
    [parser release];
	
//	output.text = [NSString stringWithFormat:@"%@", [self status]];
	
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, 320, 400)];
	
	for (id subview in webView.subviews)
		if ([[subview class] isSubclassOfClass: [UIScrollView class]])
			((UIScrollView *)subview).bounces = NO;
	
//	[webView setAllowsRubberBanding:NO];
    NSString *htmlString = [NSString stringWithFormat:@"<style type=\"text/css\">body{color:#3F3F3F;font-family:Georgia,serif;font-size:12pt;}</style>%@", [NSString stringWithFormat:@"%@", [self status]]];
    [webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:webView];
	
	NSLog(@"html = %@", htmlString);
	
	data = nil;
}
//

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    NSLog(@"Document started", nil);
    depth = 0;
    currentElement = nil;
	status = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
	[currentElement release];
	currentElement = [elementName copy];
//	NSLog(@"currentElement = %@", currentElement);
	
//    if ([currentElement isEqualToString:@"rss"])
//    {
//		NSLog( @"hit RSS node A" );
//        ++depth;
//        [self showCurrentDepth];
//    }
//    else if ([currentElement isEqualToString:@"channel"])
//    {
//        [currentName release];
//        currentName = [[NSMutableString alloc] init];
//		NSLog( @"currentName, %@", currentName );
//    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	
//    if ([elementName isEqualToString:@"rss"]) 
//    {
//		NSLog( @"hit RSS node B" );
//        --depth;
//        [self showCurrentDepth];
//    }
//    else if ([elementName isEqualToString:@"channel"])
//    {
//        if (depth == 1)
//        {
//            NSLog(@"Outer name tag: %@", currentName);
//        }
//        else 
//        {
//            NSLog(@"Inner name tag: %@", currentName);
//        }
//    }
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"encoded"]) 
	{
		[[self status] appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
//    NSLog(@"Document finished", nil);
//	NSLog( @"status: %@", [self status] );
}



@end
