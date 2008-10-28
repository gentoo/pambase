#if HAVE_LIMITS
session		required	pam_limits.so DEBUG
#endif
#if HAVE_ENV
session		required	pam_env.so DEBUG
#endif
#if HAVE_MKTEMP
session		optional	pam_mktemp.so
#endif
#if SUPPORT_UNIX_SESSION
session		required	pam_unix.so DEBUG
#endif
session		optional	pam_permit.so
