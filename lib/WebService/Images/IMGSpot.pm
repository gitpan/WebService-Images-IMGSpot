package WebService::Images::IMGSpot;

use strict;
use Carp;
use HTTP::Response;
use HTTP::Request::Common;
use LWP::UserAgent;

our $VERSION = '0.02';

sub new {
   my ($class, %attrs) = @_;

   my $self = bless ({}, ref ($class) || $class);

   if(ref($attrs{'lwp_ua'}) && $attrs{'lwp_ua'}->isa('LWP::UserAngent')) {
      $self->ua($attrs{'lwp_ua'});
   } else {
      my $ua = LWP::UserAgent->new(
         'agent'      => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
         'timeout'    => 60*5,
         'keep_alive' => 10,
      );
      $self->ua($ua);
   }

   return $self;
}

sub _get_submit_url {
   my $self = shift;
   my $rsp  = $self->ua->get('http://www.imgspot.com/');
   if($rsp->is_success) {
      if($rsp->content =~ m!<form action="([^"]+)" method="post"!) {
         return $1;
      }
   } 
   croak('Could not access www.imgspot.com to find submit URL');
}

sub ua {
   my ($self, $ua) = @_;
   if(ref($ua) && $ua->isa('LWP::UserAgent')){
      $self->{'_ua'}=$ua;
   }
   return $self->{'_ua'};
}

sub host {
   my $self = shift;
   return $self->upload(@_);
}

sub upload {
   my ($self, $input) = @_;
   my $file = (ref $input eq 'HASH') ? $input->{'file'} : $input;

   # Do some checks
   croak('No filename given') unless($file);
   croak("File $file does not exist (or is not readable)") unless(-r $file);
   croak("File $file is too large in size to upload")
      if ( (stat($file))[7] > (650 * 1024) );

   # Guess we're ready to go!
   my @params = (
      $self->_get_submit_url,
      'Content_Type' => 'form-data',
      'Content' => [ ( image => [ $file ] ) ]
   );
   my $req = HTTP::Request::Common::POST(@params);
   my $rsp = $self->ua->request($req); 

   # Let's see how that went
   if($rsp->as_string =~ m#^Location:\s.+/Success.php\?URL=(.+)$#m) {
         return $self->url($1);
   } else {
      croak('Could not post image to IMGSpot: ',$rsp->status_line);
   }
}

sub url {
   my ($self, $url) = @_;
   $self->{'_url'} = $url if($url);
   return $self->{'_url'};
}


#################### main pod documentation begin ###################
=head1 NAME

WebService::Images::IMGSpot - upload an image to http://www.imgspot.com/

=head1 SYNOPSIS

  use WebService::Images::IMGSpot;
  
  my $imgspot = WebService::Images::IMGSpot->new();
     $imgspot->upload({ file => '/path/to/file.png' });
  
  # ... or
  
     $imgspot->upload('/path/to/yet_another_file.png');
     $imgspot->host('/path/to/yet_another_file.png');

=head1 DESCRIPTION

C<WebService::Images::IMGSpot> uploads a file to 
L<http://www.imgspot.com/> for you, as long as the file is not bigger
than 650 KB, and the format is .JPG, .JPEG, .GIF, and .PNG.

=head2 METHODS

=head3 new

C<new> creates a new WebService::Images::IMGSpot object.

=head4 options

=over 4 

=item user_agent

Returns or sets the LWP::UserAgent object used internally so that it 
can the customised.

=back

=head3 upload

This method takes either a scalar (like L<Image::ImageShack>) or
a hashref (like L<WebService::Images::Nofrag>). It will do some basic
checking and croaks where it sees fit ;-)

The method returns the URL of where your image is hosted.

=head3 host

An alias for the method upload (just like L<Image::ImageShack>.

=head3 url

C<url> is a method that can be called after upload, to retrieve the
URL to the hosted image (just like L<WebService::Images::Nofrag>).

=head1 BUGS

Please report any found bugs to
L<http://rt.cpan.org/Public/Dist/Display.html?Name=WebService-Images-IMGSpot>
or contact the author.

=head1 AUTHOR

M. Blom, 
E<lt>blom@cpan.orgE<gt>, 
L<http://menno.b10m.net/perl/>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

B<NOTE>: Please see L<http://www.imgspot.com/TOS.php> for the
Terms of Service of IMGSpot.

=head1 SEE ALSO

=over 4

=item * L<http://www.imgspot.com/>

=item * L<Image::ImageShack>, L<WebService::Images::Nofrag>

=cut

#################### main pod documentation end ###################

1;
