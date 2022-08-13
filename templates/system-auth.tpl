auth		required	pam_env.so {{ debug|default('', true) }}
{% if pam_ssh %}
auth		sufficient	pam_ssh.so
{% endif %}

{% if krb5 %}
auth		[success={{ 3 + 1 if homed else 0 + 1 if winbind else 0 }} default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

auth		requisite	pam_faillock.so preauth

{% if homed %}
auth		[success={{ 3 if winbind else 2 }} default=ignore]	pam_systemd_home.so
{% endif %}

auth		[success={{ 2 if winbind else 1 }} default=ignore]	pam_unix.so {{ nullok|default('', true) }} {{ debug|default('', true) }} try_first_pass

{% if winbind %}
auth		[success=1 default=ignore]	pam_winbind.so use_first_pass {{ debug|default('', true) }}
{% endif %}

auth		[default=die]	pam_faillock.so authfail

{% if caps %}
auth		optional	pam_cap.so
{% endif %}

{% if krb5 %}
account		[success={{ 1 + 1 if homed else 0 + 1 if winbind else 0 }} default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
account		[success={{ 2 if winbind else 1 }} default=ignore]	pam_systemd_home.so
{% endif %}

{% if winbind %}
account		[success=1 default=ignore]	pam_winbind.so {{ debug|default('', true) }}
{% endif %}

account		required	pam_unix.so {{ debug|default('', true) }}

account		required	pam_faillock.so

{% if passwdqc %}
password		required	pam_passwdqc.so config=/etc/security/passwdqc.conf
{% endif %}

{% if pwquality %}
password		required	pam_pwquality.so
{% endif %}

{% if pwhistory %}
password		required	pam_pwhistory.so use_authtok remember=5 retry=3
{% endif %}

{% if krb5 %}
password		[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
password		[success=1 default=ignore]	pam_systemd_home.so
{% endif %}

{% if passwdqc or pwquality %}
password		required	pam_unix.so try_first_pass {{ unix_authtok|default('', true) }} {{ nullok|default('', true) }} {{ unix_extended_encryption|default('', true) }} {{ debug|default('', true) }}
{% else %}
password		required	pam_unix.so try_first_pass {{ nullok|default('', true) }} {{ unix_extended_encryption|default('', true) }} {{ debug|default('', true) }}
{% endif %}

{% if winbind %}
password		required	pam_winbind.so {{ unix_authtok|default('', true) }} {{ debug|default('', true) }}
{% endif %}


{% if pam_ssh %}
session		optional	pam_ssh.so
{% endif %}

{% include "templates/system-session.tpl" %}
