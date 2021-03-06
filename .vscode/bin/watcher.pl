use strict;
use warnings;
use File::ChangeNotify;
use File::Basename 'dirname';
use File::Spec;
use Cwd 'abs_path';

our $tester = abs_path(File::Spec->catdir(dirname(__FILE__), qw/.. t/));

my ($watchpath) = @ARGV;
$watchpath ||= '.';
my $watcher = File::ChangeNotify->instantiate_watcher(
    directories => [$watchpath],
    filter      => qr/\.(?:pm|pl|conf|t)/
);

while (my @events = $watcher->wait_for_events) {
    sleep 1;
    if (grep {$_->type eq 'modify'} @events) { 
        system('prove', $tester);
    }
}
