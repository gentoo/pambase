session		required	pam_limits.so {{ debug|default('', true) }}
session		required	pam_env.so {{ debug|default('', true) }}
{% if mktemp %}
session		optional	pam_mktemp.so
{% endif %}

{%if krb5 %}
session		[success=1 default=ignore] {{ krb5_params }}
{% endif %}

session		required	pam_unix.so {{ debug|default('', true) }}
{%if krb5 %}
session         [success=1 default=ignore] {{ krb5_params }}
{% endif %}

session		optional	pam_permit.so
