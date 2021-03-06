#!/usr/bin/perl
#-------------------------------------------------------------------------------
# (c) Administrator yafra, yafra.org, 2002, Switzerland
#
# function: create schema files from a MS SQL Server schema for C#
#
# argument: none
#
# needed modules: DBI, XML
#
# CVS tag:   $Name:  $
# author:    $Author: mwn $
# revision:  $Revision: 1.1 $
#-------------------------------------------------------------------------------
use DBI;
use IO;
use XML::Writer;

my $debugflag = 1;
my $dbd = "dbi:ODBC:driver={SQL Server};database=traveldb;server=localhost;uid=root;pwd=root";

&db_readtables;
&db_readviews;

# read all root tables for converting
sub db_readtables
{
	use vars qw($dbh);
	use vars qw($dbh2);
	use vars qw($sth);
	use vars qw($sth2);
	use vars qw($output);
	use vars qw($writer);

	my $outputfile = "tdb-c-tables.xsd";
	my $outputfileds = "tdb-ds-tables.xsd";

	$dbh = DBI->connect($dbd) ||
		die "Error connecting $DBI::errstr\n";;
	$dbh2 = DBI->connect($dbd) ||
		die "Error connecting $DBI::errstr\n";;

	# SQL Server
	# get uid from select * from sysusers
	$stmt = "select name, id from sysobjects where xtype = 'U' and uid = 5";
	$sth = $dbh->prepare($stmt);
	$sth->execute();
	if ($DBI::err)
		{
		db_debug("error in selecting ROOT tables: $DBI::errstr");
		}

	# create XSD file header for classes
	open(XSDFILE,">".$outputfile);
	print XSDFILE <<EOF;
<?xml version="1.0" standalone="yes" ?>
<xs:schema id="traveldb" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
EOF
	# create XSD file header for dataset
	open(XSDFILEDS,">".$outputfileds);
	print XSDFILEDS <<EOF;
<?xml version="1.0" standalone="yes" ?>
<xs:schema id="traveldb" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
EOF

	# start fetching data
	db_debug("lese alle ROOT tabellen");
	while (($table, $tid) = $sth->fetchrow)
		{
		if ($DBI::err)
			{
			db_debug("error fetching for tables in dba_tables $DBI::errstr");
			}
		db_debug("- Tabelle: $table ID: $tid");

		print XSDFILE <<EOF;
	<xs:element name="$table" msdata:IsDataSet="false" msdata:Locale="de-CH">
		<xs:complexType>
			<xs:sequence>
EOF
#		my $dstable = $table."DS";
		print XSDFILEDS <<EOF;
	<xs:element name="$table" msdata:IsDataSet="true" msdata:Locale="de-CH">
		<xs:complexType>
			<xs:choice maxOccurs="unbounded">
				<xs:element name="$table">
					<xs:complexType>
						<xs:sequence>
EOF
		# pro table ein describe und dump in ein schema
		$stmt = "select name, xusertype, length from syscolumns where id = '$tid'";
		$sth2 = $dbh2->prepare($stmt);
		$sth2->execute();
		if ($DBI::err)
			{
			db_debug("error in describing table: $DBI::errstr");
			}
		db_debug("- Tabellendetails for $table");
		while (($name, $typ, $len) = $sth2->fetchrow)
			{
			if ($DBI::err)
				{
				db_debug("error fetching for tables in dba_tables $DBI::errstr");
				}
#			db_debug("-    $name $typ $len");
			print XSDFILE "						<xs:element name=\"$name\"";
			print XSDFILEDS "						<xs:element name=\"$name\"";
			if ($typ eq "56")
				{
				print XSDFILE ' type="xs:decimal" minOccurs="0" />';
				print XSDFILEDS ' type="xs:decimal" minOccurs="0" />';
				}
			elsif ($typ eq "62")
				{
				print XSDFILE ' type="xs:double" minOccurs="0" />';
				print XSDFILEDS ' type="xs:double" minOccurs="0" />';
				}
			elsif ($typ eq "61")
				{
				print XSDFILE ' type="xs:dateTime" minOccurs="0" />';
				print XSDFILEDS ' type="xs:dateTime" minOccurs="0" />';
				}
			else # type 167
				{
				print XSDFILE ' type="xs:string" minOccurs="0" />';
				print XSDFILEDS ' type="xs:string" minOccurs="0" />';
				}
			print XSDFILE "\n";
			print XSDFILEDS "\n";
			}
		$sth2->finish;
		print XSDFILE <<EOF;
			</xs:sequence>
		</xs:complexType>
	</xs:element>
EOF
		print XSDFILEDS <<EOF;
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:choice>
		</xs:complexType>
	</xs:element>
EOF
		}
	$sth->finish;
	$dbh->commit;

	# write XSD footer
	print XSDFILE <<EOF;
</xs:schema>
EOF
	close(XSDFILE);
	system("xsd.exe \/c \/l:CS $outputfile");

	# write XSD dataset footer
	print XSDFILEDS <<EOF;
</xs:schema>
EOF
	close(XSDFILEDS);
	system("xsd.exe \/d \/l:CS $outputfileds");

	# chek DBD driver
	db_debug("  closing db handle");

	# disconnect as SYSTEM user from the DB
	$dbh->disconnect;

	return;
}

