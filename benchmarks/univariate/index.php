 
<html> 
<body>

<?php
echo "<html><head><title>Benchmarks of Univariate Solvers</title></head><body>"; 
echo "<div style=\"text-align: center;\"> <a href=\"http://acs.cs.rug.nl/\"> <img src=\"acs.gif\"> </a></div>";

$db_ip = 'benchmarks.zafeirakopoulos.info';           
$db_user = 'benchmarks';
$db_pass = 'acsbench';
$db_name = 'univariate';

function get_db_conn() {
  $conn = mysql_connect($GLOBALS['db_ip'], $GLOBALS['db_user'], $GLOBALS['db_pass']);
  mysql_select_db($GLOBALS['db_name'], $conn);
  return $conn;
}

if (($_POST['command']!="") AND ($_POST['command']!="Back") )
{
$conn=get_db_conn();

	$typ=$_POST['type'];
	$deg=$_POST['degree'];
	$bits=$_POST['bitsize'];

	$query  = "SELECT * FROM Dataset WHERE ";
	if ($typ!="VAR")
	{
		$query=$query."type=\"$typ\" ";
		if ($deg!="VAR")
		{
			$query=$query."AND degree='$deg' ";
		}
		if ($bits!="VAR")
		{
			$query=$query."AND bitsize='$bits' ";
		}
	}
	else
	{
		if ($deg!="VAR")
		{
			$query=$query."degree='$deg' ";
			if ($bits!="VAR")
			{
				$query=$query."AND bitsize='$bits' ";
			}
		}
		else
		{
			if ($bits!="VAR")
			{
				$query=$query."bitsize='$bits' ";
			}
		}
	}

	$query=$query." ORDER BY degree, bitsize";
	$res1 = mysql_query($query, $conn) or die('Error, query failed');
	

	echo "<div style=\"text-align: center;\"><h3> Table of results </h3></div>" ;
	echo "<table border=1><caption>Time in msec</caption>";
	echo "<tr><th> Source </th><th> Type </th><th> Degree </th><th> Bitsize </th>";

	$legend="<div style=\"text-align: center;\"> <table border=1><caption>Legend</caption> ";

	$plot="set key outside left top; \n set ylabel \"msec\"; \n set yrange [".$_POST['range_from'].":".$_POST['range_end']."]; \n set xrange [".$_POST['hrange_from'].":".$_POST['hrange_end']."]; \n set title \"Type: ".$_POST['type']." Degree: ".$_POST['degree']." Bitsize: ".$_POST['bitsize']."\"; \n set style line 1 lt -1; set style line 2 lt 1; set style line 3 lt 2; set style line 4 lt 3; set style line 5 lt 4; set style line 6 lt 5; set style line 7 lt 6; set style line 8 lt 9; set style line 9 lt 8; \n plot";

	if ($_POST['color']=="color"){
		$ploteps="set term postscript eps color; \n set output \"graph.eps\"; \n";
		$plotpng="set term png; \nset output \"graph.png\"; \n";
	}
	else{
		$ploteps="set term postscript eps monochrome; \n set output \"graph.eps\"; \n";  
		$plotpng="set term png mono; \nset output \"graph.png\"; \n";
	}


	$methsel="SELECT * FROM Method m WHERE ";
	$methtmp="m.abbreviation=\"0\" ";
	foreach ($_POST['method'] as $method){
		$methtmp=$methtmp."OR m.abbreviation=\"$method\" ";
	}
	$methsel=$methsel.$methtmp;
	$res2 = mysql_query($methsel, $conn) or die('Error, query failed');
	if ($_POST['degree']=="VAR"){
		$xchoice=1;	
	}
	if ($_POST['bitsize']=="VAR"){
		$xchoice=2;	
	}
 	$counter=3;
	while($rows = mysql_fetch_array($res2, MYSQL_ASSOC)) {
		echo "<th> ".$rows['abbreviation']." </th>";
		$legend=$legend."<tr><td>".$rows['abbreviation']."</td><td>".$rows['name']."</td></tr>";
		
		$plot=$plot.", \"plot.data\" using $xchoice:$counter title \"".$rows['abbreviation']."\" with linespoints ls ".$rows['id']." ";
		$counter=$counter+1;
		}
	echo "</tr>";
	$plotdata="";
	while($dataset = mysql_fetch_array($res1, MYSQL_ASSOC)) {
		$datasetid=$dataset['id'];
		echo "<td>".$dataset['source']."</td>"."<td>".$dataset['type']."</td>"."<td>".$dataset['degree']."</td>"."<td>".$dataset['bitsize']."</td>";
		$plotdata=$plotdata.$dataset['degree']." ".$dataset['bitsize']." ";	
 		$query  = "SELECT a.time FROM average a, Method m WHERE a.d_id='$datasetid' AND a.m_id=m.id AND (".$methtmp.") ";
 #echo "<br>".$query;
		$res = mysql_query($query, $conn) or die('Error, query failed');
		while($row = mysql_fetch_array($res, MYSQL_ASSOC)) {
		$plotdata=$plotdata.$row['time']." ";	
 			echo "<td>".$row['time']."</td>";
		}
		$plotdata=$plotdata."\n";
		echo "</tr>"; 
	}

	echo "</table></div><br><br>";
	if ($_POST['command']=="Table and Graph"){
		
		$datafile = "plot.data";
		$fh = fopen($datafile, 'w') or die("can't open file");
		fwrite($fh, $plotdata);
		fclose($fh);

		$plot=str_replace("plot,","plot ",$plot);
		$ploteps=$ploteps.$plot.";";
		$plotpng=$plotpng.$plot.";";
#echo "<br>".$ploteps;
#echo "<br>".$plotpng;


		$commandfile = "plot.command";
		$fh = fopen($commandfile, 'w') or die("can't open file");
		fwrite($fh, $plotpng);
		fclose($fh);
		echo exec("gnuplot plot.command", $gnuplotout, $gnuplotfail);

		$fh = fopen($commandfile, 'w') or die("can't open file");
		fwrite($fh, $ploteps);
		fclose($fh);
		echo exec("gnuplot plot.command", $gnuplotout, $gnuplotfail);
		echo "<div style=\"text-align: center;\"> <a <img src=\"graph.png\" width=\"640\" height=\"480\" > </a><br>";
		echo "<br><br><a href=\"graph.eps\">Download the graph in eps format</a></div> ";
	}
	$legend=$legend."</table></div>";
	echo "<div style=\"text-align: center;\">".$legend;
	echo "<form method=\"POST\" action=\"$PHP_SELF\">";
	echo "<div style=\"text-align: center;\"><INPUT type=\"submit\" name=\"command\" value=\"Back\"></div>";
	echo "<br><br>Author: <a href=http://www.di.uoa.gr/~grad0783>Zafeirakopoulos Zafeirakis</a>";
	echo "</body></html>";

#echo exec("gnuplot 'test.plot'");
}
else
{
echo "<table cellspacing=40%>
<form method=\"POST\" action=\"$PHP_SELF\">
<br>
<tr><td width=25%>
Graph color (for the eps)<br>
<input type=\"radio\" value=\"mono\" name=\"color\" > Mono<br />
<input type=\"radio\" value=\"color\" name=\"color\" checked=\"true\"> Color<br />
<br>
Select methods:<br>
<input type=\"checkbox\" value=\"ST\" name=\"method[]\" checked=\"true\"> Sturm<br />
<input type=\"checkbox\" value=\"SV\" name=\"method[]\" checked=\"true\"> Sleeve<br />
<input type=\"checkbox\" value=\"SN\" name=\"method[]\" checked=\"true\"> Symbolic Numeric<br />
<input type=\"checkbox\" value=\"CF\" name=\"method[]\" checked=\"true\"> CF<br />
<input type=\"checkbox\" value=\"NCFF\" name=\"method[]\" checked=\"true\"> NFCF<br />
<input type=\"checkbox\" value=\"NCF\" name=\"method[]\" checked=\"true\"> NCF<br />
<input type=\"checkbox\" value=\"DSC\" name=\"method[]\" checked=\"true\"> Descartes<br />
<input type=\"checkbox\" value=\"BSDSC\" name=\"method[]\" checked=\"true\"> Bitstream Descartes<br />
<input type=\"checkbox\" value=\"RS\" name=\"method[]\" checked=\"true\"> RS<br />
</td>
<td width=25%>
Select data attributes:<br><br><br>
Type:
<select name=\"type\" value=\"VAR\">
<option value=\"VAR\">VAR</option>
<option value=\"Random\">3D Arrangments</option>
<option value=\"VoronoiEllipses\">Voronoi of Ellipses</option>
<option value=\"random\">Random</option>
<option value=\"ratroots\">Rational roots</option>
<option value=\"introots\">Integer roots</option>
<option value=\"mignotte\">Mignotte</option>
</select>
<br>Degree: 
<select name=\"degree\" value=\"VAR\">
<option value=\"VAR\">VAR</option>
<option value=\"3\">3</option>
<option value=\"5\">5</option>
<option value=\"10\">10</option>
<option value=\"12\">12</option>
<option value=\"20\">20</option>
<option value=\"30\">30</option>
<option value=\"40\">40</option>
<option value=\"50\">50</option>
<option value=\"70\">70</option>
<option value=\"100\">100</option>
<option value=\"184\">184</option>
</select>
<br>Bitsize:
<select name=\"bitsize\" value=\"VAR\">
<option value=\"VAR\">VAR</option>
<option value=\"10\">10</option>
<option value=\"30\">30</option>
<option value=\"50\">50</option>
<option value=\"200\">200</option>
<option value=\"400\">400</option>
<option value=\"600\">600</option>
<option value=\"800\">800</option>
<option value=\"1000\">1000</option>
<option value=\"1200\">1200</option>
<option value=\"1400\">1400</option>
<option value=\"1600\">1600</option>
<option value=\"1800\">1800</option>
<option value=\"2000\">2000</option>
<option value=\"3500\">3500</option>
<option value=\"4000\">4000</option>
<option value=\"6000\">6000</option>
<option value=\"8000\">8000</option>
</select>
<br><br>
Plot Range (vertical)<br>
From: <input type=\"text\" size=\"12\" maxlength=\"12\" name=\"range_from\" value=\"0\"><br />
To: <input type=\"text\" size=\"12\" maxlength=\"12\" name=\"range_end\" value=\"50\"><br />
<br>
Plot Range (horizontal)<br>
From: <input type=\"text\" size=\"12\" maxlength=\"12\" name=\"hrange_from\" value=\"0\"><br />
To: <input type=\"text\" size=\"12\" maxlength=\"12\" name=\"hrange_end\" value=\"50\"><br />
</td><td width=50%> Select which methods should be included in the table (and the graph). <br> If the type of the data is not selected (VAR), the table will be comprehensive, but the graph will be useless. <br> In order to get a graph, select either the degree or the bitsize to constrain the sets used. <br> Not all combinations of type, degree and bitsize are feasible. For example, for the 3D arrangements only degree 12 is feasible and for bitsize 4000 only Random type is available. <br> The range for the y-axis can be set in order to constrain the visible area for the graph (the table is not affected). 
<br><br>
<INPUT type=\"submit\" name=\"command\" value=\"Table only\">
<INPUT type=\"submit\" name=\"command\" value=\"Table and Graph\"></td></tr>
</table>";
}
?>
</body>
</html>


