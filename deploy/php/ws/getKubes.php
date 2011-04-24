<!-- 
	Renvoyer un XML de la forme présentée ici.
	Trier les résultats par nombre de votes décroissant, et en cas d'égalité mettre les plus récents en premier (pour laisser couler les dinosaures)
	Prendre les variables POST suivantes en entrée :
		start : premier paramètre du LIMIT (index de début)
		length : nombre d'items à récupérer (pense à le limite à quelque chose comme 100 en dur pour éviter que des malins nous fassent des select all en bidouillant les requêtes)
-->
<?php echo "<?"; ?>xml version="1.0" encoding="UTF-8"?>
<root>
	<kubes>
		<kube id="1" uid="89" pseudo="Durss" date="1303587982" votes="95" />
		<kube id="2" uid="89" pseudo="Durss" date="1303587982" votes="92" />
		<kube id="3" uid="89" pseudo="Durss" date="1303587982" votes="80" />
		<kube id="4" uid="89" pseudo="Durss" date="1303587982" votes="75" />
		<kube id="5" uid="89" pseudo="Durss" date="1303587982" votes="73" />
		<kube id="6" uid="89" pseudo="Durss" date="1303587982" votes="71" />
		<kube id="7" uid="89" pseudo="Durss" date="1303587982" votes="53" />
		<kube id="8" uid="89" pseudo="Durss" date="1303587982" votes="41" />
	</kubes>
</root>