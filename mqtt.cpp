#include "mqtt.h"

mqtt::mqtt(QObject *parent)
    : QObject(parent), m_client(new QMqttClient(this)) {

    // Connect signals
    connect(m_client, &QMqttClient::connected, this, &mqtt::onConnected);
    connect(m_client, &QMqttClient::disconnected, this, &mqtt::onDisconnected);
    connect(m_client, &QMqttClient::messageReceived, this, &mqtt::onMessageReceived);
    connect(m_client, &QMqttClient::errorChanged, this, [](QMqttClient::ClientError error) {
        qWarning() << "MQTT Error:" << error;
    });
}

// mqtt::~mqtt() {
//     delete m_client;
// }

void mqtt::connectToHost(
    const QString &hostname,
    int port,
    const QString &username,
    const QString &password,
    const QString &topic) {

    qDebug() << "Attempting to connect to host:" << hostname << "on port:" << port;

    m_topic = topic;

    // Configure SSL/TLS
    QSslConfiguration sslConfig = QSslConfiguration::defaultConfiguration();
    sslConfig.setPeerVerifyMode(QSslSocket::VerifyPeer);
    sslConfig.setProtocol(QSsl::TlsV1_2OrLater); // Ensure modern protocol is used

    // Set MQTT client parameters
    m_client->setHostname(hostname);
    m_client->setPort(port);
    m_client->setUsername(username);
    m_client->setPassword(password);
    m_client->setProtocolVersion(QMqttClient::MQTT_3_1_1);

    qDebug() << "SSL Configuration and Client parameters set. Connecting...";

    // Pass the hostname and port explicitly to connectToHostEncrypted
    m_client->connectToHostEncrypted(sslConfig);
}

void mqtt::disconnectFromHost() {
    if (isConnected()) {
        qDebug() << "Disconnecting from host...";
        m_client->disconnectFromHost();
    } else {
        qWarning() << "Cannot disconnect: Not connected to any host.";
    }
}

bool mqtt::isConnected() const {
    return m_client->state() == QMqttClient::Connected;
}

void mqtt::onConnected() {
    qDebug() << "Successfully connected to broker. Subscribing to topic:" << m_topic;
    auto subscription = m_client->subscribe(m_topic, 0);
    if (subscription) {
        emit connectionStatusChanged("Connected to " + m_client->hostname(), true);
        qDebug() << "Subscribed to topic:" << m_topic;
    } else {
        emit connectionStatusChanged("Connected, but subscription failed", false);
        qWarning() << "Subscription failed for topic:" << m_topic;
    }
}

void mqtt::onDisconnected() {
    emit connectionStatusChanged("Disconnected", false);
    qDebug() << "Disconnected from MQTT broker.";
}

void mqtt::onMessageReceived(const QByteArray &message, const QMqttTopicName &topic) {
    QString receivedMsg =  QString::fromUtf8(message);
    qDebug() << "Message received on topic:" << topic.name() << "Message:" << QString::fromUtf8(message);
    emit messageReceived(topic.name(), receivedMsg);
    // if(receivedMsg == "start"){
    //     emit connectionStatusChanged("Received 'start' command",true);
    //     QMetaObject::invokeMethod(parent(),"startWithMqtt",Q_ARG(bool,true));
    // }
    // else if(receivedMsg == "stop"){
    //     emit connectionStatusChanged("Received 'stop' command",true);
    //     QMetaObject::invokeMethod(parent(),"startWithMqtt",Q_ARG(bool,false));
    // }
}
