{% if securetty -%}
auth		required	pam_securetty.so
{% endif -%}

auth		include		system-local-login
account		include		system-local-login
password	include		system-local-login
session		optional 	pam_lastlog.so {{ debug|default('', true) }}
session		include		system-local-login
