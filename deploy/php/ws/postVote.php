<?php
header("Content-type: text/xml");
include '../constants.php';
include '../connection.php';
include '../secure.php';
include '../getUserInfos.php';

$result = 0;
$votesDone = 0;

if (isset($_UID, $_UNAME))
{
	if (isset($_POST['kid']))
	{
		$kid = intval($_POST['kid']);
		//Check votes of the day
		$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_evaluation` WHERE DATE(date) = DATE(NOW()) AND uid=".$_UID;
		$req = mysql_query($sql);
		if ($req === false) {
			$result	= "Sql";
		}else{
			$results = mysql_fetch_assoc($req);
			$votesDone = $results["total"];
			if ($votesDone >= MAX_VOTES_PER_DAY) {
				//Too much votes for today!
				$result = "VotesLeft";
			}else {
			
				//Check votes for this kube
				if(ONE_VOTE_PER_KUBE) {
					$sql = "SELECT COUNT(uid) as total FROM `kubebuilder_evaluation` WHERE kid=".$kid." AND uid=".$kid;
					$req = mysql_query($sql);
				}
				if (ONE_VOTE_PER_KUBE && $req === false) {
					$result	= "Sql";
				}else {
					if(ONE_VOTE_PER_KUBE) $results = mysql_fetch_assoc($req);
					if (ONE_VOTE_PER_KUBE && $results["total"] > 0) {
						//Already voted for this kube!
						$result = "AlreadyVoted";
					}else {
					
						$note = ceil($_POINTS / 200 * 5 + $_ZONES / 25000 * 5);
						//If max votes par day is not exceeded and if the user hasn't voted for this kube yet, then register everything
						$sql = "INSERT INTO `kubebuilder_evaluation` ( `kid` , `uid` , `note` ) VALUES (".$kid.", ".$_UID.", '".$note."')";
						$req = mysql_query($sql);
						$result = $req === false? "Sql" : 0;
						$votesDone += $req === false? 0 : 1;
						if($result == 0) {
							$sql = "UPDATE `kubes` SET `score`=`score`+".$note." WHERE `id`=".$kid;
							$req = mysql_query($sql);
							$result = $req === false? "Sql" : 0;
						}
					}
				}
			}
		}
	}
	else
	{
	$result = "Post";
	}
}
else
{
	$result = "Auth";
}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n";
echo "<root>\r\n";
echo "	<result votesDone='".$votesDone."' totalVotes='".MAX_VOTES_PER_DAY."'>".$result."</result>\r\n";
echo "</root>";

mysql_close();

?>