ARCHS = arm64
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = App
App_FILES = Tweak.x
App_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk