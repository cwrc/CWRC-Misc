<html>
<body> 
  <div>
  <form enctype="multipart/form-data" action="template_filler_web.php" method="post">
    <input type="hidden" name="MAX_FILE_SIZE" value="1000000" />
    <div>
      Choose a CSV datafile : <input name="source_file" type="file" />
    </div>
    <div>
      Choose a template : <input name="template_file" type="file" />
    </div>
    <input type="submit" value="submit" />
  </form> 
  </div>

<?php

include "library/template_filler.php";


//if ( isset($_POST["submit"]) ) 
{
  if ( isset($_FILES["source_file"]) && isset($_FILES["template_file"]) ) 
  {

    //if there was an error uploading the file
    if ($_FILES["source_file"]["error"] > 0) 
    {
      echo "Return Code: " . $_FILES["source_file"]["error"] . "<br />"; 
    }
    else if ($_FILES["template_file"]["error"] > 0) 
    {
      echo "Return Code: " . $_FILES["template_file"]["error"] . "<br />"; 
    }
    else 
    {
      $fh_source = fopen($_FILES['source_file']['tmp_name'], 'r');
      $fh_template = fopen($_FILES['template_file']['tmp_name'], 'r');

      if ($fh_template && $fh_source)
      {
        $data = csv_to_array($fh_source, $_FILES['template_file']['tmp_name']);
        print '<div><textarea rows="200" cols="80" name="output" id="output">';
        print $data;
        print '</textarea></div>';
        fclose($fh_source);
        fclose($fh_template);
      }
    }
  }
  else {
    echo "No file selected <br />";
  }


}



?>

</body>
</html>
