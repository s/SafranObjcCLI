//
//  SCParser.h
//  SafranCLI
//
//  Created by Said on 08/08/2014.
//
//

@interface SCParser : NSObject <NSXMLParserDelegate>

- (id)initWithURL: (NSString *)url;
- (void)parse;
@end
