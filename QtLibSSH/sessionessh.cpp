#include "sessionessh.h"
#include <libssh/libssh.h>
#include <stdlib.h>
#include <stdio.h>
#include <QDebug>



SessioneSSH::SessioneSSH(QObject *parent) : QObject(parent)
{

    m_porta = 22;
    m_hostnameC = 0;
    m_usernameC = 0;
    m_passwordC = 0;
    sessioneSSH_ = NULL;

   //  shell_session(sessioneSSH_);

    // show_remote_processes(sessioneSSH_);



}



void SessioneSSH::connetti(QString hostname, int porta,CodiceErrore* toErrore)
{

    // int verbosity = SSH_LOG_FUNCTIONS;
    int verbosity = SSH_LOG_NOLOG;

    if (sessioneSSH_ == NULL)
    {
        sessioneSSH_ = ssh_new();
    }


    if (sessioneSSH_ == NULL)
    {
        if(toErrore) {*toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_SESSIONENONINIZIALIZZATA); }
        return;
    }

    m_hostname = hostname;

    cancellaChar(m_hostnameC);
    m_hostnameC = assegnaChar(hostname);
    m_porta = porta;
//    qDebug() << "Hostname: '" << m_hostnameC << "' - porta: " << m_porta;

    ssh_options_set(sessioneSSH_, SSH_OPTIONS_LOG_VERBOSITY, &verbosity);
    ssh_options_set(sessioneSSH_, SSH_OPTIONS_HOST, m_hostnameC);
    ssh_options_set(sessioneSSH_, SSH_OPTIONS_PORT, &m_porta);


    int rc = ssh_connect(sessioneSSH_);
    if (rc != SSH_OK)
    {
        QString testoErrore = QString::fromUtf8(ssh_get_error(sessioneSSH_));

        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_ALTRO,testoErrore); }
        ssh_disconnect(sessioneSSH_);
        return;

    } else {
        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_OK); }
        return;
    }

    // Verify the server's identity
    // For the source code of verify_knowhost(), check previous example
/*
    if (verify_knownhost(sessioneSSH_) < 0)
    {
        qDebug() << "Fallita verifica host";
      ssh_disconnect(sessioneSSH_);
      ssh_free(sessioneSSH_);
      exit(-1);
    }
*/
}

void SessioneSSH::autenticaConPassword(QString username, QString password,CodiceErrore* toErrore)
{
    if (sessioneSSH_ == NULL)
    {
        if (toErrore) {*toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_SESSIONENONINIZIALIZZATA); }
        return;
    }


    m_password = password;
    m_username = username;

    cancellaChar(m_usernameC);
    m_usernameC = assegnaChar(m_username);
    cancellaChar(m_passwordC);
    m_passwordC = assegnaChar(m_password);

//    qDebug() << "Autentico : '" << m_usernameC << "'' - " << m_passwordC;


    int rc = ssh_userauth_password(sessioneSSH_, m_usernameC, m_passwordC);

    if (rc == SSH_AUTH_DENIED)
    {
        //Autenticazione interattiva
//        qDebug() << "Inizio autenticazione interattiva";
        int rc2 = ssh_userauth_kbdint(sessioneSSH_, m_usernameC, NULL);
        while (rc2 == SSH_AUTH_INFO)
        {
//          qDebug() << "AVANTI";
          if (ssh_userauth_kbdint_getnprompts(sessioneSSH_) == 1)
          {
            rc = ssh_userauth_kbdint_setanswer(sessioneSSH_, 0, m_passwordC);
          }
          rc2 = ssh_userauth_kbdint(sessioneSSH_, m_usernameC, NULL);
        }
//        qDebug() << "Fine autenticazione interattiva";
    }
    if (rc != SSH_OK)
    {
        // autenticazioneInterattiva();
        QString testoErrore = QString::fromUtf8(ssh_get_error(sessioneSSH_));
//        qDebug() << "ERER: " << testoErrore;
        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_AUTENTICAZIONE,testoErrore); }
        return;
    }

    if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_OK); }
    return;

}

