package Net::Dynect::REST::NodeList;
# $Id: NodeList.pm 177 2010-09-28 00:50:02Z james $
use strict;
use warnings;
use Carp;
use Net::Dynect::REST::RData;
our $VERSION = do { my @r = (q$Revision: 177 $ =~ /\d+/g); sprintf "%d."."%03d" x $#r, @r };

=head1 NAME 

Net::Dynect::REST::NodeList - List all objects against a node

=head1 SYNOPSIS

  use Net::Dynect::REST:NodeList;
  my @records = Net::Dynect::REST:NodeList->delete(connection => $dynect, 
                                           zone => $zone, fqdn => $fqdn);

=head1 METHODS

=head2 Creating

=over 4

=item  Net::Dynect::REST:ANYRecord->find(connection => $dynect, zone => $zone, fqdn => $fqdn);

This will return an array of objects that match the Name and Zone.

=cut

sub find {
    my $proto = shift;
    my %args  = @_;
    if (
        not( defined( $args{connection} )
            && ref( $args{connection} ) eq "Net::Dynect::REST" )
      )
    {
        carp "Need a connection (Net::Dynect::REST)";
        return;
    }
    if ( not( defined $args{zone} ) ) {
        carp "Need a zone to look in";
        return;
    }
    # FQDN is optional
    my $request = Net::Dynect::REST::Request->new(
        operation => 'read',
        service   => sprintf( "%s/%s", __PACKAGE__->_service_base_uri, $args{zone}) . (defined($args{fqdn})? "/" . $args{fqdn} : "")
    );
    if ( not $request ) {
        carp "Request not valid: $request";
        return;
    }

    my $response = $args{connection}->execute($request);

    if ($response->status !~ /^success$/i) {
	carp $response;
        return;
    }

    my @nodes;
    foreach (@{$response->data}) {
        push @nodes, $_->value;
    }
    return @nodes;
}


sub _service_base_uri {
  return "NodeList";
}

1;

=back

=head1 AUTHOR

James Bromberger, james@rcpt.to

=head1 SEE ALSO

L<Net::Dynect::REST>, L<Net::Dynect::REST::Request>, L<Net::Dynect::REST::Response>, L<Net::Dynect::REST::info>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by James Bromberger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
