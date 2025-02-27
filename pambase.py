#!/usr/bin/env python3

import argparse
from jinja2 import Template, Environment, FileSystemLoader
import pathlib


def main():
    parser = argparse.ArgumentParser(description='basic Gentoo PAM configuration files')
    parser.add_argument('--gnome-keyring', action="store_true", help='enable pam_gnome_keyring.so module')
    parser.add_argument('--caps', action="store_true", help='enable pam_cap.so module')
    parser.add_argument('--passwdqc', action="store_true", help='enable pam_passwdqc.so module')
    parser.add_argument('--pwhistory', action="store_true", help='enable pam_pwhistory.so module')
    parser.add_argument('--pwquality', action="store_true", help='enable pam_pwquality.so module')
    parser.add_argument('--openrc', action="store_true", help='enable pam_openrc.so module')
    parser.add_argument('--elogind', action="store_true", help='enable pam_elogind.so module')
    parser.add_argument('--systemd', action="store_true", help='enable pam_systemd.so module')
    parser.add_argument('--homed', action="store_true", help='enable pam_systemd_home.so module')
    parser.add_argument('--selinux', action="store_true", help='enable pam_selinux.so module')
    parser.add_argument('--mktemp', action="store_true", help='enable pam_mktemp.so module')
    parser.add_argument('--pam-ssh', action="store_true", help='enable pam_ssh.so module')
    parser.add_argument('--securetty', action="store_true", help='enable pam_securetty.so module')
    parser.add_argument('--shells', action="store_true", help='enable pam_shells.so module')
    parser.add_argument('--sssd', action="store_true", help='enable sssd.so module')
    parser.add_argument('--yescrypt', action="store_true", help='enable yescrypt option for pam_unix.so module')
    parser.add_argument('--sha512', action="store_true", help='enable sha512 option for pam_unix.so module')
    parser.add_argument('--krb5', action="store_true", help='enable pam_krb5.so module')
    parser.add_argument('--minimal', action="store_true", help='install minimalistic PAM stack')
    parser.add_argument('--debug', action="store_true", help='enable debug for selected modules')
    parser.add_argument('--nullok', action="store_true", help='enable nullok option for pam_unix.so module')

    parsed_args = parser.parse_args()
    processed = process_args(parsed_args)

    parse_templates(processed)


def process_args(args):
    # make sure that output directory exists
    pathlib.Path("stack").mkdir(parents=True, exist_ok=True)

    blank_variables = [
        "krb5_authtok",
        "unix_authtok",
        "unix_extended_encryption",
        "likeauth",
        "nullok",
        "local_users_only"
    ]

    # create a blank dictionary
    # then add in our parsed args
    output = dict.fromkeys(blank_variables, "")
    output.update(vars(args))

    # unconditional variables
    output["likeauth"] = "likeauth"
    output["unix_authtok"] = "use_authtok"

    if args.debug:
        output["debug"] = "debug"

    if args.nullok:
        output["nullok"] = "nullok"

    if args.krb5:
        output["krb5_params"] = "{0} ignore_root try_first_pass".format("debug").strip()

    if args.sssd:
        output["local_users_only"] = "local_users_only"

    if args.yescrypt:
        output["unix_extended_encryption"] = "yescrypt shadow"
    elif args.sha512:
        output["unix_extended_encryption"] = "sha512 shadow"
    else:
        output["unix_extended_encryption"] = "md5 shadow"

    return output


def parse_templates(processed_args):
    load = FileSystemLoader('')
    env = Environment(loader=load, trim_blocks=True, lstrip_blocks=True, keep_trailing_newline=True)

    templates = [
        "login",
        "other",
        "passwd",
        "system-local-login",
        "system-remote-login",
        "su",
        "system-auth",
        "system-login",
        "system-services"
    ]

    for template_name in templates:
        template = env.get_template('templates/{0}.tpl'.format(template_name))

        with open('stack/{0}'.format(template_name), "w+") as output:
            rendered_template = template.render(processed_args)

            # Strip all intermediate lines to not worry about appeasing Jinja
            lines = rendered_template.split("\n")
            lines = [line.strip() for line in lines if line]
            rendered_template = "\n".join(lines)

            if rendered_template:
                output.write(rendered_template + "\n")


if __name__ == "__main__":
    main()
