session		required	pam_limits.so {{ debug }}
session		required	pam_env.so {{ debug }}
{% if mktemp %}
session		optional	pam_mktemp.so
{% endif %}

{%if krb5 %}
session		[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif %}

{% if homed %}
session		[success=1 default=ignore]	pam_systemd_home.so
{% endif %}

session		required	pam_unix.so {{ debug }}

{% if sssd %}
session		optional	pam_sss.so {{ debug }}
{% endif %}
