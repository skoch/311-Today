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
@synthesize todayStatus, tomorrowStatus, todayDate, tomorrowDate;
@synthesize todaysDate, tomorrowsDate;

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

- (void)loadRSS:( NSString * )url
{
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData
{
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
	
	//ASCII Method
//    NSString *result= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
    //UTF8 Method
    NSString *result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSData *xmldata = [result dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmldata];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];	
    
	[parser parse];
    [parser release];
	
	
	NSArray *parts = [[self status] componentsSeparatedByString:@"<br />"];
//	NSLog(@"parts = %@", parts);
	
	
//	NSLog(@"status = %@", [self status]);
//	[NSString stringWithFormat:parts[1]]
//	[NSString stringWithFormat:@"%@", parts[1]]
//	NSString parts[1]
	
//	for( int i = 0; i < [parts count]; i++ )
//	{
//		if( [parts[i] rangeOfString:@"suspended"].location == NSNotFound )
//		{
//			
//		}else
//		{
//			
//		}		
//	}
	
	
	int i = 0;
	for( NSString *part in parts )
	{
//		NSLog(@"part = %@", part);
		if( [part rangeOfString:@"suspended"].location == NSNotFound )
		{
			if( i == 0 )
			{
				NSArray *dateParts = [part componentsSeparatedByString:@"<B>"];
				NSArray *moreDateParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@"</B>"];
				self.todaysDate = [moreDateParts objectAtIndex:0];
			}
			
			if( i == 3 )
			{
				NSArray *dateParts = [part componentsSeparatedByString:@"<B>"];
				NSArray *moreDateParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@"</B>"];
				self.tomorrowsDate = [moreDateParts objectAtIndex:0];
			}
			
			if ( i == 1 )
			{
				// move the car
				todayDate.text = [NSString stringWithFormat:@"%@", self.todaysDate];
				todayStatus.text = @"Move the car";
			}else if( i == 4 )
			{
				tomorrowDate.text = [NSString stringWithFormat:@"%@", self.tomorrowsDate];
				tomorrowStatus.text = @"Move the car";
			}
		}else
		{
			if( i == 1 )
			{
				todayDate.text = [NSString stringWithFormat:@"%@", self.todaysDate];
				todayStatus.text = @"Free day!";
			}else if( i == 4 )
			{
				tomorrowDate.text = [NSString stringWithFormat:@"%@", self.tomorrowsDate];
				tomorrowStatus.text = @"Free day!";
			}
		}
		i++;
	}
			
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
//    NSLog(@"Document started", nil);
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
