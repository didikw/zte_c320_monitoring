<?php
// php onustate.php &
// Initialize a variable into domain name
$domain1 = 'http://netapp.blitarkab.go.id';
  
// Function to get HTTP response code 
function get_http_response_code($domain1) {
    $headers = get_headers($domain1);
    return substr($headers[0], 9, 3);
}
  
// Function call 
$get_http_response_code = get_http_response_code($domain1);
  
// Display the HTTP response code
echo $get_http_response_code;

$connlok = new PDO('mysql:host=xxx;dbname=olt', 'yyy', 'zzz');
$connlok->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$lokasi = snmpwalk("10.1.2.2", "publicblitark4b", ".1.3.6.1.4.1.3902.1012.3.28.1.1.3"); 
$status = snmpwalk("10.1.2.2", "publicblitark4b", "ZXGPON-SERVICE-MIB::zxGponOntPhaseState"); 
$lastonline = snmpwalk("10.1.2.2", "publicblitark4b", "ZXGPON-SERVICE-MIB::zxGponOnuLastOnlineTime"); 
$lastoffline = snmpwalk("10.1.2.2", "publicblitark4b", "ZXGPON-SERVICE-MIB::zxGponOnuLastOfflineTime");
$onurx = snmpwalk("10.1.2.2", "publicblitark4b", ".1.3.6.1.4.1.3902.1012.3.50.12.1.1.10");
$onutx = snmpwalk("10.1.2.2", "publicblitark4b", ".1.3.6.1.4.1.3902.1012.3.50.12.1.1.14");

$sql="INSERT INTO lokasi(`waktu_lokasi`,`lokasi`) VALUES(now(),?)";
$sqlstat="INSERT INTO status(`waktu_status`,`status`) VALUES(now(),?)";
$sqllastonline="INSERT INTO onlineterakhir(`waktu_online`,`lastonline`) VALUES(now(),?)";
$sqllastoffline="INSERT INTO offlineterakhir(`waktu_offline`,`offlineterakhir`) VALUES(now(),?)";
$sqlonu = "INSERT INTO onu(`waktu_query_onu`,`onurx`, `onutx`) VALUES(now(),?,?)";

$stmt = $connlok->prepare($sql);
$stmte = $connlok->prepare($sqlstat);
$stmtee = $connlok->prepare($sqllastonline);
$stmteee = $connlok->prepare($sqllastoffline);
$stmteeee = $connlok->prepare($sqlonu);
while ($get_http_response_code = 200){
	for ($i=0;$i<=34;$i++){
		$stmt->execute([$lokasi[$i]]);
		$stmte->execute([$status[$i]]);
		$stmtee->execute([$lastonline[$i]]);
		$stmteee->execute([$lastoffline[$i]]);
		$stmteeee->execute([$onurx[$i],$onutx[$i]]);
	}
sleep(300);	
}
?>
