#!/bin/perl -w

use strict;
use POSIX qw( strftime );
use Getopt::Std;
use vars qw($opt_f);

getopts("f:h");
my($in_file) = "libraryExport.csv";
my($out_file) = "import.txt";

if ($opt_f) {
  $in_file = $opt_f;
  $out_file = "import2.txt";
}

my($date)  = strftime("%Y-%m-%d", gmtime());
my($edate) = add_year($date);

sub add_year {
  my($in) = @_;
  my($y, $m, $d);

  ($y, $m, $d) = split(/-/, $in);
  $y++;
  return($y . '-' . $m . '-' . $d);
}

sub open_files {
  open(IN, $in_file) or die "Can't read in: $!\n";
  open(OUT, ">" . $out_file) or die "Can't write out: $!\n";
}

sub close_files {
  close(IN);
  close(OUT);
}

sub read_file {
  my($courseid, $aresid, $title, $section, $inst, $start, $end, $enrolmentcount, $junk);

  #
  print(OUT  join("\t", "COURSE_CODE", "COURSE_TITLE", "SECTION_ID", "ACAD", "PROD_DEPT", "TERM1", "TERM2", "TERM3", "TERM4", "START_DATE",
        "END_DATE", "NUM_OF_PARTICIPANTS", "WEEKLY_HOURS", "YEAR", "SEARCH_ID1", "SEARCH_ID2", "SEARCH_ID3", "INSTR1", "INSTR2", "INSTR3",
        "INSTR4", "INSTR5", "INSTR6", "INSTR7", "INSTR8", "INSTR9", "INSTR10", "ALL_INSTRUCTORS", "OPERATION", "OLD_COURSE_CODE",
        "OLD_COURSE_SECTION", "SUBMIT_LISTS_BY", "CAMPUS_AND_PARTICIPANTS", "READING_LIST_NAME" , "ENROLMENT_COUNT") . "\n");

  # Input format
  # OrgUnitId	AresId	Course Title	Sections	Instructors	StartDate	EndDate EnrolmentCount
  while(<IN>) {
    chomp;
    ($courseid, $aresid, $title, $section, $inst, $start, $end, $enrolmentcount) = split(/\t/);
    next if $courseid =~ /OrgUnitId/;
    # 2022-04-30 04:00:00
    # 2021-09-05T12:00:00.0000000Z
    if ($start and $start ne '') {
      $start = substr($start, 0, 10);
      # ($start,$junk) = split(/\s/, $start);
    } else {
      $start = $date;
    }
    if ($end and $end ne '') {
      $end = substr($end, 0, 10);
      # ($end,$junk) = split(/\s/, $end);
    } else {
      $end = $edate;
    }
    if ($inst and $inst ne '') {
      $inst = lc($inst);
    }
    print(OUT  join("\t", $courseid, $title, $section, "", "STAUFFERCR", "", "", "", "", $start, $end, "", "", "", $aresid,
          "", "", "", "", "", "", "", "", "", "", "", "", "+," . $inst, "", "", "", "", "", "", $enrolmentcount) . "\n");

  }
}

open_files();
read_file();
close_files();
