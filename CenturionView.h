#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <EventKit/EventKit.h>
#import <objc/runtime.h>

@interface CenturionView : UIView
-(NSArray*)calendarEntriesBetweenStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime;
-(int)getNotif:(NSString *)bundleID;
-(IBAction)staypressed:(id)sender;
-(void)updateNotif;
@end

@interface UIImage (Private)
+(id)_applicationIconImageForBundleIdentifier:(NSString*)displayIdentifier format:(int)form scale:(CGFloat)scale;
@end


@interface SBUIController : NSObject
+(id)sharedInstance;
-(int)batteryCapacityAsPercentage;
-(int)displayBatteryCapacityAsPercentage; // Older API.
-(void)_toggleSwitcher;
@end

@interface SBIconModel : NSObject
-(NSArray*)visibleIconIdentifiers;

@end

@interface SBIconViewMap : NSObject
+(instancetype)homescreenMap; // Not in 9.3!
-(SBIconModel*)iconModel;
@end

@interface SBIconController : NSObject
+(instancetype)sharedInstance;
@property(readonly, nonatomic) SBIconViewMap *homescreenIconViewMap;
@end

@interface SBApplication : NSObject
-(void)setBadge:(id)arg1;
-(id)badgeNumberOrString;
-(id)displayName;
-(id)badgeValue;
@end

@interface SBApplicationController : NSObject
+(instancetype)sharedInstance;
-(SBApplication*)applicationWithBundleIdentifier:(NSString *)identifier;
@end

@interface SBIconBadgeView : UIView
@end

@interface LSApplicationWorkspace : NSObject
-(BOOL)openApplicationWithBundleID:(id)arg1;
+(id)defaultWorkspace;
@end

@interface UIApplication ()  
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;  
@end

