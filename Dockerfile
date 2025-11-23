# --------- Étape 1 : Build Maven -----------------
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app

# Copier pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier le code source
COPY src ./src

# Construire le fichier .jar
RUN mvn clean package -DskipTests=true


# --------- Étape 2 : Image finale ----------------
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copier le jar construit
COPY --from=build /app/target/*.jar app.jar

# Exposer le port de Spring Boot
EXPOSE 8080

# Démarrer l'application
CMD ["java", "-jar", "app.jar"]
