<?php
	//starts the 1/07/2011
	if(time() > 1309471201) {
		$sql = "SELECT * FROM `kubebuilder_hof` WHERE YEAR(`date`) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND MONTH(`date`) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)";
		$query = mysql_query($sql);
		$total = mysql_num_rows($query);
		if($total == 0) {
			//Generate hall of fame of this month
			$sqlKubes = "SELECT * FROM `kubebuilder_kubes` WHERE `hof`=0 ORDER BY `score` DESC LIMIT 0,3"; //Do not exclude reported kubes from the query to prevent from last minute mass report
			$queryKubes = mysql_query($sqlKubes);
			$kubes = array();
			while ($kube = mysql_fetch_assoc($queryKubes)) {
				array_push($kubes, $kube['id']);
			}
			
			//Create HOF entry
			$date = mktime(0, 0, 0, date("m") - 1, date("d"), date("Y")); 
			$sqlHOF = "INSERT INTO `kubebuilder_hof` (`date`, `p1`, `p2`, `p3`) VALUES ( '".date("Y-m-d", $date)."', ".$kubes[0].", ".$kubes[1].", ".$kubes[2].")";
			$queryHOF = mysql_query($sqlHOF);
			
			if ($queryHOF !== false) {
				//Flag kubes as HOF kubes
				$sqlKubes = "UPDATE `kubebuilder_kubes` SET hof=1 WHERE id IN (".implode(",", $kubes).")";
				mysql_query($sqlKubes);
			}
		}
	}
?>