void SessioneSSH::disconnettiSessione(CodiceErrore* toErrore)
{
    if (sessioneSSH_ == NULL)
    {
        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_SESSIONENONINIZIALIZZATA); }
        return;
    }

    if (ssh_is_connected(sessioneSSH_))
    {
        qDebug() << "Disconnetto";
        ssh_disconnect(sessioneSSH_);
    }

    ssh_free(sessioneSSH_);
    sessioneSSH_ = NULL;

    if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_OK); }


}
/*
int SessioneSSH::autenticazioneInterattiva()
{
    int rc;
    rc = ssh_userauth_kbdint(sessioneSSH_, NULL, NULL);
    while (rc == SSH_AUTH_INFO)
    {
      const char *name, *instruction;
      int nprompts, iprompt;
      name = ssh_userauth_kbdint_getname(sessioneSSH_);
      instruction = ssh_userauth_kbdint_getinstruction(sessioneSSH_);
      nprompts = ssh_userauth_kbdint_getnprompts(sessioneSSH_);
      if (strlen(name) > 0)
      {
        printf("%s\n", name);
      }
      if (strlen(instruction) > 0)
      {
        printf("%s\n", instruction);
      }
      qDebug() << "Prompts: " << nprompts;

      for (iprompt = 0; iprompt < nprompts; iprompt++)
      {
        const char *prompt;
        char echo;
        prompt = ssh_userauth_kbdint_getprompt(sessioneSSH_, iprompt, &echo);
        if (echo)
        {
          char buffer[128], *ptr;
          printf("%s", prompt);
          if (fgets(buffer, sizeof(buffer), stdin) == NULL)
          {
            return SSH_AUTH_ERROR;
          }
          qDebug() << "c2";
          buffer[sizeof(buffer) - 1] = '\0';
          if ((ptr = strchr(buffer, '\n')) != NULL)
            *ptr = '\0';
          if (ssh_userauth_kbdint_setanswer(sessioneSSH_, iprompt, buffer) < 0)
          {
            return SSH_AUTH_ERROR;
          }
          memset(buffer, 0, strlen(buffer));
        }
        else
        {
          char *ptr;
          ptr = getpass(prompt);
          rc = ssh_userauth_kbdint_setanswer(sessioneSSH_, iprompt, ptr);
          if (rc < 0)
          {
            return SSH_AUTH_ERROR;
          }
        }
      }
      rc = ssh_userauth_kbdint(sessioneSSH_, NULL, NULL);
    }

    return rc;

}
*/
SessioneSSH::~SessioneSSH()
{
    cancellaChar(m_hostnameC);
    cancellaChar(m_usernameC);
    cancellaChar(m_passwordC);

    if (sessioneSSH_ != NULL) {
        disconnettiSessione();
        // ssh_free(sessioneSSH_);
    }

}



ssh_channel SessioneSSH::apriCanale(bool *toErrore)
{
    ssh_channel canale = 0;
    *toErrore = false;
    if (sessioneSSH_ != NULL) {
        canale = ssh_channel_new(sessioneSSH_);
        if (canale == NULL)
        {
          canale = 0;
          *toErrore = true;
        }
        int rc = ssh_channel_open_session(canale);
        if (rc != SSH_OK)
        {
          ssh_channel_free(canale);
          canale = 0;
          *toErrore = true;
        }
    } else {
        *toErrore = true;
    }
    return canale;

}

void SessioneSSH::chiudiCanale(ssh_channel canale, bool sendEOF)
{
    if (canale != NULL)
    {
        if (sendEOF)
        {
            ssh_channel_send_eof(canale);
        }
        ssh_channel_close(canale);
        ssh_channel_free(canale);
    }
}
/*
int SessioneSSH::shell_session()
{
  bool errore = false;

  ssh_channel channel = apriCanale(&errore);
  if (errore)
  {
      return SSH_ERROR;
  }

  interactive_shell_session(channel);
  chiudiCanale(channel,true);

  return SSH_OK;
}
*/

