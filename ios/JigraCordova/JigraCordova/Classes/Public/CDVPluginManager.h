//
//  CDVPluginManager.h
//  JigraCordova
//

#import <Foundation/Foundation.h>
#import "CDVPlugin.h"
#import "CDVConfigParser.h"
#import "CDVCommandDelegate.h"

@interface CDVPluginManager : NSObject

@property (nonatomic, strong) NSMutableDictionary * pluginsMap;
@property (nonatomic, strong) NSMutableDictionary * pluginObjects;
@property (nonatomic, strong) NSMutableDictionary * settings;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) id <CDVCommandDelegate> commandDelegate;

- (id)initWithParser:(CDVConfigParser*)parser viewController:(UIViewController*)viewController webView:(WKWebView *)webview;
- (CDVPlugin *)getCommandInstance:(NSString*)pluginName;

@end
