auth		required	pam_env.so {{ debug }}
{% if pam_ssh %}
auth		sufficient	pam_ssh.so
{% endif %}

{% if krb5 %}
auth		[success={{ 4 if homed else 3 }} default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if sssd %}
auth		[default=1 ignore=ignore success=ok]	pam_usertype.so isregular
auth		[default=3 ignore=ignore success=ok]	pam_localuser.so
{% endif %}

auth		requisite	pam_faillock.so preauth

{% if homed %}
auth		[success=2 default=ignore]	pam_systemd_home.so
{% endif %}

{% if sssd %}
auth		sufficient	pam_unix.so {{ nullok }} {{ debug }}
{% else %}
auth		[success=1 new_authtok_reqd=1 ignore=ignore default=bad]	pam_unix.so {{ nullok }} {{ debug }} try_first_pass
{% endif %}
auth		[default=die]	pam_faillock.so authfail
{% if sssd %}
auth		sufficient	pam_sss.so forward_pass {{ debug }}
{% endif %}
{% if caps %}
auth		optional	pam_cap.so
{% endif %}
{% if sssd %}
auth		required	pam_deny.so
{% endif %}
{% if krb5 %}
account		[success=2 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
account		[success={{ 2 if sssd else 1 }} default=ignore]	pam_systemd_home.so
{% endif %}

account		required	pam_unix.so {{ debug }}
account		required	pam_faillock.so
{% if sssd %}
account		sufficient	pam_localuser.so
account		sufficient	pam_usertype.so issystem
account		[default=bad success=ok user_unknown=ignore]	pam_sss.so {{ debug }}
account		required	pam_permit.so
{% endif %}

{% if passwdqc %}
password	required	pam_passwdqc.so config=/etc/security/passwdqc.conf
{% endif %}

{% if pwquality %}
password	required	pam_pwquality.so {% if sssd %}local_users_only{% endif %}
{% endif %}

{% if pwhistory %}
password	required	pam_pwhistory.so use_authtok remember=5 retry=3
{% endif %}

{% if krb5 %}
password	[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
password	[success=1 default=ignore]	pam_systemd_home.so
{% endif %}

{% if passwdqc or pwquality %}
password	{{ 'sufficient' if sssd else 'required' }}	pam_unix.so try_first_pass {{ unix_authtok|default('', true) }} {{ nullok }} {{ unix_extended_encryption|default('', true) }} {{ debug }}
{% else %}
password	{{ 'sufficient' if sssd else 'required' }}	pam_unix.so try_first_pass {{ nullok }} {{ unix_extended_encryption|default('', true) }} {{ debug }}
{% endif %}

{% if sssd %}
password	sufficient	pam_sss.so use_authtok
password	required	pam_deny.so
{% endif %}

{% if pam_ssh %}
session		optional	pam_ssh.so
{% endif %}

{% include "templates/system-session.tpl" %}
