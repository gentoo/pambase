auth		include		system-login
{% if gnome_keyring %}
auth		optional	pam_gnome_keyring.so
{% endif %}
account		include		system-login
password	include		system-login
{% if gnome_keyring %}
password	optional	pam_gnome_keyring.so use_authtok
{% endif %}
{% if gnome_keyring and openrc %}
session		optional	pam_gnome_keyring.so auto_start
{% endif %}
session		include		system-login
{% if gnome_keyring and not openrc %}
session		optional	pam_gnome_keyring.so auto_start
{% endif %}