QVariantMap SessioneSSH::eseguiComando(QString comando,  bool richiestoPty, CodiceErrore* toErrore)
{
    bool errore = false;
    QString toOutput = "";
    QString toError = "";
    QVariantMap m;

    ssh_channel channel = apriCanale(&errore);
    if (errore)
    {
        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_APERTURACANALE); }
        return m;
    }

    std::string comandoStr = comando.toStdString();

    int rc = 0;

    if (richiestoPty)
    {
        rc = ssh_channel_request_pty(channel);
        if (rc != SSH_OK)
        {
            chiudiCanale(channel,false);
            if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_RICHIESTAPTY); }
            return m;
        }
    }
    rc = ssh_channel_request_exec(channel, comandoStr.c_str());

    if (rc != SSH_OK)
    {
        chiudiCanale(channel,false);
        if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_ESECUZIONECOMANDO); }
        return m;
    }

    char buffer[256];

    int nbytes = ssh_channel_read(channel, buffer, sizeof(buffer), 0);

    while (nbytes > 0)
    {

        QString output = QString::fromUtf8(buffer,nbytes);
        toOutput += output;
        nbytes = ssh_channel_read(channel, buffer, sizeof(buffer), 0);

    }

    if (nbytes < 0)
    {
        if (toErrore) {*toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_ESECUZIONECOMANDO); }
        return m;
    }
    nbytes = ssh_channel_read(channel, buffer, sizeof(buffer), 1);
    while (nbytes > 0)
    {
        QString output = QString::fromUtf8(buffer,nbytes);
        toError += output;
        nbytes = ssh_channel_read(channel, buffer, sizeof(buffer), 1);
    }


    if (nbytes < 0)
    {
        if (toErrore) {*toErrore = CodiceErrore(CodiceErrore::ERRORE_KO_ESECUZIONECOMANDO); }
        return m;
    }
    // qDebug() << "EOF?" << ssh_channel_is_eof(channel);
    chiudiCanale(channel,true);

    if (toErrore) { *toErrore = CodiceErrore(CodiceErrore::ERRORE_OK);}
    m.insert("output",toOutput);
    m.insert("error",toError);
    return m;
}
/*
int SessioneSSH::interactive_shell_session(ssh_channel channel)
{
    int rc = 0;
    char buffer[256];
    int nbytes, nwritten;



    rc = ssh_channel_request_pty(channel);
    if (rc != SSH_OK) {
        qDebug() << "Errore ssh_channel_request_pty";
        return rc;
    }
    rc = ssh_channel_change_pty_size(channel, 80, 24);
    if (rc != SSH_OK) {
        qDebug() << "Errore ssh_channel_change_pty_size";
        return rc;
    }
    rc = ssh_channel_request_shell(channel);
    if (rc != SSH_OK) {
        qDebug() << "Errore ssh_channel_request_shell";
        return rc;
    }

    int step = 0;

    while (ssh_channel_is_open(channel) &&
           !ssh_channel_is_eof(channel))
    {
      //  qDebug() << "aaaL0";

    nbytes = ssh_channel_read_nonblocking(channel, buffer, sizeof(buffer), 1);
    if (nbytes > 0)
    {
     nwritten = write(1, buffer, nbytes);
    }

      nbytes = ssh_channel_read_nonblocking(channel, buffer, sizeof(buffer), 0);
      if (nbytes < 0) return SSH_ERROR;
      if (nbytes > 0)
      {
       nwritten = write(1, buffer, nbytes);
// qDebug() << "aaaL1";
       // if (nwritten != nbytes) return SSH_ERROR;
//        qDebug() << "Letto: " << buffer;
//        if (!kbhit())
//        {
// // qDebug() << "aaaL2";
//            usleep(50000L); // 0.05 second
//            continue;
//        }
//        qDebug() << "aaaL3";

//        nbytes = read(0, buffer, sizeof(buffer));
//        if (nbytes < 0) return SSH_ERROR;
//        if (nbytes > 0)

      }

      if (nbytes == 0)
      {
          if (step == 0)
           {
              step = 3;
               qDebug() << "Scrivo!";
               // nwritten = ssh_channel_write(channel, buffer, nbytes);
   //            nwritten = ssh_channel_write(channel, "sudo -s", nbytes);
               char* comandone = "sudo -s\n/aruba/bin/qs\n/aruba/bin/check_spam.sh\n";
               nwritten = ssh_channel_write(channel,comandone, strlen(comandone));

               if (nwritten != strlen(comandone))
               {
                   return SSH_ERROR;
               }
           }

          if (step == 1)
           {
              step = 2;
               qDebug() << "Scrivo 2!";
               // nwritten = ssh_channel_write(channel, buffer, nbytes);
               nwritten = ssh_channel_write(channel, "/aruba/bin/qs", nbytes);
               if (nwritten != nbytes) return SSH_ERROR;
           }
      }
    }
    return rc;
}
*/

