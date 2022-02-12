auth		required	pam_env.so {{ debug|default('', true) }}
{% if pam_ssh %}
auth		sufficient	pam_ssh.so
{% endif %}

{% if krb5 %}
auth		[success={{ 4 if homed else 3 }} default=ignore]      pam_krb5.so {{ krb5_params }}
{% endif %}

auth		requisite	pam_faillock.so preauth
{% if homed %}
auth            [success=2 default=ignore]      pam_systemd_home.so
{% endif %}
auth            [success=1 default=ignore]      pam_unix.so {{ nullok|default('', true) }} {{ debug|default('', true) }} try_first_pass
auth		[default=die]	pam_faillock.so authfail

{% if caps %}
auth		optional	pam_cap.so
{% endif %}

{% if krb5 %}
account		[success=2 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
account         [success=1 default=ignore]      pam_systemd_home.so
{% endif %}

account		required	pam_unix.so {{ debug|default('', true) }}
account         required        pam_faillock.so

{% if passwdqc %}
password	required	pam_passwdqc.so config=/etc/security/passwdqc.conf
{% endif %}

{% if pwquality %}
password        required        pam_pwquality.so
{% endif %}

{% if pwhistory %}
password        required        pam_pwhistory.so use_authtok remember=5 retry=3
{% endif %}

{% if krb5 %}
password	[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
password        [success=1 default=ignore]      pam_systemd_home.so
{% endif %}

{% if passwdqc or pwquality %}
password	required	pam_unix.so try_first_pass {{ unix_authtok|default('', true) }} {{ nullok|default('', true) }} {{ unix_extended_encryption|default('', true) }} {{ debug|default('', true) }}
{% else %}
password        required        pam_unix.so try_first_pass {{ nullok|default('', true) }} {{ unix_extended_encryption|default('', true) }} {{ debug|default('', true) }}
{% endif %}

{% if pam_ssh %}
session		optional	pam_ssh.so
{% endif %}

{% include "templates/system-session.tpl" %}
