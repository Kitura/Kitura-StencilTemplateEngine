<p align="center">
<a href="http://kitura.io/">
<img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


<p align="center">
<a href="http://www.kitura.io/">
<img src="https://img.shields.io/badge/docs-kitura.io-1FBCE4.svg" alt="Docs">
</a>
<a href="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine">
<img src="https://travis-ci.org/IBM-Swift/Kitura-StencilTemplateEngine.svg?branch=master" alt="Build Status - Master">
</a>
<img src="https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat" alt="Mac OS X">
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
<img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
<a href="http://swift-at-ibm-slack.mybluemix.net/">
<img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
</a>
</p>

# Kitura-StencilTemplateEngine
Stencil template engine plugin

## Summary
Kitura-StencilTemplateEngine is a plugin for [Kitura Template Engine](https://github.com/IBM-Swift/Kitura-TemplateEngine.git) for using [Stencil](https://github.com/kylef/Stencil) with the `Kitura` server framework. This makes it easy to use Stencil templating, with a Kitura server, to create an HTML page with integrated Swift variables.

## Stencil Template File
The template file is basically HTML with gaps where we can insert code and variables. [Stencil](https://github.com/kylef/Stencil) is a templating language used to write a template file and Kitura-StencilTemplateEngine can use any standard Stencil template.

The [Stencil user guide](https://stencil.fuller.li/en/latest/) provides documentation and examples on writting a Stencil Template File.

By default the Kitura Router will look in the 'Views' folder for Stencil template files with the extention '.stencil'.

## Rendering the Template File

Within the Kitura server, 'Kitura-StencilTemplateEngine' is referenced through the [Kitura Template Engine](https://github.com/IBM-Swift/Kitura-TemplateEngine.git). The examples below are taken from the Kitura Template Engine api and so would work for any supported template engine.

The following code initializes a Stencil template engine and adds it to the [Kitura](https://github.com/IBM-Swift/Kitura) router.
```swift
router.add(templateEngine: StencilTemplateEngine())
```

The following example will render the Stencil template "example.stencil" and add it to our routers response. The context variable must be valid JSON format and allows you to pass variables through to the template engine.

```swift
router.get("/example") { request, response, next in
    var context: [String: Any] = ["key" : "value"]
    try response.render("example.stencil", context: context).end()
    next()
}
```

## License
This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE.txt).

