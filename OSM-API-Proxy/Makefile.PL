use strict;
use warnings;
#use ExtUtils::MakeMaker;
use Inline::MakeMaker;
WriteMakefile(
    NAME                => 'OSM::API::Proxy',
    AUTHOR              => q{James Michael DuPont  <JamesMikeDuPont@googlemail.com>},
    VERSION_FROM        => 'lib/OSM/API/Proxy.pm',
    ABSTRACT            => 'a mini perl OSM api server for you to connect your josm to. It will then store the data and act like proxy to multiple osm api servers and also rendering servers and blogs. http://osmopenlayers.blogspot.com/2011/07/fosm-fake-osm-api.html ',
#    ($ExtUtils::MakeMaker::VERSION >= 6.3002      ? ('LICENSE'=> 'perl')      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3030,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'OSM-API-Proxy-*' },
);
