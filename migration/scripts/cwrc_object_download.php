<?php

# read command-line options
$shortopts = "";  // configuration 
$longopts = array(
    "config:"
);  // configuration 
$options = getopt($shortopts, $longopts);

# read config file
$config = get_config($options);
#var_dump($config);

# prompt for username/password
$username   = readline("username: ");
$userpasswd = readline("password: ");

#var_dump($options);

$auth_token = get_auth_token($config, $username, $userpasswd);
if (!isset($auth_token) or empty($auth_token)) {
    print("Authentication failure\n");
    exit;
}
#print_r($auth_token);

# the config defines multiple object sets to process in the form
#"object_sets":{
#    "Orlando Person": {
#        "source_solr_query":"RELS_EXT_isMemberOfCollection_uri_mt:\"orlando%3ApersonEntityCollection\"?fl=PID&rows=999999&start=0&wt=json",                                                                                 
#        "destination_dir":"orlando%3ApersonEntityCollection",
#        "dsid":"PERSON",
#        "cModel":""
#    }    
#}        
foreach ($config['object_sets'] as $key => $object_set) {
    print("Processing: $key\n");
   
    $pid_array = find_object_set_members($config, $object_set, $auth_token);
    if (!empty($pid_array)) {
        process_object_set($pid_array, $object_set, $auth_token, $config['url_base']);
    }
}



function find_object_set_members($config, $object_set, $auth_token) {
    $url = $config['url_base'] . "/islandora/rest/v1/solr/" . $object_set['source_solr_query'];
    $response = generic_request($auth_token, $url); 
    $solr_response = json_decode($response, true);
    $pid_array = $solr_response['response']['docs'];
    return $pid_array;
}

function process_object_set($pid_array, $object_set, $auth_token, $url_base) {
    foreach ($pid_array as $obj) {
        print("- " . $obj['PID'] . "\n");
        # other option: curl allow option to save to a file instead of handling content here
        $content = get_content_by_pid($obj['PID'], $object_set, $auth_token, $url_base); 
        if (!empty($content)) {
            save_content($content, $object_set, $obj['PID']);
            usleep(rand(10000,50000));
        }
    }
}

function get_content_by_pid($pid, $object_set, $auth_token, $url_base) {
    $url = $url_base 
        . "/islandora/rest/v1/object/" 
        . $pid
        . "/datastream/"
        . $object_set['dsid']
        . "?content=true"
        ;
    print("Connecting to server: $url\n");
    $response = generic_request($auth_token, $url); 
    return $response;
}

function save_content($content, $object_set, $pid) {
    $dest_file = $object_set['destination_dir'] . '/' . $pid;
    print("Opening file for writing: $dest_file\n");

    if (!is_dir($object_set['destination_dir']))
    {
        mkdir($object_set['destination_dir'], 0755, true);
    }

    $fp = fopen($dest_file, 'w+');
    fwrite($fp, $content);
    fclose($fp);
}

function get_config($options) {
    $configStr = file_get_contents($options['config']);
    $json = json_decode($configStr, true);
    return $json;
}

# based on: https://stackoverflow.com/a/21943596
function get_auth_token($config, $username, $userpasswd) {

    $url = $config['url_base'] . "/rest/user/login";
    print("Connecting to server: $url\n");

    $payload = json_encode( array("username"=>"$username", "password"=>"$userpasswd") );

    $options = array(
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HEADER         => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_CONNECTTIMEOUT => 120, 
        CURLOPT_TIMEOUT        => 120,
        CURLINFO_HEADER_OUT    => true,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_HTTP_VERSION   => CURL_HTTP_VERSION_1_1,
        CURLOPT_HTTPHEADER => array('Content-Type:application/json'),
        CURLOPT_POSTFIELDS => $payload,
    );

    $ch = curl_init($url);
    curl_setopt_array($ch, $options);
    $response = curl_exec($ch);
    $err      = curl_errno($ch);
    $errmsg   = curl_error($ch);
    $header   = curl_getinfo($ch);
    curl_close($ch);

    $header_content = substr($response, 0, $header['header_size']);
    $body_content = trim(str_replace($header_content, '', $response));
    $pattern = "#Set-Cookie:\\s+(?<cookie>[^=]+=[^;]+)#m"; 
    preg_match_all($pattern, $header_content, $matches); 
    $cookiesOut = implode("; ", $matches['cookie']);

    $header['errno']   = $err;
    $header['errmsg']  = $errmsg;
    $header['headers']  = $header_content;
    $header['content'] = $body_content;
    $header['cookies'] = $cookiesOut;    

    #print_r($response);
    #print_r($header);

    if (!isset($cookiesOut) or empty($cookiesOut)) {
        print_r($response);
    }

    return $header['cookies'];
}

function generic_request($auth_token, $url) {

    $options = array(
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_CONNECTTIMEOUT => 120, 
        CURLOPT_TIMEOUT        => 120,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_HTTP_VERSION   => CURL_HTTP_VERSION_1_1,
        CURLOPT_COOKIE         => $auth_token,
        CURLOPT_HEADER         => false,
        CURLINFO_HEADER_OUT    => false,
    );

    $ch = curl_init($url);
    curl_setopt_array($ch, $options);
    $response = curl_exec($ch);
    $err      = curl_errno($ch);
    $errmsg   = curl_error($ch);
    #$header   = curl_getinfo($ch);
    curl_close($ch);

    if ($response === false) {
        print ("[ERROR]: $errmsg");
    }

    return $response;
}

?>