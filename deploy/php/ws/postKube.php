<!-- 
	Renvoyer un XML de la forme présentée ici.
	Prendre les variables POST suivantes en entrée :
		name : nom du kube
		kube : données binaires du kube
	
	Définir un ID arbitraire de retour pour chaque cas d'erreur possible et créer un
	noeud <label> comme suit dans le fichier config.xml :
		<label code="errorSubmitResultID"><![CDATA[Label de l'erreur.]]></label>
-->
<?php echo "<?"; ?>xml version="1.0" encoding="UTF-8"?>
<root>
	<result>0</result>
</root>