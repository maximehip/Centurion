#import <UIKit/UIKit.h>
#import <AppList/AppList.h>
#import "CenturionView.h"

@interface NCNotificationListCollectionView : UICollectionView
@end

@interface NCNotificationListViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@end

static CenturionView *centurionView;

%hook NCNotificationListCollectionView

-(void)setFrame:(CGRect)arg1 {
	arg1 = CGRectMake(arg1.origin.x, 170, arg1.size.width, arg1.size.height);
	if (!centurionView) {
		centurionView = [[CenturionView alloc] initWithFrame:CGRectMake(7, -80, [UIScreen mainScreen].bounds.size.width / 1.07, [UIScreen mainScreen].bounds.size.height / 7)];
		[self addSubview:centurionView];
	}
	%orig(arg1);
}

%end