void SessioneSSH::cancellaChar(char *puntatore)
{
    if (puntatore != 0)
    {
        delete[] (puntatore);
    }
}

char *SessioneSSH::assegnaChar(const QString &stringa)
{
    QByteArray data = stringa.toUtf8();
    char* puntatore = new char[data.length()+1];
    strncpy(puntatore, data.constData(),data.length());
    puntatore[data.length()] = '\0';
    // qDebug() << "Prima: " << stringa << " - " << "BA:" << data << " DOPO: " << puntatore;
    return puntatore;
}

/*
int SessioneSSH::verify_knownhost(ssh_session session)
{
  int state, hlen;
  unsigned char *hash = NULL;
  char *hexa;
  char buf[10];
  state = ssh_is_server_known(session);
  hlen = ssh_get_pubkey_hash(session, &hash);
  if (hlen < 0)
    return -1;
  switch (state)
  {
    case SSH_SERVER_KNOWN_OK:
      break; // ok
    case SSH_SERVER_KNOWN_CHANGED:
      fprintf(stderr, "Host key for server changed: it is now:\n");
      ssh_print_hexa("Public key hash", hash, hlen);
      fprintf(stderr, "For security reasons, connection will be stopped\n");
      free(hash);
      return -1;
    case SSH_SERVER_FOUND_OTHER:
      fprintf(stderr, "The host key for this server was not found but an other"
        "type of key exists.\n");
      fprintf(stderr, "An attacker might change the default server key to"
        "confuse your client into thinking the key does not exist\n");
      free(hash);
      return -1;
    case SSH_SERVER_FILE_NOT_FOUND:
      fprintf(stderr, "Could not find known host file.\n");
      fprintf(stderr, "If you accept the host key here, the file will be"
       "automatically created.\n");
      // fallback to SSH_SERVER_NOT_KNOWN behavior
    case SSH_SERVER_NOT_KNOWN:
      hexa = ssh_get_hexa(hash, hlen);
      fprintf(stderr,"The server is unknown. Do you trust the host key?\n");
      fprintf(stderr, "Public key hash: %s\n", hexa);
      free(hexa);
      if (fgets(buf, sizeof(buf), stdin) == NULL)
      {
        free(hash);
        return -1;
      }
      if (strncasecmp(buf, "yes", 3) != 0)
      {
        free(hash);
        return -1;
      }
      if (ssh_write_knownhost(session) < 0)
      {
        // fprintf(stderr, "Error %s\n", strerror(errno));
        free(hash);
        return -1;
      }
      break;
    case SSH_SERVER_ERROR:
      fprintf(stderr, "Error %s", ssh_get_error(session));
      free(hash);
      return -1;
  }
  free(hash);
  return 0;
}
*/



CodiceErrore::CodiceErrore(CodiceErrore::CodiceErroreEnum codice, QString testo) : QObject()
{
    m_codiceErrore = codice;
    m_testoErrore = testo;
}

CodiceErrore::CodiceErrore(CodiceErrore::CodiceErroreEnum codice) : QObject()
{
    m_codiceErrore = codice;
}

CodiceErrore::CodiceErrore(QObject *parent): QObject(parent)
{
//    qDebug() << "Creo codice errore, parent:" << parent;
    m_codiceErrore = ERRORE_ALTRO;
}

CodiceErrore::CodiceErrore(const CodiceErrore &other) : QObject()
{
    this->operator =(other);
}


CodiceErrore::~CodiceErrore()
{
//    qDebug() << "Distruttore codice errore";
}

CodiceErrore &CodiceErrore::operator =(const CodiceErrore &other)
{
    this->m_codiceErrore = other.m_codiceErrore;
    this->m_testoErrore = other.m_testoErrore;

    return *this;
}

QDataStream &operator<<(QDataStream &out, const CodiceErrore &in)
{
    out << in.m_codiceErrore;
    out << in.m_testoErrore;
    return out;
}

QDataStream &operator>>(QDataStream &in, CodiceErrore &out)
{
    quint16 errore;
    in >> errore;

    out.m_codiceErrore = (CodiceErrore::CodiceErroreEnum)errore;
    in >> out.m_testoErrore;


    return in;
}
