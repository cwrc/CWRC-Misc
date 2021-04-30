<?php

/**
 * Intracts with and Islandora 7 repository islandora_rest API
 * to define a set of objects and download a specified datastream
 * to the local filesystem
 *
 * usage:
 *      php cwrc_object_download.php --config config_filename_and_path
 *
 * Where the config looks like:
 *
 *
    {
        "url_base":"https://example.com",
        "object_sets":{
            "Orlando Person": {
                "source_solr_query":"RELS_EXT_isMemberOfCollection_uri_mt:\"orlando%3ApersonEntityCollection\"?fl=PID&rows=999999&start=0&wt=json&sort=PID+asc",
                "destination_dir":"orlando%3ApersonEntityCollection",
                "dsid":"PERSON",
                "cModel":"cwrc:person-entityCModel",
                "filename_regex_pattern":"/^([^:]+):(.+)$/i",
                "filename_regex_replacement":"${1}_${2}"
            },
            "Orlando Organization" : {
                "source_solr_query":"RELS_EXT_isMemberOfCollection_uri_mt:\"orlando%3AorganizationEntityCollection\"?fl=PID&rows=999999&start=0&wt=json&sort=PID+asc",
                "destination_dir":"orlando%3AorganizationEntityCollection",
                "dsid":"ORGANIZATION",
                "cModel":"cwrc:organization-entityCModel",
                "filename_regex_pattern":"/^([^:]+):(.+)$/i",
                "filename_regex_replacement":"${1}_${2}"
            }
        }
    }
 *
 */

# read command-line options
$shortopts = "";  // configuration
$longopts = array(
    "config:"
);  // configuration
$options = getopt($shortopts, $longopts);

# read config file
$config = get_config($options);

# prompt for username/password
$username   = readline("username: ");
$userpasswd = readline("password: ");

# handle authorization
$auth_token = get_auth_token($config, $username, $userpasswd);
if (!isset($auth_token) or empty($auth_token)) {
    print("Authentication failure\n");
    exit;
}

# process object sets defined in the config file
# the config defines multiple object sets to process in the form
foreach ($config['object_sets'] as $key => $object_set) {
    print("Processing: $key\n");
   
    $pid_array = find_object_set_members($object_set, $auth_token, $config['url_base']);
    if (!empty($pid_array)) {
        process_object_set($pid_array, $object_set, $auth_token, $config['url_base']);
    }
}


/**
 * Lookup a set to PIDs given a Solr query
 */
function find_object_set_members($object_set, $auth_token, $url_base)
{
    $url = $url_base . "/islandora/rest/v1/solr/" . $object_set['source_solr_query'];
    $response = generic_request($auth_token, $url);
    $solr_response = json_decode($response, true);
    $pid_array = $solr_response['response']['docs'];
    return $pid_array;
}

/**
 * Process a set of pids and save the content as defined in the context of the object set configuration
 */
function process_object_set($pid_array, $object_set, $auth_token, $url_base)
{
    foreach ($pid_array as $obj) {
        print("- " . $obj['PID'] . "\n");
        # other option: curl allow option to save to a file instead of handling content here
        $models = get_model_by_pid($obj['PID'], $object_set, $auth_token, $url_base);
        if (is_model_valid($models, $object_set['cModel'])) {
            $content = get_content_by_pid($obj['PID'], $object_set, $auth_token, $url_base);
            if (!empty($content)) {
                save_content($content, $object_set, $obj['PID']);
                usleep(rand(10000, 50000));
            }
        } else {
            print("ERROR: PID contains invalid cModels [" .
                implode(",", $models) .
                "]; incompatible with object_set [" .
                $object_set['cModel'] ."]. pid: [" . $obj['PID'] . "]\n"
            );
        }
    }
}

/**
 * Verify the filter is in the list of models
 */

function is_model_valid($models, $filter)
{
    $ret = false;
    if (is_array($models) && in_array($filter, $models)) {
        $ret = true;
    } elseif ($models === $filter) {
        $ret = true;
    }
    return $ret;
}

/**
 * lookup the list of models attached to a specified object (by PID) 
 */
function get_model_by_pid($pid, $object_set, $auth_token, $url_base)
{
    $url = $url_base
        . "/islandora/rest/v1/object/"
        . $pid
        ;
    #print("Connecting to server: $url\n");
    $response = generic_request($auth_token, $url);
    $metadata = json_decode($response, true);
    return $metadata['models'];
}

/**
 * return the content of a specified datastream attached to a specified object
 */
function get_content_by_pid($pid, $object_set, $auth_token, $url_base)
{
    $url = $url_base
        . "/islandora/rest/v1/object/"
        . $pid
        . "/datastream/"
        . $object_set['dsid']
        . "?content=true"
        ;
    #print("Connecting to server: $url\n");
    $response = generic_request($auth_token, $url);
    return $response;
}

/**
 * save content to a specified file on the local filesystem
 */
function save_content($content, $object_set, $pid)
{
    # create filename path; set filename by a regular expression
    if (empty($object_set['filename_regex_pattern']) or empty($object_set['filename_regex_replacement'])) {
        $dest_file = $object_set['destination_dir'] . '/' . $pid;
    } else {
        $dest_file = $object_set['destination_dir'] .
            '/'
            . preg_replace($object_set['filename_regex_pattern'], $object_set['filename_regex_replacement'], $pid);
    }

    # print("Opening file for writing: $dest_file\n");

    # create directory if doesn't exist
    if (!is_dir($object_set['destination_dir'])) {
        mkdir($object_set['destination_dir'], 0755, true);
    }

    if (is_writable($object_set['destination_dir']) &&
            (!file_exists($dest_file) || is_writeable($dest_file)) &&
            ($fp = fopen($dest_file, 'w+'))!==false
            ) {
        fwrite($fp, $content);
        fclose($fp);
    } else {
        print("ERROR: writing to file failed : $dest_file\n");
    }
}

/** 
 * process the command line specified config file
 */
function get_config($options)
{
    $configStr = file_get_contents($options['config']);
    $json = json_decode($configStr, true);
    return $json;
}

/**
 * authenication API request; returns cookie to be used as a token
 */
# based on: https://stackoverflow.com/a/21943596
function get_auth_token($config, $username, $userpasswd)
{
    $url = $config['url_base'] . "/rest/user/login";
    print("Connecting to server: $url\n");

    $payload = json_encode(array("username"=>"$username", "password"=>"$userpasswd"));

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
    $http_code= curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $header_content = substr($response, 0, $header['header_size']);
    $pattern = "#Set-Cookie:\\s+(?<cookie>[^=]+=[^;]+)#m";
    preg_match_all($pattern, $header_content, $matches);
    $cookiesOut = implode("; ", $matches['cookie']);

    if (!isset($response) or
            empty($response) or
            $response === false or
            !isset($cookiesOut) or empty($cookiesOut) or
            ($http_code < 200 or $http_code >= 300)
            ) {
        if (isset($response)) {
            print(strtok($response, "\n") . "\n");
        }
        print("[ERROR] http_code: $http_code | message: $errmsg | url: $url\n");
        $response = "";
    }

    return $cookiesOut;
}

/**
 * generic http request handler
 */
function generic_request($auth_token, $url)
{
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
    $http_code= curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if (!isset($response) or
            empty($response) or
            $response === false or
            ($http_code < 200 or $http_code >= 300)
            ) {
        if (isset($response)) {
            print(strtok($response, "\n") . "\n");
        }
        print("[ERROR] http_code: $http_code | message: $errmsg | url: $url\n");
        $response = "";
    }

    return $response;
}
