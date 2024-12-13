#!/bin/bash

# Description : Script permettant la création automatique d'utilisateurs

# Vérification de la présence d'arguments
if [ "$#" -eq 0 ]; then
    echo "Il manque les noms d'utilisateurs en argument - Fin du script"
    exit 1
fi

# Parcourir les arguments (noms d'user)
for username in "$@"; do
    # Vérification de l'existence user
    if id "$username" &>/dev/null; then
        echo "L'utilisateur $username existe déjà"
    else
        # Création de l'user
        sudo useradd "$username"
        if [ "$?" -eq 0 ]; then
            echo "L'utilisateur $username a été créé"
        else
            echo "Erreur à la création de l'utilisateur $username"
        fi
    fi

done

exit 0
