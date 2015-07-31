# Maven Cheats

## Maven Surefire Plugin

Cheats for Maven Surefire Plugin

### Running a Single Test

To run a single test

```
mvn -Dtest=TestCircle test
```

You may also use patterns to run a number of tests:

```
mvn -Dtest=TestCir*le test
```

And you may use multiple names/patterns separated by commas:

```
mvn -Dtest=TestSquare,TestCi*le test
```

### Running a Set of Methods in a Single Test Class

**only with Junit4.x and TestNG**

Use the following Syntax:

```
mvn -Dtest=TestCircle#mytestmethod test
```

You can use patterns:

```
mvn -Dtest=TestCircle#test* test
```

As of Surefire 2.12.1, you can select multiple methods (Junit4.x only)

```
mvn -Dtest=TestCircle#testOne+testTwo test
```

