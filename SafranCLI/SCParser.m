//
//  SCParser.m
//  SafranCLI
//
//  Created by Said on 08/08/2014.
//
//
#include <stdio.h>
#import "SCParser.h"
#define MAXFEED 15

#define kOutputTextColorGreen   "\x1b[32m"
#define kOutputTextColorBlue    "\x1b[34m"
#define kOutputTextColorReset   "\x1b[0m"

@interface SCParser ()
{
    NSXMLParser *parseManager;
    NSString *elementKey;
    NSMutableString *elementTitle;
    NSMutableString *elementLink;
    NSMutableArray *wholeFeed;
    NSMutableDictionary *feedObject;
    int count;
}
@end
@implementation SCParser
#pragma mark - Lifecycle
- (id) initWithURL: (NSString *)url
{
	self = [super init];
	if (self)
	{
        count = MAXFEED;
		parseManager = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
		[parseManager setDelegate:self];
        
        wholeFeed = [[NSMutableArray alloc] init];
	}
	return self;
}
- (void)parse
{
    [parseManager parse];
}
#pragma mark - NSXMLParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if (count > 0)
    {
        elementKey = [elementName copy];
        if ([elementName isEqualToString:@"item"])
        {
            feedObject = [[NSMutableDictionary alloc] init];
            elementTitle = [[NSMutableString alloc] init];
            elementLink = [[NSMutableString alloc] init];
            count--;
        }
    }
    else
    {
        [parseManager abortParsing];
        [self parsingFinished];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([elementKey isEqualToString:@"title"])
    {
        [elementTitle appendString:string];
    }
    else if([elementKey isEqualToString:@"link"])
    {
        [elementLink appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        [feedObject setObject:elementTitle forKey:@"title"];
        [feedObject setObject:elementLink forKey:@"link"];
        [wholeFeed addObject:[feedObject copy]];
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if( 512 == parseError.code )
    {
        // Couldn't complete error.
    }
    else
    {
        NSLog(@"Error while parsing feed. Sorry.");
    }
}

-(void)parsingFinished
{
    for(NSMutableDictionary *obj in wholeFeed)
    {
        printf(kOutputTextColorGreen "- %s",[[obj valueForKey:@"title"] UTF8String]);
        printf(kOutputTextColorBlue "%s \n",[[obj valueForKey:@"link"] UTF8String]);
    }
}
@end