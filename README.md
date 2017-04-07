# docker-sbt-compiler
A docker container with sbt to compile in a container. 

## Properites
This container includes:

```
Alpine OS
Java 1.8
GLIBC 2.25-r0
Scala 2.11.7
SBT 0.13.8
```

## Usage


```
docker run -it --rm -v "your/project/path:/app"  own3dh2so4/sbt-compiler sbt {sbtOption}
```

Parameters:
* **-it:**  Keep STDIN open even if not attached. Allocate a pseudo-TTY
* **--rm:**  Automatically remove the container when it exits
* **-v:** Bind mount a volume
    * "your/project/path" Path where is your project. If you launch the container in the root of your proyect you can use $PWD
    * "/app" is the path where the container search the build.sbt
* **own3dh2so4/sbt-compiler** Container name
* **sbt {sbtOption}** SBT command

### Caching sbt downloads

Like maven, sbt need libraries that it download the first time it's executed. 

The container doesn't include this libraries and your project dependencies. For this reason if you execute the last command, the container will download "all Internet". Probably it's a good idea caching this dependecies in your local host.

In maven this folder is allocated in "user/home/.m2" to sbt the folder is "userhome/.ivy2"

```
docker run -it --rm -v "$PWD:/app" -v "user/home/.ivy2:/root/.ivy2" own3dh2so4/sbt-compiler sbt {sbtOption}
```

* **-v:** Bind mount a volume
    * "user/home/.ivy2" Path where you want to save sbt dependecies
    * "/root/.ivy2" Path where the sbt search the project dependencies
    
### Example

```
$ docker run -it --rm -v "$PWD:/app" -v "$HOME/.ivy2:/root/.ivy2" own3dh2so4/sbt-compiler:sbt-0.13.8 sbt assembly
Getting org.scala-sbt sbt 0.13.13 ...
:: retrieving :: org.scala-sbt#boot-app
	confs: [default]
	50 artifacts copied, 0 already retrieved (17645kB/76ms)
Getting Scala 2.10.6 (for sbt)...
:: retrieving :: org.scala-sbt#boot-scala
	confs: [default]
	5 artifacts copied, 0 already retrieved (24494kB/31ms)
[info] Loading project definition from /app/project
[info] Set current project to spark2-fast-data-processing-book (in build file:/app/)
[warn] Multiple main classes detected.  Run 'show discoveredMainClasses' to see the list
[info] Including from cache: scala-library-2.11.7.jar
[info] Run completed in 36 milliseconds.
[info] Total number of tests run: 0
[info] Suites: completed 0, aborted 0
[info] Tests: succeeded 0, failed 0, canceled 0, ignored 0, pending 0
[info] No tests were executed.
[info] Checking every *.class/*.jar file's SHA-1.
[info] Merging files...
[warn] Merging 'META-INF/MANIFEST.MF' with strategy 'discard'
[warn] Strategy 'discard' was applied to a file
[info] Assembly up to date: /app/target/scala-2.11/myapp-1.0.jar
[success] Total time: 1 s, completed Apr 7, 2017 8:00:36 AM

```

    
