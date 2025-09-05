auth		sufficient	pam_rootok.so
auth		include		system-auth
account		include		system-auth
password	include		system-auth

{% if gnome_keyring %}
password	optional	pam_gnome_keyring.so use_authtok
{% endif %}
