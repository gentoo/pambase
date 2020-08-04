auth		required	pam_env.so {{ debug|default('', true) }}
{% if pam_ssh -%}
auth		sufficient	pam_ssh.so
{% endif -%}

{% if krb5 -%}
auth        [success=1 default=ignore]      pam_krb5.so {{ krb5_params }}
{% endif -%}

auth		required	pam_unix.so try_first_pass {{ likeauth }} {{ nullok|default('', true) }} {{ debug|default('', true) }}
auth		optional	pam_permit.so
{% if not minimal -%}
auth            required        pam_faillock.so preauth silent audit deny=3 unlock_time=600
auth            sufficient      pam_unix.so {{ nullok|default('', true) }} try_first_pass
auth            [default=die]   pam_faillock.so authfail audit deny=3 unlock_time=600
{% endif -%}

{% if krb5 -%}
account		[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif -%}
account		required	pam_unix.so {{ debug|default('', true) }}
account		optional	pam_permit.so
{% if not minimal -%}
account         required        pam_faillock.so
{% endif -%}

{% if passwdqc -%}
password	required	pam_passwdqc.so min=8,8,8,8,8 retry=3
{% endif -%}

{% if krb5 -%}
password	[success=1 default=ignore]	pam_krb5.so {{ krb5_params }}
{% endif -%}

password	required	pam_unix.so try_first_pass {{ unix_authtok|default('', true) }} {{ nullok|default('', true) }} {{ unix_extended_encryption|default('', true) }} {{ debug|default('', true) }}
password	optional	pam_permit.so

{%- if pam_ssh %}
session		optional	pam_ssh.so
{% endif -%}

{% if systemd -%}
-session        optional        pam_systemd.so
{% endif -%}

{% if elogind -%}
-session        optional        pam_elogind.so
{% endif -%}

{% if libcap -%}
-session        optional        pam_libcap.so
{% endif -%}

{% include "templates/system-session.tpl" %}
