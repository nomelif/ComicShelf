#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include "fio.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<FIO>("com.comicshelf.fio", 1, 0, "FIO");


    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}
