auth		sufficient	pam_rootok.so
auth		include		system-auth
account		include		system-auth
password	include		system-auth
-password	optional	pam_gnome_keyring.so {{ unix_authtok }}
