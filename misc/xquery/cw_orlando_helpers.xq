(: a set of helper functions to manipulate Orlando XML :)

xquery version "3.0" encoding "utf-8";

module namespace cwPO = "cwOrlandoHelpers";

declare namespace mods = "http://www.loc.gov/mods/v3";
declare namespace tei =  "http://www.tei-c.org/ns/1.0";


(: map to help converting dates to ISO8601 (YYYY-MM-DD) dates that use month numbers :)
declare variable $cwPO:monthMap as map(*) := 
  map {
    "January": "01" 
    , "February": "02" 
    , "March": "03" 
    , "April": "04" 
    , "May": "05" 
    , "June": "06" 
    , "July": "07" 
    , "August": "08" 
    , "September": "09" 
    , "October": "10" 
    , "November": "11" 
    , "December": "12" 
    , "janvier": "01" 
    , "février": "02" 
    , "mars": "03" 
    , "avril": "04" 
    , "mai": "05" 
    , "juin": "06" 
    , "juillet": "07" 
    , "août": "08" 
    , "september": "09" 
    , "octobre": "10" 
    , "novembre": "11" 
    , "décembre": "12" 
  };

(: 
* Given an Orlando normalized narrative date
* in the form of day month year - e.g. 6 June 1994
* convert to ISO8601 (YYYY-MM-DD) date
 :)
declare function cwPO:parse-orlando-narrative-date($dateStr)
{
    try
    {
      for $str at $i in fn:reverse(fn:tokenize($dateStr, " "))
      return
      (
        if ( fn:matches($str, "\d\d\d\d") and $i eq 1 ) then
          $str
        else if ( $cwPO:monthMap($str) and $i eq 2 ) then
          $cwPO:monthMap($str)
        else if ( fn:matches($str, "\d{1,2}") and $i eq 3 ) then
          fn:format-number(xs:double($str),"#00")
        else
          ()
      )
    }
    catch * {
      ()
    }
};


