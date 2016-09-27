package t::Util;
use strict;
use warnings;
use Exporter 'import';
use File::Spec;
use File::Basename 'dirname';
use Cwd 'abs_path';

our @EXPORT = qw/config/;
our $CONFIG;

sub config {
    return $CONFIG if $CONFIG;

    my $config_file = File::Spec->catfile(dirname(__FILE__), qw/.. perl-lint.json/);

    open my $jh, '<', $config_file || die $!;
    $CONFIG = JSON->new->decode(do{
        local $/;
        <$jh>;
    });
    close $jh;

    $CONFIG->{targets} = [
        grep {-d $_} map {
            abs_path(File::Spec->catdir(dirname(__FILE__), qw/.. ../, $_));
        } @{$CONFIG->{targets}}
    ];

    $CONFIG;
}

1;