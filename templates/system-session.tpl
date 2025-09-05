session		required	pam_limits.so {{ debug }}
{% if mktemp %}
session		optional	pam_mktemp.so
{% endif %}
session		required	pam_env.so {{ debug }}

{%if krb5 %}
session		[success=1 default=ignore]	pam_krb5.so {{ debug }} ignore_root try_first_pass
{% endif %}

{% if homed %}
session		[success=1 default=ignore]	pam_systemd_home.so
{% endif %}

session		required	pam_unix.so {{ debug }}

{% if sssd %}
session		optional	pam_sss.so {{ debug }}
{% endif %}
