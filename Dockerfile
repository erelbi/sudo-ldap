FROM debian:buster
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
RUN apt-get update && \
    echo "slapd slapd/root_password password admin" |debconf-set-selections && \
    echo "slapd slapd/root_password_again password admin" |debconf-set-selections && \
    echo "slapd slapd/internal/adminpw password admin" |debconf-set-selections && \
    echo "slapd slapd/internal/generated_adminpw password admin" |debconf-set-selections && \
    echo "slapd slapd/password2 password admin" |debconf-set-selections && \
    echo "slapd slapd/password1 password admin" |debconf-set-selections && \
    echo "slapd slapd/domain string elvan.local" |debconf-set-selections && \
    echo "slapd shared/organization string Elvan" |debconf-set-selections && \
    echo "slapd slapd/backend string HDB" |debconf-set-selections && \
    echo "slapd slapd/purge_database boolean true" |debconf-set-selections && \
    echo "slapd slapd/move_old_database boolean true" |debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 boolean false" |debconf-set-selections && \
    echo "slapd slapd/no_configuration boolean false" |debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils && \
    mkdir -p /opt/config 

#RUN dpkg-reconfigure -f noninteractive slapd
RUN  echo "0.0.0.0 `hostname --fqdn`" >> /etc/hosts
ADD config_file/sudo.ldif /etc/ldap/schema/
ADD config_file/cn={14}sudo.ldif /etc/ldap/slapd.d/cn=config/cn=schema
ADD config_file/sudoersou.ldif /opt/config/
ADD config_file/sudoers2ldif.ldif /opt/config/
ADD config_file/nuh.ldif /opt/config/
ADD config_file/elvan.ldif /opt/config/
ADD config_file/olcDatabase.ldif /opt/config/

RUN chown -R openldap /opt/config/ 
COPY config_file/ldap.conf /etc/ldap/ldap.conf


RUN mkdir -p /var/ldap/elvan \
    && chown -R openldap /var/ldap \
    && service slapd start \
    && ldapadd -H ldapi:/// -f /opt/config/sudoersou.ldif -x -D "cn=admin,dc=elvan,dc=local" -w admin \
    && ldapadd -H ldapi:/// -f /opt/config/nuh.ldif -x -D "cn=admin,dc=elvan,dc=local" -w admin \
    && ldapadd -H ldapi:/// -f /opt/config/elvan.ldif -x -D "cn=admin,dc=elvan,dc=local" -w admin \
    && ldapadd -H ldapi:/// -f /opt/config/sudoers2ldif.ldif -x -D "cn=admin,dc=elvan,dc=local" -w admin 

EXPOSE 389


CMD slapd -h "ldap:/// ldapi:///" -u openldap -g openldap -d 256