//
//  Macros.h

///////////////////////////////////////////
// Debugging
///////////////////////////////////////////
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

///////////////////////////////////////////
// App
///////////////////////////////////////////

#define APP_VERSION [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

///////////////////////////////////////////
// Views
///////////////////////////////////////////
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

///////////////////////////////////////////
// Device & OS
///////////////////////////////////////////

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Is4Inches() ([[UIScreen mainScreen] bounds].size.height == 568)
#define Is3_5Inches() ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


///////////////////////////////////////////
// Random
///////////////////////////////////////////
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

///////////////////////////////////////////
// Networking
///////////////////////////////////////////
#define IsConnected() !([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

///////////////////////////////////////////
// Misc
///////////////////////////////////////////
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]
