# Build image Docker et déploiement dans Azure

## Envoi d'image Docker dans Azure

Générer l'image d'origine. (idéalement, avec un tag spécifique)

```ps
docker build --no-cache --tag <image_name>:<image_tag> --file <docker_file> .
```

Envoyer l'image sur le Azure Container Registry.

```ps
docker tag <image_name>:<image_tag> <acr_srv>/<image_name>:<image_tag>

docker login <acr_srv> --username <acr_user> --password <acr_pwd>

docker push <acr_srv>/<image_name>:<image_tag>
```

## Applications de type Worker => Container Apps

### Etape 1 : 1er déploiement

Créer une nouvelle Container App
- Sélectionner l'image avec la balise désirée
- Pour la configuration
  - Soit créer les variables d'environnement tout de suite, avec des valeurs non secrètes
  - Soit les créer lors de l'étape 2

### Etape 2 : Configuration via les Secrets
- Aller dans Secrets
  - Pour chaque valeur de configuration : Créer un secret
    - Le secret peut avoir une valeur provenant d'un Key Vault
  - Créer ou modifier les variables d'environnement pour les faire pointer sur les secrets

### Etape 3 : MAJ (à faire quand le worker est modifié)
- Générer la nouvelle version de l'image docker.
  - Changer de tag à chaque fois
- Pousser l'image sur le container registry
- Dans la Container App
  - Si il y a des nouvelles entrées à ajouter dans la configuration
    - Créer les secrets correspondants
  - Créer une nouvelle révision
  - Sélectionner l'image du conteneur
  - Cliquer sur modifier
  - Sélectionner la nouvelle balise d'image (tag de l'image Docker)
  - Si il y a des nouvelles entrées à ajouter dans la configuration
    - Créer les variables d'environnement et les faire pointer sur les secrets

## Application de type Web (API / Portail) => App Service

### Etape 1 : 1er déploiement

- Dans App Services, créer une Application Web
  - Dans De Base
    - Dans Publier, choisir Conteneur Docker
  - Dans Docker
    - Dans Source d'Image, choisir Registre de conteneurs Azure
    - Sélectionner le registre, l'image puis la balise

### Etape 2 : Configuration via les variables d'environnement

- Aller dans Variables d’environnement
  - Pour chaque valeur de configuration : Créer un variable
  - ⚠️ Pour les chaines de connexions, les mettre dans Chaînes de connexion plutôt que dans Paramètres de l'application ⚠️

### Etape 3b : Pour une MAJ manuelle

- Aller dans Centre de déploiement
  - Changer la balise pour la nouvelle version
  - Enregistrer

### Etape 4 (optionnelle) : Configuration du déploiement continu

- Aller dans Centre de déploiement
  - Mettre Déploiement Continu sur Activé
    - Cela va activer le WebHook dans le Container Registry

      ⚠️ Attention, le Webhook est limité par défaut au tag d'image présent sur la Web App.
      
      ⚠️ Attention, le nombre de Webhook est limité par le plan de facturation du Container Registry.
  - Optionnel : Configurer le Webhook dans le Container Registry.
