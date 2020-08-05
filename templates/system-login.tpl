auth		required	pam_shells.so {{ debug|default('', true) }}
auth		required	pam_nologin.so
auth		include		system-auth
{% if not minimal %}
auth            required        pam_faillock.so preauth silent audit deny=3 unlock_time=600
auth            sufficient      pam_unix.so nullok try_first_pass
auth            [default=die]   pam_faillock.so authfail audit deny=3 unlock_time=600
{% endif %}

account		required	pam_access.so {{ debug|default('', true) }}
account		required	pam_nologin.so
account		include		system-auth
{% if not minimal %}
account         required        pam_faillock.so
{% endif %}

password	include		system-auth
session         optional        pam_loginuid.so
{% if selinux %}
session		required	pam_selinux.so close
{% endif %}

session		required	pam_env.so envfile=/etc/profile.env {{ debug|default('', true) }}
{% if not minimal %}
session		optional	pam_lastlog.so silent {{ debug|default('', true) }}
{% endif %}
session		include		system-auth
{% if selinux %}
 # Note: modules that run in the user's context must come after this line.
session		required	pam_selinux.so multiple open
{% endif %}

{% if not minimal %}
session		optional	pam_motd.so motd=/etc/motd
{% endif %}

{% if not minimal %}
session		optional	pam_mail.so
{% endif %}
