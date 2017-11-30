use 5.016;

use strict;
use warnings;
use open qw(:std :utf8);
use utf8;

use File::Basename;
use File::Spec::Functions;

print<<'EOL';
*****************
(JM) SW na učebně

v0.1, Pavel Jurca
*****************

EOL

#========= MAIN ===========

# base dir
my $root = catdir(dirname($0), 'i');

i();

#==========================

sub i {
  # setup
  my @rooms     = ([jm357 => 20], [jm359 => 20], [jm360 => 20], [jm361 => 20], [jm382 => 25], [jm352 => 50]);
  my @programs  = CSV(catfile($root, 'i.csv'));

  # make a choice
  my $room    = $rooms[choice(@rooms)];
  my $program = $programs[choice(@programs)];

  for my $pc (1..$$room[1]) {
    my $hostname = qq($$room[0]h) . sprintf "%02d", $pc;

    printf " %-10s | %-20s | %s\n",
      $hostname,
      $program->[1],
      ""#$psexec($hostname, $program->{path})
    ;
  }
}

sub sudo {
  open my $sudo, '>', catpath($ENV{SYSTEMDRIVE}, 'whoami.tmp');
}

sub psexec {
  # Am I elevated?
  sudo() or error('Spustit jako Administrátor');

  my $remote  = shift;
  my $file    = shift;
  my $timeout = 5;

  my $runas = {
      admin => '-h', # elevated (Vista or higher)
      user  => '-l', # running with least privilege
    default => '',
  };
  my %SIG = {
    0   => 'OK',
    69  => 'chybí (!)',
    53  => 'vypnuté PC',
    3   => 'zamítnuto',
  };

  system catfile($root, 'PsExec.exe'),
      qq(\\\\$remote),
      qw(-accepteula -nobanner -n),
      $timeout, $runas->{default},
      qw(cmd /Q /C dir /a:), qq("$file"), qw(>NUL: 2>&1);

  my $sig = $? >> 8;
  error("PsExec chybí: $!") if ($? == -1);

  return $SIG{$sig} // 'chyba';
}

sub CSV {
  my $csv = shift;

  open my $in, '<:utf8', $csv
    or error(qq("$csv" nenalezen));

  my @values;
  while (defined(my $line = <$in>)) {
    next if $line =~ /^\s*$/;

    my ($program, $path) = map {
      error(qq("$csv" obsahuje chyby, řádek $.)) unless $_;
      s/^\s+|\s+$//gr;
    } (split ',', $line, 2)[0..1];

    push @values, [ $program, $path ];
  }
  close $in;

  return @values;
}

sub error {
  print "\n(err) ", shift, "\n\n";
  exit 2;
}

=head2 choice

Wait for a user choice

in:   list of options
out:  array index

=cut

sub choice {
  my $i;
  my %option = map { ++$i => $_->[0] } @_;

  # print to STDERR
  my $std = select STDERR;

  # TODO sort { fc($$a[0]) cmp fc($$b[0]) }
  print qq(($_) $option{$_}\n) for sort keys %option;

  print qq(\nVyberte číslem (N): );
  chomp(my $input = <STDIN>),print "\n";

  # back to the future
  select $std;

  # array index
  die "Neplatná volba\n" unless exists $option{$input};
  return $input-1;
}
