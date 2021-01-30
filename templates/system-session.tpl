session		required	pam_limits.so {{ debug|default('', true) }}
session		required	pam_env.so {{ debug|default('', true) }}
{% if mktemp %}
session		optional	pam_mktemp.so
{% endif %}

{%if krb5 %}
session		[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
session         [success=1 default=ignore]      pam_systemd_home.so
{% endif %}

session		required	pam_unix.so {{ debug|default('', true) }}