# read all root tables for converting
sub db_readviews
{
	use vars qw($dbh);
	use vars qw($dbh2);
	use vars qw($sth);
	use vars qw($sth2);
	use vars qw($output);
	use vars qw($writer);

	my $outputfile = "tdb-c-views.xsd";
	my $outputfileds = "tdb-ds-views.xsd";

	$dbh = DBI->connect($dbd) ||
		die "Error connecting $DBI::errstr\n";;
	$dbh2 = DBI->connect($dbd) ||
		die "Error connecting $DBI::errstr\n";;

	# select table_name, owner from dba_tables where owner = 'ROOT'
	$stmt = "select name, id from sysobjects where xtype = 'V' and uid = 5";
	$sth = $dbh->prepare($stmt);
	$sth->execute();
	if ($DBI::err)
		{
		db_debug("error in selecting ROOT views: $DBI::errstr");
		}

	# create XSD file header
	open(XSDFILE,">".$outputfile);
	print XSDFILE <<EOF;
<?xml version="1.0" standalone="yes" ?>
<xs:schema id="traveldb" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
EOF
	# create XSD file header
	open(XSDFILEDS,">".$outputfileds);
	print XSDFILEDS <<EOF;
<?xml version="1.0" standalone="yes" ?>
<xs:schema id="traveldb" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
EOF

	db_debug("lese alle ROOT vies");
	while (($table, $tid) = $sth->fetchrow)
		{
		if ($DBI::err)
			{
			db_debug("error fetching for views in dba_views $DBI::errstr");
			}
		db_debug("- View: $table ID: $tid");

		print XSDFILE <<EOF;
	<xs:element name="$table" msdata:IsDataSet="false" msdata:Locale="de-CH">
		<xs:complexType>
			<xs:sequence>
EOF
#		my $dstable = $table."DS";
		print XSDFILEDS <<EOF;
	<xs:element name="$table" msdata:IsDataSet="true" msdata:Locale="de-CH">
		<xs:complexType>
			<xs:choice maxOccurs="unbounded">
				<xs:element name="$table">
					<xs:complexType>
						<xs:sequence>
EOF

		# pro table ein describe und dump in ein schema
		$stmt = "select name, xusertype, length from syscolumns where id = '$tid'";
		$sth2 = $dbh2->prepare($stmt);
		$sth2->execute();
		if ($DBI::err)
			{
			db_debug("error in describing table: $DBI::errstr");
			}
		db_debug("- Viewdetails for $table $tid");
		while (($name, $typ, $len) = $sth2->fetchrow)
			{
			if ($DBI::err)
				{
				db_debug("error fetching for tables in dba_tables $DBI::errstr");
				}
#			db_debug("-    $name $typ $len");
			print XSDFILE "						<xs:element name=\"$name\"";
			print XSDFILEDS "						<xs:element name=\"$name\"";
			if ($typ eq "56")
				{
				print XSDFILE ' type="xs:decimal" minOccurs="0" />';
				print XSDFILEDS ' type="xs:decimal" minOccurs="0" />';
				}
			elsif ($typ eq "62")
				{
				print XSDFILE ' type="xs:double" minOccurs="0" />';
				print XSDFILEDS ' type="xs:double" minOccurs="0" />';
				}
			elsif ($typ eq "61")
				{
				print XSDFILE ' type="xs:dateTime" minOccurs="0" />';
				print XSDFILEDS ' type="xs:dateTime" minOccurs="0" />';
				}
			else
				{
				print XSDFILE ' type="xs:string" minOccurs="0" />';
				print XSDFILEDS ' type="xs:string" minOccurs="0" />';
				}
			print XSDFILE "\n";
			print XSDFILEDS "\n";
			}
		$sth2->finish;

		print XSDFILE <<EOF;
			</xs:sequence>
		</xs:complexType>
	</xs:element>
EOF
		print XSDFILEDS <<EOF;
						</xs:sequence>
					</xs:complexType>
				</xs:element>
			</xs:choice>
		</xs:complexType>
	</xs:element>
EOF
		}
	$sth->finish;

	# write XSD footer
	print XSDFILE <<EOF;
</xs:schema>
EOF
	close(XSDFILE);
	system("xsd.exe \/c \/l:CS $outputfile");

	# write XSD footer
	print XSDFILEDS <<EOF;
</xs:schema>
EOF
	close(XSDFILEDS);
	system("xsd.exe \/d \/l:CS $outputfileds");

	# chek DBD driver
	db_debug("  closing db handle");

	# disconnect as SYSTEM user from the DB
	$dbh->disconnect;

	return;
}


#----------------------------------------------------------
#
# INTERNAL functions
#
#----------------------------------------------------------
sub db_debug
{
	# read function arguments
	my ($message) = @_;

	if ($debugflag)
		{
		print "debug: $message\n";
		}
}
