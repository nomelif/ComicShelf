#include "fio.h"
#include <QFileInfo>
#include <QDebug>
#include <QDir>

FIO::FIO(QObject *parent) :
    QObject(parent)
{
}

QString FIO::getPrevPage(QString comic){

    QFileInfo checkFile(QDir::homePath()+"/.prevPage");
    qDebug() << checkFile.isFile();

    QString filename=QDir::homePath()+"/.prevPage";
    QFile file( filename );
    if ( file.open(QIODevice::ReadWrite) )
    {
        QTextStream stream( &file );
        stream << "something" << endl;
    }else{
        qDebug() << QDir::homePath();
    }

    if(comic == "Twokinds"){
        return QString("http://twokinds.keenspot.com/index.php");
    }else if(comic == "Freefall"){
        return QString("http://freefall.purrsia.com/");
    }else if(comic == "XKCD"){
        return QString("http://xkcd.com/info.0.json");
    }
    return QString("Error");
}
