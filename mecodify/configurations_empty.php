<?php

$lifetime=6000;
session_set_cookie_params($lifetime);
session_start();

$enable_new_accounts=1; // set to 0 to disable new accounts (signup)
$allow_new_cases=1; //allow adding new cases (can be set when you wish to prevent altering the DB
$max_tweets_per_case=500000; //maximum tweets per case (applies only to API Search & can be exceeded by 100 records max)

$website_url=""; //e.g., https://mecodify.org . Don't end with '/'
$website_title="";

$admin_email="";
$admin_name="";

$mysql_db="";
$mysql_server = "";
$mysql_user = "";
$mysql_pw = "";

$smtp_host="";
$smtp_secure=""; //can be "ssl" or "tls"
$smtp_port="";
$smtp_user="";
$smtp_pw="";

$twitter_api_settings=array( // you need at least one set, there is no max!
         array(
          'oauth_access_token' => "",
          'oauth_access_token_secret' => "",
          'consumer_key' => "",
          'consumer_secret' => ""
          )
        );

$platforms=array('1'=>'Twitter'); //Facebook and Youtube and other sources to be added in the future
$search_methods=array('Twitter'=>array('0'=>'Search API','1'=>'Streaming API','2'=>'Web Search')); //Streaming API not activated yet

$website_title=$website_title." (powered by Mecodify v".trim(file_get_contents("ver.no")).")";
require_once('twitter-api-php-master/TwitterAPIExchange.php');

$website_url=rtrim($website_url,"/");
connect_mysql();

get_cases();

function connect_mysql()
  {
      global $link;
    global $mysql_db; global $mysql_server; global $mysql_user; global $mysql_pw;
    $link = new mysqli($mysql_server, $mysql_user, $mysql_pw, $mysql_db);

    if (!$link) {
        echo "Error: Unable to connect to MySQL." . PHP_EOL;
        echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
        echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
        exit;
       }
      $link->set_charset("utf8mb4");
      $link->query("SET sql_mode=''");
      $link->query("SET time_zone='+0:00'");
      if (!$link) die ("Can't use $mysql_db : " . $link->error);

      $result=$link->query("SHOW TABLES LIKE 'members'");
      if (!$result->num_rows)
	{
        $sql = file_get_contents('templates/template_tables.sql');
        $sql=str_replace("<USR>",$mysql_user,$sql);
        $sql=str_replace("<SRVR>",$mysql_server,$sql);
        $query_array = explode(';', $sql);
        $ii = 0;
        if( $link->multi_query( $sql ) )
          {
            do {
                $link->next_result();
                $ii++;
            }
            while( $link->more_results() );
          }

        if( $link->errno )
          {
            die(
                '<h1>ERROR</h1>
                Query #' . ( $ii + 1 ) . ' of <b>template_tables.sql</b>:<br /><br />
                <pre>' . $query_array[ $ii ] . '</pre><br /><br />
                <span style="color:red;">' . $link->error . '</span>'
            );
          }

	}
  }

function get_cases()
  {
    global $cases; global $link; global $cond;

    $query= "SELECT * from cases $cond";

    $result = $link->query($query);

    $cases=array();

    while ($row = $result->fetch_assoc())
      {
        $cases[$row['id']]['name']=$row['name'];
        $cases[$row['id']]['query']=$row['query'];
        $cases[$row['id']]['keywords']=$row['query'];
        $cases[$row['id']]['from']=$row['from_date'];
        $cases[$row['id']]['to']=$row['to_date'];
        $cases[$row['id']]['top_only']=$row['top_only'];
        $cases[$row['id']]['details']=$row['details'];
        $cases[$row['id']]['creator']=$row['creator'];
      }
  }

?>
