 

<?php
 
$db_ip = 'localhost';           
$db_user = 'zaf';
$db_pass = 'm4thuoa@';
$db_name = 'zaf';

function get_db_conn() {
  $conn = mysql_connect($GLOBALS['db_ip'], $GLOBALS['db_user'], $GLOBALS['db_pass']);
  mysql_select_db($GLOBALS['db_name'], $conn);
  return $conn;
}

function right_roots_only($conn) {
	$query  = "SELECT * FROM Polynomial";
	$res = mysql_query($query, $conn) or die('Error, query failed');

	while($poly = mysql_fetch_array($res, MYSQL_ASSOC)) {
		$query  = "SELECT * FROM solve WHERE p_id=".$poly['id']." ORDER BY roots ASC";
		$res2 = mysql_query($query, $conn) or die('Error, query failed');
		$group = mysql_fetch_array($res2, MYSQL_ASSOC);
		$roots=$group['roots'];
		while($group = mysql_fetch_array($res2, MYSQL_ASSOC)) {		
			if ($roots!=$group['roots'])
				{
					echo "roots: ".$roots;
					echo "fail: ".$group['roots'];
					$query2  = "UPDATE solve SET time=0";
					mysql_query($query2, $conn) or die('Error, query failed');
				}
		}
	} 
}

right_roots_only(get_db_conn()) ;

?>