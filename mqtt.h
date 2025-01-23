#ifndef MQTT_H
#define MQTT_H

#include <QObject>
#include <QtMqtt/QMqttClient>

class mqtt : public QObject
{
    Q_OBJECT
public:
    explicit mqtt(QObject *parent = nullptr);
    Q_INVOKABLE void connectToHost(
        const QString &hostname,
        int port,
        const QString &username,
        const QString &password,
        const QString &topic);

    Q_INVOKABLE void disconnectFromHost();
    bool isConnected() const;

signals:
    void connectionStatusChanged(const QString &status, bool connected);
    void messageReceived(const QString &topic, const QString &message);

private slots:
    void onConnected();
    void onDisconnected();
    void onMessageReceived(const QByteArray &message, const QMqttTopicName &topic);

private:
    QMqttClient *m_client;
    QString m_topic;

};

#endif // MQTT_H
