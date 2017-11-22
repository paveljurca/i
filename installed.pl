use 5.014;

use strict;
use warnings;
use open qw(:std :utf8);

print<<'EOL';
Installed.exe, v0.1

  Zkontroluje instalaci zvoleneho SW na dane ucebne

EOL

# Am I elevated?
sudo() or error('Nemate potrebna opravneni');


my @ucebny   = ([jm357 => 20], [jm359 => 20], [jm360 => 20], [jm361 => 20], [jm382 => 25]);
my @programy = @{ programs_list('programy_jm.csv') };


my $ucebna   = $ucebny[choice(\@ucebny)];
# ask user to make a choice out of listed SW
my $program = $programy[choice(map { $_->{installed} } @programy)];

# check for SW installed in the given room
psexec($ucebna, $program->{path}) and <STDIN>;


#======================================

sub sudo {
  open my $sudo, '>', 'C:\\whoami.tmp';
}

sub psexec {
  my $ucebna  = shift;
  my $program = shift;

  my $timeout = 10;
  my @stanice = map {sprintf "%{s}h%02d", ${ucebna}->[0], $_} 1..$ucebna->[1];

  my $runas = {
      admin => '-h', # elevated (Vista or higher)
      user  => '-l', # running with least privilege
    default => '',
  };

  my $SIG = {
    0 => 'OK',
    69 => '-',
    53 => 'vypnute PC',
    3 => 'zamitnuto',
    -1 => 'chyba',
  };

  # column width
  my $col = 30;

  
  sprintf "%${col}s%s\n", '', $program->[1];

  for (@stanice) {

    sprintf "%${col}s", $_;
    system q(psexec.exe),
        qq(\\\\$_),
        qw(-accepteula -nobanner -n),
        $timeout, $runas->{default},
        qw(cmd /Q /C dir /a:), qq("$cesta"), qw(>NUL: 2>&1);

    error("psexec missing: $!") if ($? == -1);

    my $sig = $? >> 8;
    sprintf "%${col}s\n", $SIG{$sig};
  }


  return 1;
}

sub programs_list {
  my $csv = shift;
 
  open my $in, '<:utf8', $csv
    or error(qq(Soubor "$csv" nenalezen));

  my @programy = map {
    my ($program, $cesta) = map {s/^\s+|\s+$//g; $_} split /,/;

    eval {
      no warnings 'all';
      $program && $cesta;
    };
    error(qq(Soubor "$csv" obsahuje chyby)) if $@;

    { installed => $program, path => $cesta };
  } <$in>;

  close $in;

  return @programy;
}

sub error {
  print "\n(err) ", shift, "\n\n";
  <STDIN> and exit 2;
}

=head2 choice

Wait for a user choice

in:   list of options
out:  array index

=cut

sub choice {
  my %option = map { state $i; ++$i => $_ } @_;

  # print to STDERR
  my $std = select STDERR;

  say qq(($_) $option{$_}) for sort keys %option;
  print qq(\nSelect by number (N): );
 
  # back to the future
  select $std;

  chomp(my $input = <STDIN>);
  die "Invalid option\n" unless exists $option{$input};

  # array index
  return $input-1;
}
