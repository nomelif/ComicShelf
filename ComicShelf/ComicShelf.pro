TEMPLATE = app
TARGET = ComicShelf

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp \
    fio.cpp

RESOURCES += ComicShelf.qrc

OTHER_FILES += ComicShelf.apparmor \
               ComicShelf.desktop \
               ComicShelf.png

#specify where the config files are installed to
config_files.path = /ComicShelf
config_files.files += $${OTHER_FILES}
message($$config_files.files)
INSTALLS+=config_files

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
    fio.h

