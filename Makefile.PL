use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'WebService::Images::IMGSpot',
    VERSION_FROM => 'lib/WebService/Images/IMGSpot.pm', # finds \$VERSION
    AUTHOR       => 'M. Blom (blom@cpan.org)',
    ABSTRACT     => 'upload an image to http://www.imgspot.com/',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                     'LWP::UserAgent' => 0,
                     'HTTP::Response' => 0,
                     'HTTP::Request::Common' => 0,

                    },
);
