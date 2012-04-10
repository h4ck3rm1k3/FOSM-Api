#!/usr/bin/env perl
use lib '/home/h4ck3rm1k3/perl5/lib/perl5';

use Dancer ':syntax';
use FindBin '$RealBin';
use Plack::Runner;
use Dancer;
use Cwd qw( realpath );
my $app = sub {	
    my $env = shift;
    my $appdir = realpath( "$FindBin::Bin/.." );
    setting(
	appname => 'MyApp',
	appdir => $appdir,
        );
    load_app 'PlanetIndex';
    config->{environment} = 'test';
    Dancer::Config->load;
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance( $request );

};

Plack::Runner->run($app);
