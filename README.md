# glpicreilzoohardware-install

Télécharger l'installeur depuis le dépôt GitHub officiel. (https://github.com/glpi-project/glpi-agent/releases) --> glpi-agent-1.15-linux-installer.pl

ou

wget https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-linux-installer.pl


Ouvrir un terminal dans le dossier de téléchargement. (su -)

Lancer l'installation avec la commande suivante : sudo perl glpi-agent-1.15-linux-installer.pl --server="http://192.168.1.110/front/inventory.php" --install

Vérifier le service : L'installeur crée automatiquement un service système. On vérifie qu'il tourne avec : systemctl status glpi-agent

Pour forcer la synchronisation : sudo glpi-agent --force
