#! /usr/bin/perl -w

use strict;
use warnings;

use Data::Faker;

#
# Parses the .js file for the Twain apartment building.
#
# This depends upon Data::Faker; run 'cpan -T Data::Faker' to install this module.
# The "-T" omits testing; not certain why the built-in testing fails for Data::Faker,
# though the randomness may have something to do with it.
#
# This also requires the existence of a bwod-data directory in the current working directory.
#
# Author: Branden Ogata
# 

open TWAIN, '<', 'twainData.js';

# Concatenate the entire file into a single string
my $data_string = '';

while (<TWAIN>) {
  $data_string .= $_;
}

close TWAIN;

$data_string =~ s/var twainData = //;

# Split into 'rooms' as best as possible (which is not very well)
my @rooms = (split/},/, $data_string);

# Prepares Faker to generate random data
my $faker = Data::Faker->new();

# Create or overwrite a text file for each room
foreach (@rooms) {
  if (/roomNumber: (\d+).+occupants: (\d+).+residents: (\d+)/s) {
    # print "Room Number: $1, Occupants: $2, Residents: $3\n"; 
    
    open OUTPUT_FILE, '>', "bwod-data/$1.txt";
    select OUTPUT_FILE;
    
    # Room 22 is special
    if ($1 == 22) {
      print "Robin Banks\n";
      print "Holly Day Ing\n";
      print "Marcus Absent\n";
      print "Dewey Havtoo\n";
      print "Luke Out\n";
    }
    else {
      foreach (1 .. $2) {
        print $faker->name . "\n";
      }
    }
    
    select STDOUT;
    close OUTPUT_FILE;
  }
} 