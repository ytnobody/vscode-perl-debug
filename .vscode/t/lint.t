use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/../),
    File::Spec->catdir(dirname(__FILE__), qw/.. local lib perl5/),
);
use Test::More;
use Test::Perl::Lint;
use JSON;
use t::Util;

my $config = config();

subtest 'lint check' => sub {
    all_policies_ok($config);
};

done_testing;