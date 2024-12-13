
# Gestion du partitionnement, de la création et du montage de disque sur Ubuntu

## 1.1 **Préparation du disque**
La VM a deux disques durs. Nous allons configurer le second disque de la manière suivante :

### Étapes :

1. **Identifier les disques disponibles**
   ```bash
   lsblk
   ```
  

2. **Créer une table de partition**
   Utilisez `cfdisk` pour initialiser le disque :
   ```bash
   sudo cfdisk /dev/sdb
   ```
   - Sélectionnez "GPT" comme type de table de partition si demandé.
   - Créez les partitions suivantes :
     - Première partition : 6G, type Linux filesystem.
     - Deuxième partition : le reste du disque, type Linux swap.
   - Enregistrez les modifications et quittez.

3. **Formater les partitions**
   - Formater la partition DATA en ext4 :
     ```bash
     sudo mkfs.ext4 -L DATA /dev/sdb1
     ```
   - Configurer la partition SWAP :
     ```bash
     sudo mkswap -L SWAP /dev/sdb2
     sudo swapon /dev/sdb2
     ```

4. **Désactiver l'ancien SWAP**
   - Identifiez l'ancien swap :
     ```bash
     cat /etc/fstab
     ```
   - Commentez ou supprimez l'entrée de l'ancien swap dans `/etc/fstab`.
     Exemple :
     ```bash
     # UUID=xxxxxx none swap sw 0 0
     ```
   - Désactivez l'ancien swap :
     ```bash
     sudo swapoff -a
     ```

   Ajoutez le nouveau swap dans `/etc/fstab` :
   ```bash
   sudo nano /etc/fstab
   ```
   Ajoutez :
   ```
   LABEL=SWAP none swap sw 0 0
   ```

5. **Vérifiez les partitions**
   ```bash
   lsblk -f
   ```

   Exemple :
   ```
   NAME   FSTYPE LABEL  SIZE MOUNTPOINT
   sdb1   ext4   DATA    6G
   sdb2   swap   SWAP    4G
   ```

---

## 1.2 **Montage**
La partition DATA doit être montée automatiquement au démarrage dans `/mnt/data` en utilisant son UUID.

### Étapes :

1. **Créer un point de montage**
   ```bash
   sudo mkdir -p /mnt/data
   ```

2. **Trouver l'UUID de la partition DATA**
   ```bash
   sudo blkid
   ```
   Exemple de sortie :
   ```
   /dev/sdb1: UUID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" TYPE="ext4" LABEL="DATA"
   ```

3. **Modifier `/etc/fstab` pour un montage automatique**
   Éditez le fichier `/etc/fstab` :
   ```bash
   sudo nano /etc/fstab
   ```
   Ajoutez la ligne suivante :
   ```
   UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data ext4 defaults 0 2
   ```

4. **Monter la partition sans redémarrer**
   ```bash
   sudo mount -a
   ```

5. **Vérifiez le montage**
   ```bash
   df -h
   ```
   Exemple de sortie :
   ```
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/sdb1       6G    0    6G    0%  /mnt/data
   ```

---

Avec ces étapes, vous avez préparé et configuré votre disque avec une partition DATA en ext4 et une partition SWAP, montée automatiquement au démarrage.
