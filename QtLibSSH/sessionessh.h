#ifndef SESSIONESSH_H
#define SESSIONESSH_H

#include <QObject>
#include <QVariant>

#include <QDataStream>
#include <QDebug>
#include <QVariantMap>

typedef struct ssh_session_struct* ssh_session;
typedef struct ssh_channel_struct* ssh_channel;
class CodiceErrore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString testoErrore READ testoErrore)
    Q_PROPERTY(CodiceErroreEnum codiceErrore READ codiceErrore)

    friend QDataStream &operator<<(QDataStream &out, const CodiceErrore &in);
    friend QDataStream &operator>>(QDataStream &in, CodiceErrore &out);

public:
    enum CodiceErroreEnum {
        ERRORE_OK,
        ERRORE_ALTRO,
        ERRORE_KO_HOSTNOTFOUND,
        ERRORE_KO_NONCONNESSO,
        ERRORE_KO_SESSIONENONINIZIALIZZATA,
        ERRORE_KO_AUTENTICAZIONE,
        ERRORE_KO_APERTURACANALE,
        ERRORE_KO_RICHIESTAPTY,
        ERRORE_KO_ESECUZIONECOMANDO
    };


    Q_ENUMS(CodiceErroreEnum)
    Q_INVOKABLE CodiceErrore(QObject *parent = 0);
    CodiceErrore(CodiceErroreEnum codice, QString testo);
    CodiceErrore(CodiceErroreEnum codice);
    CodiceErrore(const CodiceErrore& other);

    virtual ~CodiceErrore();
//    CodiceErrore(CodiceErrore other);
    CodiceErrore& operator =(const CodiceErrore& other);

    QString testoErrore() const
    {
        //qDebug() << "parent: " << parent();
        return m_testoErrore;
    }

    CodiceErroreEnum codiceErrore() const
    {
        return m_codiceErrore;
    }

    Q_INVOKABLE QString test() const
    {
        return "OKOK";
    }

private:
    QString m_testoErrore;
    CodiceErroreEnum m_codiceErrore;


};
QDataStream &operator<<(QDataStream &out, const CodiceErrore &in);
QDataStream &operator>>(QDataStream &in, CodiceErrore &out);
Q_DECLARE_METATYPE(CodiceErrore)
Q_DECLARE_METATYPE(CodiceErrore::CodiceErroreEnum)

class SessioneSSH : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString hostname READ hostname)
    Q_PROPERTY(QString username READ username)
    Q_PROPERTY(QString password READ password)
    Q_PROPERTY(int porta READ porta)

    QString m_hostname;
    char* m_hostnameC;
    QString m_username;
    char* m_usernameC;

    QString m_password;
    char* m_passwordC;

    int m_porta;

private:
    ssh_session sessioneSSH_;
    ssh_channel apriCanale(bool* toErrore);
    void chiudiCanale(ssh_channel canale, bool sendEOF);

    // int verify_knownhost(ssh_session session);
    // int shell_session();
    // int interactive_shell_session(ssh_channel channel);

    void cancellaChar(char* puntatore);
    char* assegnaChar(const QString& stringa);
public:
    Q_INVOKABLE explicit SessioneSSH(QObject *parent = 0);
    ~SessioneSSH();

public slots:
    Q_INVOKABLE QVariantMap eseguiComando(QString comando, bool richiestoPty, CodiceErrore* toErrore = 0);
    Q_INVOKABLE void connetti(QString hostname, int porta, CodiceErrore* toErrore = 0);
    Q_INVOKABLE void autenticaConPassword(QString username, QString password, CodiceErrore* toErrore = 0);
    Q_INVOKABLE void disconnettiSessione(CodiceErrore* toErrore = 0);
    // Q_INVOKABLE int autenticazioneInterattiva();

    QString hostname() const
    {
        return m_hostname;
    }

    QString username() const
    {
        return m_username;
    }

    QString password() const
    {
        return m_password;
    }

    int porta() const
    {
        return m_porta;
    }

signals:


void portaChanged(int arg);

public slots:


};

#endif // SESSIONESSH_H
