#!/bin/bash
apt-get update && \
echo 'slapd/root_password password password' | debconf-set-selections &&\
echo 'slapd/root_password_again password password' | debconf-set-selections && \
apt-get install -y slapd ldap-utils
# apt-get update
# apt-get install apt-utils debconf-utils -y


# echo -e "slapd slapd/root_password password KappaRoss" |debconf-set-selections
# echo -e "slapd slapd/root_password_again password KappaRoss" |debconf-set-selections

# echo -e "slapd slapd/internal/adminpw password 1234" |debconf-set-selections
# echo -e "slapd slapd/internal/generated_adminpw password 1234" |debconf-set-selections
# echo -e "slapd slapd/password2 password 1234" |debconf-set-selections
# echo -e "slapd slapd/password1 password 1234" |debconf-set-selections
# echo -e "slapd slapd/domain string  elvan.bilsel" |debconf-set-selections
# echo -e "slapd shared/organization string erelbi" |debconf-set-selections
# echo -e "slapd slapd/backend string HDB" |debconf-set-selections
# echo -e "slapd slapd/purge_database boolean true" |debconf-set-selections
# echo -e "slapd slapd/move_old_database boolean true" |debconf-set-selections
# echo -e "slapd slapd/allow_ldap_v2 boolean false" |debconf-set-selections
# echo -e "slapd slapd/no_configuration boolean false" |debconf-set-selections

# apt-get install -y slapd ldap-utils
# dpkg-reconfigure slapd 



# chmod 777 /etc/ldap/ldap.conf 
# cat <<'EOF' > /etc/ldap/ldap.conf
# #
# # LDAP Defaults
# #

# # See ldap.conf(5) for details
# # This file should be world readable but not world writable.


# BASE    dc=elvan,dc=bilsel
# URI     ldap://127.0.0.1:389 

# #SIZELIMIT      12
# #TIMELIMIT      15
# #DEREF          never

# # TLS certificates (needed for GnuTLS)
# TLS_CACERT      /etc/ssl/certs/ca-certificates.crt
# EOF


# chmod 744 /etc/ldap/ldap.conf 