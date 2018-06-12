FROM maven:3-alpine as builder
ARG SONAR_URL=.
ARG NEXUS_REPOSITORY=central
ARG NEXUS_DISTRIBUTION_REPOSITORY=central
ARG MAVEN_SCM_URL=git@github.com:hyperdev-io/appstarter.git

ADD . /work

RUN mvn -f /work/pom.xml -B -DskipTests clean package \
        -Dsonar.host.url=$SONAR_URL \
        -Dnexus.repository=$NEXUS_REPOSITORY \
        -Dnexus.distribution.repository=$NEXUS_DISTRIBUTION_REPOSITORY \
        -Dmaven.scm.url=$MAVEN_SCM_URL

FROM maven:3-jdk-8-alpine
COPY --from=builder /work/target/appstarter-backend-0.1.0.jar /usr/src/app/target/appstarter-backend-0.1.0.jar 
CMD ["java", "-jar", "/usr/src/app/target/appstarter-backend-0.1.0.jar"]
