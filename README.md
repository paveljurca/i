# i — does the file path exist on a remote PC?

Test for arbitrary system file (or directory or desktop shortcut) paths exist on a remote PC.

It comes handy in work or school environments to know the program (usually some executable file) is present — as it probably should (for example after network un/installations or remote deployments).

For simple maintenance it uses a __CSV file__ to store the full file paths to check upon.

__Output:__

    jm361h01   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h02   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | OK
    jm361h03   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | OK
    jm361h04   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h05   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h06   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h07   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h08   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | OK
    jm361h09   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | PC off
    jm361h10   | C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE | OK

__Dependency:__

[PsExec](https://technet.microsoft.com/en-us/sysinternals/pxexec.aspx) or [PAExec](https://github.com/poweradminllc/PAExec)
(download it and put it in the **current** folder).

For PsExec to work, __the following is required__:

* __File and Printer Sharing__ enabled
* __browser__, __server__, __lmhosts__ and __lanmanworkstation__ services running
* Default __Admin$ share__ enabled
* Remote UAC __LocalAccountTokenFilterPolicy__ enabled
* Local administrative privileges on the remote system (tip: cmdkey.exe)

<https://stackoverflow.com/questions/828432/psexec-access-denied-errors>

## SYNOPSIS

Run `i.exe >installed.txt` as Administrator

## DOWNLOAD

[v0.1.0](https://github.com/paveljurca/i/releases/tag/v0.1.0)

## NOTES

* If you omit the computer name PsExec runs the application on the local system
* For network drives login explicitly, i.e. `-u [user] -p [password]` options

## RELEASE NOTES

* PsExec does NOT send passwords in clear text as of v2.1, see <https://blogs.technet.microsoft.com/sysinternals/2014/03/07/updates-process-explorer-v16-02-process-monitor-v3-1-psexec-v2-1-sigcheck-v2-03/>
* PsExec starts the PSEXESVC service on the remote system (if hungs up use `sc.exe` or `pskill.exe` to kill it)
* <http://windowsitpro.com/systems-management/psexec>
* <https://forum.sysinternals.com/faq-common-pstools-issues_topic15920.html>

## TODO

- [ ] sort ascending
- [ ] directory is NON empty
- [ ] support for multiple values (delimiters: `space`, `comma` or `asterisk` for all)
- [ ] command-line invocation
- [ ] check files exist without actually listing full paths (must be in `%PATH%`)

    ```perl
    system(qw(where /r "%ProgramFiles(x86)%" /q), 'winword.exe') or say "winword.exe OK";
    my @whereis = split /\r?\n/, qx(where /r "%SystemDrive%" $file 2>NUL:), say $? >> 8 == 0 ? "found" : "not found";
    ```

## LICENSE

Released into the public domain.

## DISCLAIMER

Don't blame me.
