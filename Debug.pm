package DBIx::Recordset::Debug;

use Data::Dumper;
use FileHandle;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '1.1';


# Preloaded methods go here.

sub Debug {
    
    my %param = ( 
	'!Level' => 4,
	'!File'  => '/tmp/dbix-recordset.dbg',
	'!Mode'  => '>'
	);

    my %param_in = @_;

    @param{keys %param_in} = values %param_in;


  print Data::Dumper->Dump([\%param,\%param_in],['param','param_in']);

    $param{'!Mode'} eq '>' || $param{'!Mode'} eq '>>' ||
	die "The !Mode parameter must be one of > or >>";

    ($param{'!Level'} >= 0 && $param{'!Level'} <= 4)  ||
	die "The !Level parameter must be between 0 and 4";

    my $fh = new FileHandle "$param{'!Mode'} $param{'!File'}";
    defined($fh) 
	|| die "Attempt to open filehandle $param{'!File'} failed: $!";

    *DBIx::Recordset::LOG = $fh;
}



# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

DBIx::Recordset::Debug - Perl extension for diverting DBIx::Recordset debug
output to separate files.

=head1 SYNOPSIS

 DBIx::Recordset::Debug::Debug({
     '!Level' => 4,
     '!File'  => $log_file{$_},
     '!Mode'  => '>'
     });


=head1 DESCRIPTION

C<Debug> is to be called just before you call your accessor method (an
accessor method being Setup/Insert/Search/Update/Delete) in order to stream
debugging output for that particular accessor method to a particular file
at a particular debug level.

If called with no arguments the default values are debug level 4, output file
'/tmp/dbi-recordset.dbg', and write mode overwrite.

=head1 EXAMPLE

{ use DBIx::Recordset::Debug

package company::database;

 DBIx::Recordset::Debug::Debug({
     '!Level' => 4,
     '!File'  => $log_file{$_},
     '!Mode'  => '>'
     });

  *{$handle{$_}} = 
    DBIx::Recordset->Setup({
	%dsn, 
	'!Writemode' => $write_mode{$_}, 
	'!Tables' => $table_access{$_}
    }) for (keys $write_mode); }

The C<!File> and C<!Mode> arguments are passed directly on to the 
FileHandle module and will take either the overwrite or append syntax.
Other syntaxes are rejected.

=cut

=head1 AUTHOR

Terrence M. Brannon <princepawn@yahoo.com>

=cut
