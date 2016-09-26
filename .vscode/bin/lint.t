use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/.. local lib perl5/),
);
use Test::More;
use Test::Perl::Lint;

my @targets = grep {-d $_} map {File::Spec->catdir(dirname(__FILE__), qw/.. ../, $_)} qw[
    lib
    t 
    bin 
    script
];

if (scalar(@targets) < 1) {
    plan(skip_all => 'target is not found');
}

all_policies_ok({
    targets         => [@targets],
    ignore_files    => [],
    filter          => ['LikePerlCritic::Stern'],
    ignore_policies => ['Modules::RequireVersionVar'], 
});

done_testing;