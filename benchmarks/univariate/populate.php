<html> 
<body>

<?php
 
$db_ip = 'benchmarks.zafeirakopoulos.info';           
$db_user = 'benchmarks';
$db_pass = 'acsbench';
$db_name = 'univariate';

function get_db_conn() {
  $conn = mysql_connect($GLOBALS['db_ip'], $GLOBALS['db_user'], $GLOBALS['db_pass']);
  mysql_select_db($GLOBALS['db_name'], $conn);
  return $conn;
}

$conn=get_db_conn();
echo "OK <br>";
/*
$query  = "TRUNCATE Dataset";
$res = mysql_query($query, $conn) or die('Error, query failed');
$query  = "TRUNCATE Polynomial";
$res = mysql_query($query, $conn) or die('Error, query failed');
$query  = "TRUNCATE belongs";
$res = mysql_query($query, $conn) or die('Error, query failed');
$query  = "TRUNCATE solve";
$res = mysql_query($query, $conn) or die('Error, query failed');
$query  = "TRUNCATE average";
$res = mysql_query($query, $conn) or die('Error, query failed');
echo "OK <br>";
*/

$lines = file('datasets.new');
foreach ($lines as $line) {
	$contents=explode(" ", $line);

	$sou=$contents[0];
	$typ=$contents[1];
	$deg=$contents[2];
	$bits=$contents[3];

	$query  = "INSERT INTO Dataset(degree, bitsize, source, type ) VALUES($deg, $bits, \"$sou\", \"$typ\")";
	$res = mysql_query($query, $conn) or die('Error, query failed');
}

echo "2. OK <br>";

$file = fopen("polynomials", "r") or exit("Unable to open file!");
while(!feof($file))
{
	$line=fgets($file);
	$contents=explode(" ", $line);

	$typ=$contents[1];
	$deg=$contents[2];
	$bits=$contents[3];
	$inset=$contents[5];

	$query  = "INSERT INTO Polynomial(expression) VALUES(NULL)";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$pid=mysql_insert_id();
#echo "<br>".$pid;
#echo "<br>".$deg." ".$bits." ".$typ;
	$query  = "SELECT id FROM Dataset WHERE type=\"$typ\" AND degree='$deg' AND bitsize='$bits'";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$row = mysql_fetch_array($res, MYSQL_ASSOC);
	$did=$row['id'];
#echo "<br>".$query;

	$query  = "INSERT INTO belongs(p_id, d_id, in_set) VALUES($pid, $did, $inset)";
#echo "<br>".$query;
	$res = mysql_query($query, $conn) or die('Error, query failed');

}
echo "3. OK <br>";

fclose($file);


$file = fopen("benchmarks.new", "r") or exit("Unable to open file!");
while(!feof($file))
{
	$line=fgets($file);
	$contents=explode(" ", $line);

	$typ=$contents[1];
	$deg=$contents[2];
	$bits=$contents[3];
	$meth=$contents[4];
	$inset=$contents[5];
	$time=$contents[6];
#echo "<br>".$time;
	$roots=$contents[7];
	$fail=$contents[8];
#echo "<br>aaa";
	$query  = "SELECT id FROM Method WHERE abbreviation=\"$meth\"";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$row = mysql_fetch_array($res, MYSQL_ASSOC);
	$mid=$row['id'];
#echo "<br>bbb";
	$query  = "SELECT b.p_id FROM belongs b, Dataset d WHERE d.type='$typ' AND d.degree='$deg' AND d.bitsize='$bits' AND d.id=b.d_id AND b.in_set='$inset'";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$row = mysql_fetch_array($res, MYSQL_ASSOC);
	$pid=$row['p_id'];
#echo "<br>ccc";
	$query  = "INSERT INTO solve(m_id, p_id, time, roots, fail) VALUES(\"$mid\",\"$pid\",$time,$roots,$fail)";
	$res = mysql_query($query, $conn) or die('Error, query failed');
#echo "<br>ddd";
}
fclose($file);
echo "OK <br>";

# Compute and populate Average

$mid="";
$did="";
	$query  = "SELECT * FROM Method ";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$i=0;
	while($row = mysql_fetch_array($res, MYSQL_ASSOC)) {
		$mid[$i]= $row['id'];
		$i=$i+1;
	} 
	$query  = "SELECT id FROM Dataset";
	$res = mysql_query($query, $conn) or die('Error, query failed');
	$i=0;
	while($row = mysql_fetch_array($res, MYSQL_ASSOC)) {
		$did[$i]= $row['id'];
		$i=$i+1;
	} 
echo "OK <br>";

foreach ($mid as $method) {
	foreach ($did as $dataset) {
		$query  = "SELECT AVG(s.time) AS avg FROM belongs b, solve s WHERE b.p_id=s.p_id AND b.d_id='$dataset' AND s.m_id='$method'";
#echo "<br>".$query;
		$res = mysql_query($query, $conn) or die('Error, query failed');
		$row = mysql_fetch_array($res, MYSQL_ASSOC);
		$avg=$row['avg'];
#echo "<br>".$avg;
		if ($avg=="")
			{
				$avg=-1;
			}
		$query  = "INSERT INTO average(m_id, d_id, time) VALUES(\"$method\",\"$dataset\",$avg)";
#echo "<br>".$query;
		$res = mysql_query($query, $conn) or die('Error, query failed');
	}
}
echo "<br>OK!";
?>

</body>
</html>

