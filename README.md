# Apache Camel ZugFERD

Apache Camel routes to create German ZugFERD PDF invoices from a simple inhouse XML input file. This creates a PDF via XSL:FO and Apache FOP and a Factur-X XML file which will be embedded into the PDF. Finally a stationary background PDF is merged into our invoice.

Because the templates for the generated file parts are in XSLT, they can easily be adapted for each business case. The approach is **not** universal for all kinds of businesses and invoiced goods and services.

This project is also a nice example project for a Apache Camel setup.

## Requirements

These routes are meant to be called via [Camel JBang](https://camel.apache.org/manual/camel-jbang.html) which needs to be set up first.

To use the background stationery (see below) you need to have the command line tool [pdftk](https://gitlab.com/pdftk-java/pdftk) installed and accessible in your execution path.

## Notes on paths
All static files needed for the route are kept in the route folder (e.g. "camel-zugferd-example"). Dynamic files, like input files, temporary files and final output files are kept in the upper directory from which it is assumed that camel is called from.

Some file references in Camel are relative to the path from which camel has been called (as in ${sys.user.dir}) like in:
```
    - to:
        uri: "file:outbox"
```
Others are relative to the called route file, like in:
```
    - to:
        uri: "xslt-saxon:createFoPdf.xslt"
```

## Starting the routes

```
camel run --source-dir=camel-zugferd-example --dev --console --port 3113 --dep=org.apache.xmlgraphics:fop:2.10
```

Necessary parameters:
* --source-dir=camel-zugferd-example: The folder where Camel JBang will find the routes to be executed
* --dep=org.apache.xmlgraphics:fop:2.10: Maven dependency to allow for ad-hoc compiling the Java code in the route definition directory (which is nice). Also see Apache FOP workarounds below.

Optional parameters:
* --dev: Development mode with hot code reload
* --console: Starts up the HTTP management endpoints at http://localhost:3113/q/... **Don't** do this on production without firewall protection!
* --port 3113: Use this port for the console instead of default 8080

## Executing the route

```
camel cmd send --endpoint=direct:invoice --body=file:camel-zugferd-example/input.xml
```

Parameters:
* --endpoint=direct:invoice: The "direct" route endpoint we want to start
* --body=file:camel-zugferd-example/input.xml: The inhouse XML file we send as an input. Here we use the example input.

The resulting invoice PDF can then be found in the /outbox directory.

## Fonts

The Noto Sans font files provided in the /fonts directory are distributed adhering to the Open Font License. The font files are actually just used as examples of how to integrate your own.

## Background stationery

There is an example stationery background PDF "Musterbrief_bp.pdf" included that will be merged as a background layer in the last step. This is very convenient if you already have stationery as PDF you would like to reuse, but it requires the command line tool pdftk to be installed. If you do not need this or pdftk is not available on your platform, you can just comment out the last step. Of course it is also possible to create the whole boilerplate in the XSL:FO part. 

## Apache FOP workarounds

The included Java bean code is only needed to fix Apache FOP's inability to work with relative file paths. It can be dropped completely along with the "--dep=..." dependency parameter if you are okay with specifying absolute paths in the /conf/fopconfig.xml file (base and fonts). Also see the comments in the code. 