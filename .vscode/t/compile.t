use strict;
use warnings;
use Test::More;
use Test::Exception;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/../),
    File::Spec->catdir(dirname(__FILE__), qw/.. local lib perl5/),
);
use File::Find;
use JSON;
use t::Util;
use Proc::Simple;
use File::Temp 'tempdir';

sub compile_check {
    my $file   = shift;

    my $outdir = tempdir(CLEANUP => 1);
    my $stdout = File::Spec->catfile($outdir, qw/stdout/);
    my $stderr = File::Spec->catfile($outdir, qw/stderr/);

    my $proc   = Proc::Simple->new;
    $proc->redirect_output($stdout, $stderr);
    $proc->start("perl", "-wc", $file);
    $proc->wait;

    open my $fh, '<', $stderr or die $!;
    my $err = do {local $/; <$fh>};
    close $err;

    is $err, "$file syntax OK\n", "$file syntax OK";
}

my $config = config();
my $search_script = sub {compile_check($File::Find::name) if $File::Find::name =~ /\.(?:pl|pm|conf|t)/};

subtest 'compile check' => sub {
    find({wanted => $search_script, no_chdir => 1}, @{$config->{targets}});
};

done_testing;