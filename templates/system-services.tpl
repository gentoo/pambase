auth		sufficient	pam_permit.so
account		include		system-auth
session		optional	pam_loginuid.so
{% include "templates/system-session.tpl" %}
