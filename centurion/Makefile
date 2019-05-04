SYSROOT = $(THEOS)/sdks/iPhoneOS9.2.sdk
ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Centurion
Centurion_FILES = CTRRootListController.m
Centurion_INSTALL_PATH = /Library/PreferenceBundles
Centurion_FRAMEWORKS = UIKit
Centurion_PRIVATE_FRAMEWORKS = Preferences
Centurion_LIBRARIES = applist
Centurion_EXTRA_FRAMEWORKS += CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Centurion.plist$(ECHO_END)
