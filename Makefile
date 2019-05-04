THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
FINALPACKAGE=1
ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Centurion
Centurion_FILES = CenturionView.xm Tweak.xm
Centurion_FRAMEWORK = UIKit
Centurion_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += centurion
include $(THEOS_MAKE_PATH)/aggregate.mk
