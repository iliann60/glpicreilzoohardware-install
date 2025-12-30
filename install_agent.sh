#!/bin/bash

# =================================================================
# Nom du script : install_glpi_agent.sh
# Rôle : Installation et configuration auto de l'agent GLPI
# Entreprise : CREILZOOHARDWARE
# =================================================================

# 1. Variables de configuration
SERVER_URL="http://192.168.1.110/market/glpi-agent/"
LOG_FILE="/var/log/glpi_install.log"

# Couleurs pour le terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}>>> Début de l'installation de l'agent GLPI pour CREILZOOHARDWARE...${NC}"

# 2. Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERREUR] Veuillez lancer ce script avec sudo.${NC}"
    exit 1
fi

# 3. Mise à jour et installation des dépendances
echo -e "${GREEN}[1/4] Installation du paquet glpi-agent...${NC}"
apt update && apt install -y glpi-agent >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Paquet installé avec succès.${NC}"
else
    echo -e "${RED}✘ Erreur lors de l'installation du paquet. Vérifiez /var/log/glpi_install.log${NC}"
    exit 1
fi

# 4. Configuration de l'adresse du serveur
echo -e "${GREEN}[2/4] Configuration du serveur GLPI (${SERVER_URL})...${NC}"
CONFIG_FILE="/etc/glpi-agent/agent.cfg"

if [ -f "$CONFIG_FILE" ]; then
    sed -i "s|^server=.*|#server=|" $CONFIG_FILE
    echo "server=$SERVER_URL" >> $CONFIG_FILE
    echo -e "${GREEN}✔ Fichier de configuration mis à jour.${NC}"
else
    echo -e "${RED}✘ Fichier de configuration introuvable.${NC}"
    exit 1
fi

# 5. Activation et redémarrage du service
echo -e "${GREEN}[3/4] Activation du service...${NC}"
systemctl enable glpi-agent >> $LOG_FILE 2>&1
systemctl restart glpi-agent >> $LOG_FILE 2>&1
echo -e "${GREEN}✔ Service glpi-agent démarré.${NC}"

# 6. Forcer l'envoi de l'inventaire immédiat
echo -e "${GREEN}[4/4] Envoi de l'inventaire vers le serveur...${NC}"
glpi-agent --force >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Inventaire envoyé !${NC}"
    echo -e "${GREEN}>>> Installation terminée avec succès.${NC}"
    echo "Machine visible sur : http://192.168.1.110/ (Parc > Ordinateurs)"
else
    echo -e "${RED}✘ L'envoi de l'inventaire a échoué. Vérifiez la connexion avec le serveur.${NC}"
fi
