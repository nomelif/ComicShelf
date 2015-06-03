#ifndef FIO_H
#define FIO_H

#include <QObject>


class FIO : public QObject
{
    Q_OBJECT
public:
    explicit FIO(QObject *parent = 0);

signals:
    void finished();

public slots:

    QString getPrevPage(QString comic);

};
#endif // FIO_H
