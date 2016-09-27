use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/.. local lib perl5/),
);
use Test::More;
use Test::Perl::Lint;
use JSON;

my $config_file = File::Spec->catfile(dirname(__FILE__), qw/.. perl-lint.json/);

open my $jh, '<', $config_file || die $!;
my $config = JSON->new->decode(do{
    local $/;
    <$jh>;
});
close $jh;

$config->{targets} = [
    grep {-d $_} map {
        File::Spec->catdir(dirname(__FILE__), qw/.. ../, $_);
    } @{$config->{targets}}
];

diag 'Start to lint...';

subtest 'Lint' => sub {
    all_policies_ok($config);
};

done_testing;