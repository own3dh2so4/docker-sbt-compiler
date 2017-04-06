# docker-sbt-compiler
Docker with sbt to compile in a container. 

```
docker build -t sbt-builder .
docker run -it -v "$PWD:/app" -v "$HOME/.ivy2:/root/.ivy2" sbt-builder sbt assembly
```
