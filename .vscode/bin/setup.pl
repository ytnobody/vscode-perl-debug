use strict;
use warnings;
use File::Basename 'dirname';
use File::Spec;

my $extdir = File::Spec->catdir(dirname(__FILE__), qw/../);
my $extlib = File::Spec->catdir(dirname(__FILE__), qw/.. local/); 
system("cpanm --installdeps -l $extlib $extdir");
