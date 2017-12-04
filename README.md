# i

Test for arbitrary system file paths (directories or shortcuts) exist on a remote PC.

It comes handy in work or school environments to know whether the given software (usually EXE file) is present as it probably should (for example after the network installation or remote deployment).

For simple maintenance it uses a CSV file to store a listings of software to check upon.

__Dependency:__

[PsExec](https://technet.microsoft.com/en-us/sysinternals/pxexec.aspx) or [PAExec](https://github.com/poweradminllc/PAExec)

For PsExec to work, __the following is required__:

* __File and Printer Sharing__ enabled
* __browser__, __server__, __lmhosts__ and __lanmanworkstation__ services running
* Default __Admin$ share__ enabled
* Remote UAC __LocalAccountTokenFilterPolicy__ enabled
* Local administrative privileges on the remote system (tip: cmdkey.exe)

<https://stackoverflow.com/questions/828432/psexec-access-denied-errors>

## SYNOPSIS

Run `i.exe` as Administrator

## RELEASE NOTES

You may alter the script to basically run anything remotely.

* PsExec does NOT send passwords in clear text as of v2.1, see <https://blogs.technet.microsoft.com/sysinternals/2014/03/07/updates-process-explorer-v16-02-process-monitor-v3-1-psexec-v2-1-sigcheck-v2-03/>
* PsExec starts the PSEXESVC service on the remote system (might need to kill it with `sc.exe` or `pskill.exe`)
* <http://windowsitpro.com/systems-management/psexec>
* <https://forum.sysinternals.com/faq-common-pstools-issues_topic15920.html>

## TODO

- [ ] sort ascending
- [ ] directory is NON empty
- [ ] support for multiple values (delimiters: `space`, `comma` or `asterisk` for all)
- [ ] command-line invocation

## NOTES

Eventually check that the remote filepaths exist just by listing the filenames without full paths (expects `%PATH%`):

`system(qw(where /r "%ProgramFiles(x86)%" /q), 'winword.exe') or say "winword.exe OK"`

`my @whereis = split /\r?\n/, qx(where /r "%SystemDrive%" $exe 2>NUL:); say $? >> 8 == 0 ? "found" : "not found"`

## LICENSE

Released into the public domain.

## DISCLAIMER

Don't blame me.
