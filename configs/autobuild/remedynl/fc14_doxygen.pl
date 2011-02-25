eval '(exit $?0)' && eval 'exec perl -S $0 ${1+"$@"}'
    & eval 'exec perl -S $0 $argv:q'
    if 0;

# -*- perl -*-
# $Id$
#

require File::Copy;
require File::Path;

local $dont_generate = 0;
local $dont_install = 0;
local $STAGING = '/home/build/ACE/doxygen';
local $MODULE  = 'ACE_wrappers';

$ENV{'PATH'} = $ENV{'PATH'}.':/usr/local/bin';

&parse_args ();

if (!$dont_generate) {
  &generate_doxygen_files()
    || die "Error while generating DOXYGEN files\n";
}

if (!$dont_install) {
  &install_doxygen_files()
    || die "Error while installing DOXYGEN files\n";
}

exit 0;

sub parse_args {
  my @ARGS = ();
  while ($#ARGV >= 0) {
    if (!($ARGV[0] =~ m/^-/)) {
      push @ARGS, $ARGV[0];
    } elsif ($ARGV[0] eq "-dont_generate") {
      $dont_generate = 1;
    } elsif ($ARGV[0] eq "-dont_install") {
      $dont_install = 1;
    } else {
      print "Ignoring option $ARGV[0]\n";
    }
    shift @ARGV;
  }
  @ARGV = @ARGS;
}

sub generate_doxygen_files {
  print "\n The staging is $STAGING";
  chdir $STAGING
    || die "Cannot chdir do staging area\n";
  chdir $MODULE
    || die "Cannot chdir into module\n";

  print "\n#################### Compile (doxygen) ";
  print "[" . (scalar gmtime(time())) . " UTC]\n\n";

  open(GENDOXY, "perl bin/generate_doxygen.pl -verbose -dot_path /usr/bin 2>&1 |")
    || die "Cannot start doxygen generation script\n";
  while (<GENDOXY>) {
    print $_;
  }
  close(GENDOXY)
    || die "Error in doxygen generation script\n";

  return 1;
}

sub install_doxygen_files {
  open(GENDOXY, "rsync --recursive --delete html/* qnap.remedy.nl::Doxygen")
    || die "Cannot start doxygen rsync\n";
  while (<GENDOXY>) {
    print $_;
  }
  close(GENDOXY)
    || die "Error in doxygen generation script\n";

  return 1;
}
