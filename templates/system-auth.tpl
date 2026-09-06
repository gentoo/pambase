auth		required	pam_env.so {{ debug }}
{% if pam_ssh %}
auth		sufficient	pam_ssh.so
{% endif %}

{% if krb5 %}
auth		[success=ok default=1]	pam_krb5.so {{ debug }} ignore_root try_first_pass
auth		[default={{ 3 + homed + (sssd * 3) + winbind }}]	pam_permit.so
{% endif %}

{% if sssd %}
auth		[default=1 ignore=ignore success=ok]	pam_usertype.so isregular
auth		[default=3 ignore=ignore success=ok]	pam_localuser.so
{% endif %}

auth		requisite	pam_faillock.so preauth

{% if homed %}
auth		[success={{ 3 if winbind else 2 }} default=ignore]	pam_systemd_home.so
{% endif %}

{% if sssd %}
auth		sufficient	pam_unix.so {{ nullok }} {{ debug }}
{% else %}
auth		[success={{ 2 if winbind else 1 }} new_authtok_reqd={{ 2 if winbind else 1 }} ignore=ignore default={{ 'ignore' if winbind else 'bad' }}]	pam_unix.so {{ nullok }} {{ debug }} try_first_pass
{% endif %}
{% if winbind %}
auth		[success=done new_authtok_reqd=done default=ignore]	pam_winbind.so use_first_pass {{ debug }}
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
account		[success={{ 3 if winbind else 2 }} default=ignore]	pam_krb5.so {{ debug }} ignore_root try_first_pass
{% endif %}

{% if homed %}
account		[success={{ (3 if sssd else 2) if winbind else (2 if sssd else 1) }} default=ignore]	pam_systemd_home.so
{% endif %}

{% if winbind %}
account		[success=1 default=ignore]	pam_winbind.so {{ debug }}
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
password	[success=1 default=ignore]	pam_krb5.so {{ debug }} ignore_root try_first_pass
{% endif %}

{% if homed %}
password	[success=1 default=ignore]	pam_systemd_home.so
{% endif %}

password	{{ 'sufficient' if (sssd or winbind) else 'required' }}	pam_unix.so try_first_pass shadow {% if passwdqc or pwquality %}use_authtok{% endif %} {{ nullok }} {{ encrypt }} {{ debug }}

{% if sssd %}
password	sufficient	pam_sss.so use_authtok
password	required	pam_deny.so
{% endif %}
{% if winbind %}
password	sufficient	pam_winbind.so use_authtok {{ debug }}
password	required	pam_deny.so
{% endif %}

{% if pam_ssh %}
session		optional	pam_ssh.so
{% endif %}

{% include "templates/system-session.tpl" %}
