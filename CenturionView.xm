#import "CenturionView.h"

NSString *name;

%ctor {
	HBPreferences *preferences;
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.maximehip.centurion"];

    [preferences registerObject:&name default:nil forKey:@"name"];
}

@implementation CenturionView

static UIView *centurionView = nil;
bool dropped = false;
static EKEventStore *store;
NSMutableArray* result = [NSMutableArray array];
NSMutableArray *labelArray = [NSMutableArray array];


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
    	centurionView = [[UIView alloc] initWithFrame:frame];
        centurionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        centurionView.hidden = NO;
        centurionView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor;
        centurionView.layer.borderWidth = 1.0f;
        centurionView.layer.cornerRadius = 20;
        centurionView.layer.masksToBounds = YES;

        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];        
        visualEffectView.frame = centurionView.bounds;
        [centurionView addSubview:visualEffectView];

        UILabel *helloText = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 343, 27)];
        helloText.text = [NSString stringWithFormat:@"Hello %@", name];
        [helloText setFont:[UIFont boldSystemFontOfSize:20]];
        helloText.textColor = [UIColor whiteColor];
        [centurionView addSubview:helloText];

        UILabel *calendarEvent = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 343, 27)];
        NSDate* date = [NSDate date];
        
        NSDate* date2 = [NSDate date];
        NSDateComponents* comps = [[NSDateComponents alloc]init];
        comps.day = 1;
        NSCalendar* calendar2 = [NSCalendar currentCalendar];
        NSDate* tomorrow = [calendar2 dateByAddingComponents:comps toDate:date2 options:nil];

		NSArray *events = [self calendarEntriesBetweenStartTime:date andEndTime:tomorrow];
		calendarEvent.textColor = [UIColor whiteColor];
		if ([events count] == 0) {
			calendarEvent.text = @"No event today";
		} else {
            calendarEvent.text = [NSString stringWithFormat:@"%lu events today", (unsigned long)[events count]];
		}
		//calendarEvent.font = [calendarEvent.font fontWithSize:21];
		[centurionView addSubview:calendarEvent];

		NSDictionary *theDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.maximehip.centurion.plist"];
		for (NSString* key in theDict) {
			if ([key hasPrefix:@"apps"]) {
				if ([[theDict valueForKey:key] boolValue]) {
	    			[result addObject:key];
	    		}
	  		}	
		}
		int i = 30;
		int j = 60;
		int k = 64;
		int tag = 0;
        labelArray = [[NSMutableArray alloc] init];
		for (NSString *key in result) {
			key = [key stringByReplacingOccurrencesOfString:@"apps-" withString:@""];
			int count = [self getNotif:key];

			UIButton *icons = [UIButton buttonWithType:UIButtonTypeCustom];
			[icons setFrame:CGRectMake(i, 65, 40, 40)];
       		[icons setImage:[UIImage _applicationIconImageForBundleIdentifier:key format:2 scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
       		[icons addTarget:self action:@selector(staypressed:) forControlEvents:UIControlEventTouchUpInside];
  			icons.tag = tag;
        	[centurionView addSubview:icons];
        	i = i + 70;
        	tag++;

        	if (count > 0) {
	        	CAShapeLayer *circleLayer = [CAShapeLayer layer];
				[circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(j, 55, 20, 20)] CGPath]];
				[circleLayer setFillColor:[[UIColor redColor] CGColor]];
				[[centurionView layer] addSublayer:circleLayer];

				UILabel *notificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(k, 50, 343, 27)];
				notificationLabel.text = [NSString stringWithFormat:@"%i", count];
	        	[notificationLabel setFont:[UIFont boldSystemFontOfSize:10]];
	        	notificationLabel.textColor = [UIColor whiteColor];
	        	[centurionView addSubview:notificationLabel];
                [labelArray addObject:notificationLabel];
        	}
			j = j + 70;
			k = k + 71;
		}
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateNotif) userInfo:nil repeats:YES];
//		[self getNotif];

    	[self addSubview:centurionView];
    }
    return self;
}

-(NSArray*)calendarEntriesBetweenStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime {
    NSMutableArray *searchableCalendars = [[store calendarsForEntityType:EKEntityTypeEvent] mutableCopy];
    
    NSPredicate *predicate = [store predicateForEventsWithStartDate:startTime endDate:endTime calendars:searchableCalendars];

    NSMutableArray *events = [NSMutableArray arrayWithArray:[store eventsMatchingPredicate:predicate]];
    
    CFPreferencesAppSynchronize(CFSTR("com.apple.mobilecal"));
    
    NSDictionary *settings = (__bridge NSDictionary *)CFPreferencesCopyMultiple(CFPreferencesCopyKeyList(CFSTR("com.apple.mobilecal"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost), CFSTR("com.apple.mobilecal"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    NSArray *deselected = settings[@"LastDeselectedCalendars"];
    
    for (EKEvent *event in [events copy]) {
        if ([deselected containsObject:event.calendar.calendarIdentifier]) {
            [events removeObject:event];
        }
    }
    
    return events;
}

-(IBAction)staypressed:(id)sender {
	NSMutableArray *apps = [NSMutableArray array];
    UIButton *button = (UIButton *)sender;

	for (NSString *key in result) {
		key = [key stringByReplacingOccurrencesOfString:@"apps-" withString:@""];
		[apps addObject:key];
	}
    int tag = button.tag;
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:[apps objectAtIndex: tag] suspended:NO];
 }

-(int)getNotif:(NSString *)bundleID {
    SBIconViewMap *map = nil;

    map = [[objc_getClass("SBIconController") sharedInstance] homescreenIconViewMap];
    NSArray *appIcons = [[map iconModel] visibleIconIdentifiers];
    for (NSString *identifier in appIcons) {
        if ([identifier isEqual:bundleID]) {
            SBApplication *app = nil;
            id cls = [objc_getClass("SBApplicationController") sharedInstance];
            app = [cls applicationWithBundleIdentifier:identifier];
            id badge = [app badgeValue];
            return [badge intValue];
        }
    }
    return 0;
}

-(void)updateNotif {
    int count = 0;
    NSMutableArray *apps = [NSMutableArray array];
    for (NSString *key in result) {
        key = [key stringByReplacingOccurrencesOfString:@"apps-" withString:@""];
        if ([self getNotif:key] > 0) {
            [apps addObject:key];
        }
    }
    int i = 0;
    for (UILabel *label in labelArray) {
        count = [self getNotif:apps[i]];
        label.text = [NSString stringWithFormat:@"%i", count];
        i++;
    }
}

@end