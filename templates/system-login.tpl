auth		required	pam_shells.so {{ debug|default('', true) }}
auth		required	pam_nologin.so
auth		include		system-auth

account		required	pam_access.so {{ debug|default('', true) }}
account		required	pam_nologin.so
account		required	pam_time.so
account		include		system-auth

password	include		system-auth
session		optional	pam_loginuid.so
{% if selinux %}
session		required	pam_selinux.so close
{% endif %}

session		required	pam_env.so envfile=/etc/profile.env {{ debug|default('', true) }}
{% if not minimal %}
session		optional	pam_lastlog.so silent {{ debug|default('', true) }}
{% endif %}
session		include		system-auth
{% if selinux %}
 # Note: modules that run in the user's context must come after this line.
session		required	pam_selinux.so multiple open
{% endif %}

{% if not minimal %}
session		optional	pam_motd.so motd=/etc/motd
{% endif %}

{% if not minimal %}
session		optional	pam_mail.so
{% endif %}

{% if systemd %}
-session	optional	pam_systemd.so
{% endif %}

{% if elogind %}
-session	optional	pam_elogind.so
{% endif %}
