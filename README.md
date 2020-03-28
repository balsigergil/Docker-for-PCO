<h1 align="center">Docker for PCO</h1>
<h3 align="center">Qt 5 avec Google test et PCOSyncro dans un seul conteneur</h3>
<hr>
<p align="center">
  <img src="https://img.shields.io/badge/version-v0.0.1-green?style=for-the-badge" alt="version">
  <a href="https://github.com/balsigergil/Docker-for-PCO/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange?style=for-the-badge" alt="version"></a>
  <a href="https://github.com/balsigergil/Docker-for-PCO#docker-for-pco"><img src="https://img.shields.io/badge/documentation-README-blue?style=for-the-badge" alt="documentation"></a>
  <img src="https://img.shields.io/badge/platform-linux-yellow?style=for-the-badge&logo=Linux" alt="platform">
</p>

<h4 align="center">Système de conteneurisation Docker pour Qt avec un Dockerfile, un docker-compose.yml et un Makefile, le tout sans virtualisation. Fonctionne avec liaison xOrg directement sur l'hôte.</h4>
<h4 align="center">Made by Gil Balsiger with 🧡</h4>

## Fonctionnement

Avec ce système, il n'est plus nécessaire de lancer sa machine virtuelle REDS à chaque fois que l'on veut utiliser Qt pour PCO. Qt se lance dans un conteneur Docker avec toutes les dépendences nécessaire pour travailler le cours de PCO 2020.

## Contenu

- [Installateur Qt 5](https://www.qt.io/download-open-source)
- [PCOSynchro précompilée](https://gitlab.com/reds-public/pco-synchro)
- [Google Test](https://github.com/google/googletest)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

## Démarrage rapide

### Installation des prérequis

1. **Sur Arch Linux / Manjaro** (voir [wiki.archlinux.org](https://wiki.archlinux.org/index.php/Docker#Installation))

    Il est nécessaire d'avoir Docker et docker-compose d'installé sur votre machine.

    ```
    sudo pacman -S docker docker-compose
    ```

    Il faut ensuite ajouter votre utilisateur actuel au groupe `docker` et activer le service.

    ```
    sudo usermod -aG docker $USER
    sudo systemctl enable --now docker
    ```

### Clonage du projet

Récupérez le dépot en le clonant.

```
git clone https://github.com/balsigergil/Docker-for-PCO.git
cd Docker-for-PCO
```

Créez un dossier `projects` dans le répértoire fraîchement cloné. Le nom est important, il doit s'appeler `projects`. C'est dans ce dossier que vous placerez vos projets Qt.

### Utilisation

#### Lancement de Qt

L'utilisation de Docker se fair via le Makefile fourni.

Pour lancer Qt, il suffit d'exécuter la tâche suivante.

```
make qt
```

La première fois que cette commande est executée, il vous est demandé d'installer Qt. Cette installation de fait dans une volume de Docker, dans `/home/user/Qt`, et est ainsi persitante et ne devra être faite qu'une seule fois à moins de supprimer les volumes.

Pour l'installation de Qt, il faut sélectionner la version **5.12.7**. Plus d'information dans [le PDF sur CyberLearn](https://cyberlearn.hes-so.ch/pluginfile.php/3175645/mod_resource/content/1/Guide_labos_PCO_v2020.1.0.pdf). Pour le reste, laissez les paramètres par défaut.

#### Nettoyage

Les commandes précédentes ne créent qu'un conteneur temporaire qui se supprime tout seul lorsque Qt est fermé.

Cependant si vous souhaitez supprimer les volumes créés, il est possible de le faire avec la commande suivante.

```
make mrproper
```

L'installation de Qt ainsi que vos préférences Qt sont supprimée. Vos projet sont préservés.

## Troubleshooting

N'hésitez pas à ouvrir une [issue sur GitHub](https://github.com/balsigergil/Docker-for-PCO/issues) si vous rencontrez un quelconque problème.