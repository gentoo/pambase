#if HAVE_LIMITS
session		required	pam_limits.so DEBUG
#endif
#if HAVE_ENV
session		required	pam_env.so DEBUG
#endif
#if HAVE_MKTEMP
session		optional	pam_mktemp.so
#endif

/* Only Linux-PAM supports session chain for pam_unix; but if it were
   to not support it for whatever reason, still execute pam_krb5, with
   sufficient level instead. */
#if SUPPORT_UNIX_SESSION
# if HAVE_KRB5
session		KRB5_CONTROL	pam_krb5.so KRB5_PARAMS
# endif
session		required	pam_unix.so DEBUG
#else
# if HAVE_KRB5
session		sufficient	pam_krb5.so KRB5_PARAMS
# endif
#endif

session		optional	pam_permit.so
