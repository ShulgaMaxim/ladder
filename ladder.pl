#!/usr/bin/perl -w
#(c)Shulga

use strict;
use Encode;
use open qw/ :encoding(UTF-8) :std/;

if($ARGV[0]eq '-h')
{
    &help();
    exit(1);
}

my ($first,$last)=@ARGV;
my %new_generation=();
my %generation=();

$first = decode 'utf8',$ARGV[1];  
$last = decode 'utf8',$ARGV[0];

if(length($first)!=length($last))
{
    print "Words of different length\n";
    exit(1)
}  

open D, "<dictionary.sh" or die "Couldn't open file :$!";
while (<D>)
{
    chop;
    chop;
    $generation{$_}=undef if(length($first)==length($_));
}
close D;

if((not exists $generation{$first})||(not exists $generation{$first}))
{
    print "Dictionry hasn't word\n";
    exit(1); 
}

my @parents;
push @parents,$first;
&ladder(@parents);

sub ladder(@)
{
    my @childs;
    for my $parent(@_)
    {
        if ($parent ne $last)
        {
            while (my ($key,$value) = each %generation)
            {
                my $check= $key^$parent;   
                $check =~s/\x00//g;
                if((length($check)==1)&&(not defined $value))
                {
                    $generation{$key}=$parent;
                    $new_generation{$key}=undef;
                    push @childs,$key;      
                }
            }
        }
        else
        {
            print $last,$/;
            while($last ne $first)
            {
                print $generation{$last},$/;   
                $last=$generation{$last};
            }
            exit(1);
        }
    }
    if(0+@childs==0)
    {
        print "It is impossimble to execute transformation\n";
        exit(1);
    }
    &ladder(@childs);
}

sub help
{
    print "ladder.pl INITIAL_WORD FINAL_WORD\n";
    print "For program start you should enter two words\n"; 
    print "INITIAL_WORD-the word with which will begin search\n"; 
    print "FINAL_WORD-the word to which aspires the program\n";
    print "On termination of program work in std there will be the mildest transformation .If you see an inscription of \"It is impossimble to execute transformation\" transformation means it is impossible\n";
    print "Created by Shulga\n";       
}
