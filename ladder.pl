#!/usu/bin/perl

use Encode;
use strict;
use open qw/ :encoding(UTF-8) :std/;

my %used_words;
my @first;
my $count;

our ($begin_time_sec,$begin_time_min)=localtime(time);
our $f;
our @dictionary;
our $word_len;
our %generation;
our $l;

if($ARGV[0]eq '-h')
{
    &help();
    exit(1);
}    
    open D, "<dictionary.sh" or die "Coudn't open file: $!";
    $f = decode 'utf8',$ARGV[1];  
    $l = decode 'utf8',$ARGV[0];  


    $word_len = length($f);
if ($word_len = length ($l))
{
    while (<D>) 
    {
        chop;
        chop;
        $count+=1 if(/^[$f,$l]$/);
        if (length($_) == $word_len) 
        {
            push @dictionary,$_;
        }
    }
    close D;
    if ($count>=2)
        {
            push @first,$f;
            &ladder(@first);
        }    
        else
        {
            print "Dictionry hasn't word\n"; 
        }
}
else
{
    print "Words of different length\n";
}


#######################
sub ladder(@)
{
    my @parent=@_;
    my @childs;
    
    for my $parent(@parent)
    {   
        $used_words{$parent}=1;
        if($parent eq $l) 
        {
            my $word=$l;
            while ($word ne $f) 
            {
                print $word,"\n";
                $word=$generation{$word};
            }
            print $f,"\n";
            my ($finish_time_sec,$finish_time_min)=localtime(time);
            print($finish_time_sec+$finish_time_min*60-$begin_time_sec-$begin_time_min*60);
            exit(1);
        }
        for my $word (@dictionary)
        {   
            my @p=split //,$parent;
            my @w=split //,$word;
            $word= join "", @w;
            if((can_be_next($parent,$word))&&(not exists $used_words{$word}))
            {
                $generation{$word}=$parent;
                push @childs,$word;
                $used_words{$word}=1;
                last if ($word=~/^$l$/);           
            }
        }
    }
    &ladder(@childs);
    return 0;
}
#########################

sub can_be_next 
{
    my ($w1,$w2) = @_;
    my $len = length($w1);
    my @w1=split //,$w1;
    my @w2=split //,$w2; 
    my $bad = 0;

    for my $i(0..$len-1) 
    {
        if($w1[$i] ne $w2[$i]) 
        {
            $bad += 1;
        }
        if($bad>1) 
        {
            return 0;
        }
    } 
    return $bad == 1;
}
#######################

sub help
{
    print "ladder.pl INITIAL_WORD FINAL_WORD\n";
    print "For program start you should enter two words\n"; 
    print "INITIAL_WORD-the word with which will begin search\n"; 
    print "FINAL_WORD-the word to which aspires the program\n";
    print "On termination of program work in std there will be the mildest transformation .If you see an inscription of \"Out Of Memory\" transformation means it is impossible\n";
    print "Created by Shul'ga";       
}
